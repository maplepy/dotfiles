pragma Singleton

import QtQuick
import qs.modules.common
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

/**
 * Simple hyprsunset service with automatic mode and progressive transitions.
 * In theory we don't need this because hyprsunset has a config file, but it somehow doesn't work.
 * It should also be possible to control it via hyprctl, but it doesn't work consistently either so we're just killing and launching.
 */
Singleton {
    id: root
    property string from: Config.options?.light?.night?.from ?? "19:00" 
    property string to: Config.options?.light?.night?.to ?? "06:30"
    property bool automatic: Config.options?.light?.night?.automatic && (Config?.ready ?? true)
    property int colorTemperature: Config.options?.light?.night?.colorTemperature ?? 5000
    property bool useSunSchedule: Config.options?.light?.night?.useSunSchedule ?? true
    property int transitionDuration: Config.options?.light?.night?.transitionDuration ?? 30
    property int transitionMinutes: Config.options?.light?.night?.transitionMinutes ?? 30
    property int transitionEndMinutes: Config.options?.light?.night?.transitionEndMinutes ?? 30
    property bool shouldBeOn
    property bool firstEvaluation: true
    property bool active: false

    property int effectiveFromHour: fromHour
    property int effectiveFromMinute: fromMinute
    property int effectiveToHour: toHour
    property int effectiveToMinute: toMinute

    property int fromHour: Number(from.split(":")[0])
    property int fromMinute: Number(from.split(":")[1])
    property int toHour: Number(to.split(":")[0])
    property int toMinute: Number(to.split(":")[1])

    property int clockHour: DateTime.clock.hours
    property int clockMinute: DateTime.clock.minutes

    property var manualActive
    property int manualActiveHour
    property int manualActiveMinute

    property bool isTransitioning: false
    property int currentTransitionTemp: 6500

    property int sunsetHour: 19
    property int sunsetMinute: 0
    property int sunriseHour: 6
    property int sunriseMinute: 30

    readonly property int maxTemp: 6500
    readonly property int minTemp: 1200

    function parseTime(str) {
        if (!str || typeof str !== 'string') return { hours: 0, minutes: 0 };
        const match = str.match(/(\d+):(\d+)\s*(AM|PM)?/i);
        if (!match) return { hours: 0, minutes: 0 };
        let hours = parseInt(match[1]);
        const minutes = parseInt(match[2]);
        const period = match[3];
        if (period) {
            if (period.toUpperCase() === "PM" && hours !== 12) hours += 12;
            if (period.toUpperCase() === "AM" && hours === 12) hours = 0;
        }
        return { hours, minutes };
    }

    function updateSunTimes() {
        const sunset = parseTime(Weather?.data?.sunset);
        const sunrise = parseTime(Weather?.data?.sunrise);
        if (sunset.hours === 0 && sunset.minutes === 0 && sunrise.hours === 0 && sunrise.minutes === 0) return;
        sunsetHour = sunset.hours;
        sunsetMinute = sunset.minutes;
        sunriseHour = sunrise.hours;
        sunriseMinute = sunrise.minutes;
        calculateEffectiveTimes();
    }

    function calculateEffectiveTimes() {
        if (useSunSchedule && (sunsetHour !== 0 || sunsetMinute !== 0)) {
            const transitionStart = sunsetHour * 60 + sunsetMinute - transitionMinutes;
            if (transitionStart >= 0) {
                effectiveFromHour = Math.floor(transitionStart / 60);
                effectiveFromMinute = transitionStart % 60;
            } else {
                effectiveFromHour = 23;
                effectiveFromMinute = 60 + transitionStart;
            }
            const endMinutes = sunriseHour * 60 + sunriseMinute + transitionEndMinutes;
            effectiveToHour = Math.floor((endMinutes % (24 * 60)) / 60);
            effectiveToMinute = endMinutes % 60;
        } else {
            effectiveFromHour = fromHour;
            effectiveFromMinute = fromMinute;
            effectiveToHour = toHour;
            effectiveToMinute = toMinute;
        }
    }

    function getSunTimesInMinutes() {
        return {
            sunset: sunsetHour * 60 + sunsetMinute,
            sunrise: sunriseHour * 60 + sunriseMinute,
            transitionStart: sunsetHour * 60 + sunsetMinute - transitionMinutes,
            transitionEnd: sunriseHour * 60 + sunriseMinute + transitionEndMinutes
        };
    }

    function calculateTransitionTemp(t) {
        const sun = getSunTimesInMinutes();
        const now = t;
        if (!useSunSchedule) return colorTemperature;

        if (now >= sun.transitionStart && now < sun.sunset) {
            const progress = (now - sun.transitionStart) / transitionMinutes;
            return maxTemp - (maxTemp - colorTemperature) * progress;
        } else if (now >= sun.sunset && now < sun.transitionEnd) {
            return colorTemperature;
        } else if (now >= sun.transitionEnd && now < sun.transitionEnd + transitionDuration) {
            const progress = (now - sun.transitionEnd) / transitionDuration;
            return colorTemperature - (colorTemperature - maxTemp) * progress;
        } else if (now >= sun.transitionStart - transitionDuration && now < sun.transitionStart) {
            const progress = (sun.transitionStart - now) / transitionDuration;
            return colorTemperature - (colorTemperature - maxTemp) * progress;
        }
        return maxTemp;
    }

    Connections {
        target: Weather
        function onDataChanged() {
            if (useSunSchedule) {
                updateSunTimes();
                reEvaluate();
            }
        }
    }

    onClockMinuteChanged: {
        if (useSunSchedule) {
            calculateEffectiveTimes();
        }
        reEvaluate();
        if (isTransitioning) {
            updateTransitionTemp();
        }
    }

    onUseSunScheduleChanged: {
        if (useSunSchedule) {
            updateSunTimes();
        } else {
            calculateEffectiveTimes();
        }
        manualActive = undefined;
        reEvaluate();
    }

    onAutomaticChanged: {
        root.manualActive = undefined;
        root.firstEvaluation = true;
        reEvaluate();
    }

    function inBetween(t, from, to) {
        if (from < to) {
            return (t >= from && t <= to);
        } else {
            return (t >= from || t <= to);
        }
    }

    function inTransitionWindow(t) {
        if (!useSunSchedule) return false;
        const sun = getSunTimesInMinutes();
        const startEarly = sun.transitionStart;
        const endLate = sun.transitionEnd;
        if (startEarly < 0) {
            return t >= startEarly + 24 * 60 || t <= endLate || t >= 0 && t <= endLate;
        }
        return t >= startEarly - transitionDuration && t <= endLate + transitionDuration;
    }

    function reEvaluate() {
        const t = clockHour * 60 + clockMinute;
        const from = useSunSchedule ? effectiveFromHour * 60 + effectiveFromMinute : fromHour * 60 + fromMinute;
        const to = useSunSchedule ? effectiveToHour * 60 + effectiveToMinute : toHour * 60 + toMinute;
        const manualActiveTime = manualActiveHour * 60 + manualActiveMinute;

        if (root.manualActive !== undefined && (inBetween(from, manualActiveTime, t) || inBetween(to, manualActiveTime, t))) {
            root.manualActive = undefined;
        }
        root.shouldBeOn = inBetween(t, from, to);
        root.isTransitioning = root.shouldBeOn && inTransitionWindow(t) && automatic && manualActive === undefined;
        if (firstEvaluation) {
            firstEvaluation = false;
            root.ensureState();
        }
    }

    onShouldBeOnChanged: ensureState()

    function updateTransitionTemp() {
        const t = clockHour * 60 + clockMinute;
        const newTemp = Math.round(calculateTransitionTemp(t));
        if (newTemp !== currentTransitionTemp && newTemp >= minTemp && newTemp <= maxTemp) {
            currentTransitionTemp = newTemp;
            applyTemperature(newTemp);
        }
    }

    function ensureState() {
        if (!root.automatic || root.manualActive !== undefined)
            return;
        if (root.shouldBeOn) {
            if (isTransitioning) {
                updateTransitionTemp();
            } else {
                root.enable();
            }
        } else {
            root.disable();
        }
    }

    function load() { }

    function enable() {
        root.active = true;
        const temp = isTransitioning ? currentTransitionTemp : colorTemperature;
        Quickshell.execDetached(["bash", "-c", `pidof hyprsunset || hyprsunset --temperature ${temp}`]);
    }

    function disable() {
        root.active = false;
        root.isTransitioning = false;
        Quickshell.execDetached(["bash", "-c", `pkill hyprsunset`]);
    }

    function applyTemperature(temp) {
        Quickshell.execDetached(["bash", "-c", `hyprsunset --temperature ${temp}`]);
    }

    function fetchState() {
        fetchProc.running = true;
    }

    Process {
        id: fetchProc
        running: true
        command: ["bash", "-c", "hyprctl hyprsunset temperature"]
        stdout: StdioCollector {
            id: stateCollector
            onStreamFinished: {
                const output = stateCollector.text.trim();
                if (output.length == 0 || output.startsWith("Couldn't"))
                    root.active = false;
                else
                    root.active = (output != "6500");
            }
        }
    }

    function toggle(active = undefined) {
        if (root.manualActive === undefined) {
            root.manualActive = root.active;
            root.manualActiveHour = root.clockHour;
            root.manualActiveMinute = root.clockMinute;
        }

        root.manualActive = active !== undefined ? active : !root.manualActive;
        root.isTransitioning = false;
        if (root.manualActive) {
            root.enable();
        } else {
            root.disable();
        }
    }

    Connections {
        target: Config.options.light.night
        function onColorTemperatureChanged() {
            if (!root.active || root.isTransitioning) return;
            Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", `${Config.options.light.night.colorTemperature}`]);
        }
    }
}

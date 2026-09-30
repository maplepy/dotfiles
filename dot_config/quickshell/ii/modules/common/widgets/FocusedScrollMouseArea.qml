import QtQuick

// Right side | scroll to change volume
MouseArea {
    id: root

    property bool hovered: false
    property real lastScrollX: 0
    property real lastScrollY: 0
    property bool trackingScroll: false
    property real moveThreshold: 20
    // ponytail: high-res scroll wheels (e.g. G502 in ratchet mode) can split one
    // physical click into several smaller wheel events. Accumulate to a full
    // 120-unit notch before firing so one click = one step, not several.
    property real wheelAccumulator: 0

    signal scrollUp(int delta)
    signal scrollDown(int delta)
    signal movedAway()

    acceptedButtons: Qt.LeftButton
    hoverEnabled: true
    onEntered: {
        root.hovered = true;
    }
    onExited: {
        root.hovered = false;
        root.trackingScroll = false;
    }
    onWheel: (event) => {
        root.wheelAccumulator += event.angleDelta.y;
        while (root.wheelAccumulator <= -120) {
            root.wheelAccumulator += 120;
            root.scrollDown(-120);
        }
        while (root.wheelAccumulator >= 120) {
            root.wheelAccumulator -= 120;
            root.scrollUp(120);
        }
        // Store the mouse position and start tracking
        root.lastScrollX = event.x;
        root.lastScrollY = event.y;
        root.trackingScroll = true;
    }
    onPositionChanged: (mouse) => {
        if (root.trackingScroll) {
            const dx = mouse.x - root.lastScrollX;
            const dy = mouse.y - root.lastScrollY;
            if (Math.sqrt(dx * dx + dy * dy) > root.moveThreshold) {
                root.movedAway();
                root.trackingScroll = false;
            }
        }
    }
    onContainsMouseChanged: {
        if (!root.containsMouse && root.trackingScroll) {
            root.movedAway();
            root.trackingScroll = false;
        }
    }
}

pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root
    property bool active: false
    property var flow: null
    property bool interactionAvailable: false
    property string cleanMessage: {
        if (!root.flow) return "";
        return root.flow.message.endsWith(".")
            ? root.flow.message.slice(0, -1)
            : root.flow.message
    }
    property string cleanPrompt: {
        const inputPrompt = PolkitService.flow?.inputPrompt.trim() ?? "";
        const cleanedInputPrompt = inputPrompt.endsWith(":") ? inputPrompt.slice(0, -1) : inputPrompt;
        const usePasswordChars = !PolkitService.flow?.responseVisible ?? true
        return cleanedInputPrompt || (usePasswordChars ? ("Password") : ("Input"))
    }

    function cancel() {
        interactionAvailable = false
    }

    function submit(string) {
        root.interactionAvailable = false
    }
}

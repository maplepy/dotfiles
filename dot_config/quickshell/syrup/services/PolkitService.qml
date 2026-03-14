pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root

    // Compatibility fallback for builds without Quickshell.Services.Polkit.
    property QtObject agent: QtObject {
        property bool isActive: false
        property QtObject flow: QtObject {
            property string message: ""
            property string inputPrompt: ""
            property bool responseVisible: false
            function cancelAuthenticationRequest() {}
            function submit(_value) {}
        }
    }
    property bool active: false
    property QtObject flow: agent.flow
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
        return cleanedInputPrompt || (usePasswordChars ? Translation.tr("Password") : Translation.tr("Input"))
    }

    function cancel() {
        root.flow.cancelAuthenticationRequest()
    }

    function submit(string) {
        root.flow.submit(string)
        root.interactionAvailable = false
    }
}

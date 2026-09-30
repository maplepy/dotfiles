import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

Loader {
    id: root

    property bool vertical: false
    property color color: Appearance.colors.colOnSurfaceVariant

    function abbreviateLayoutCode(fullCode) {
        return fullCode.split(':').map((layout) => {
            const baseLayout = layout.split('-')[0];
            return baseLayout.slice(0, 4);
        }).join('\n');
    }

    active: HyprlandXkb.layoutCodes.length > 1
    visible: active

    sourceComponent: Item {
        implicitWidth: root.vertical ? null : layoutCodeText.implicitWidth
        implicitHeight: root.vertical ? layoutCodeText.implicitHeight : null

        StyledText {
            id: layoutCodeText

            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            text: abbreviateLayoutCode(HyprlandXkb.currentLayoutCode)
            font.pixelSize: text.includes("\n") ? Appearance.font.pixelSize.smallie : Appearance.font.pixelSize.small
            color: root.color
            animateChange: true
        }

    }

}

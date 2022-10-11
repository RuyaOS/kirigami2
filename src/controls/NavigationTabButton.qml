/* SPDX-FileCopyrightText: 2021 Devin Lin <espidev@gmail.com>
 * SPDX-FileCopyrightText: 2021 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

/**
 * @brief Navigation buttons to be used for the NavigationTabBar component.
 * 
 * Alternative way to the "actions" property on NavigationTabBar, as it can be used
 * with Repeater to generate buttons from models.
 * 
 * Example usage:
 * @code{.qml}
 * Kirigami.NavigationTabBar {
 *      id: navTabBar
 *      Kirigami.NavigationTabButton {
 *          visible: true
 *          icon.name: "document-save"
 *          text: `test ${tabIndex + 1}`
 *          QQC2.ButtonGroup.group: navTabBar.tabGroup
 *      }
 *      Kirigami.NavigationTabButton {
 *          visible: false
 *          icon.name: "document-send"
 *          text: `test ${tabIndex + 1}`
 *          QQC2.ButtonGroup.group: navTabBar.tabGroup
 *      }
 *      actions: [
 *          Kirigami.Action {
 *              visible: true
 *              icon.name: "edit-copy"
 *              icon.height: 32
 *              icon.width: 32
 *              text: `test 3`
 *              checked: true
 *          },
 *          Kirigami.Action {
 *              visible: true
 *              icon.name: "edit-cut"
 *              text: `test 4`
 *              checkable: true
 *          },
 *          Kirigami.Action {
 *              visible: false
 *              icon.name: "edit-paste"
 *              text: `test 5`
 *          },
 *          Kirigami.Action {
 *              visible: true
 *              icon.source: "../logo.png"
 *              text: `test 6`
 *              checkable: true
 *          }
 *      ]
 *  }
 * @endcode
 * 
 * @since 5.87
 * @since org.kde.kirigami 2.19
 * @inherit QtQuick.Templates.TabButton
 */
T.TabButton {
    id: control

    /**
     * @brief This property tells the index of this tab within the tab bar.
     */
    readonly property int tabIndex: {
        let tabIdx = 0
        for (let i = 0; i < parent.children.length; ++i) {
            if (parent.children[i] === this) return tabIdx
            // Checking for AbstractButtons because any AbstractButton can act as a tab
            if (parent.children[i] instanceof T.AbstractButton) {
                ++tabIdx
            }
        }
        return -1
    }
    
    /**
     * @brief This property sets whether the icon colors should be masked with a single color.
     *
     * default: ``true``
     *
     * @since 5.96
     */
    property bool recolorIcon: true

    property color foregroundColor: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.85)
    property color highlightForegroundColor: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.85)
    property color highlightBarColor: Kirigami.Theme.highlightColor

    property color pressedColor: Qt.rgba(highlightBarColor.r, highlightBarColor.g, highlightBarColor.b, 0.3)
    property color hoverSelectColor: Qt.rgba(highlightBarColor.r, highlightBarColor.g, highlightBarColor.b, 0.2)
    property color checkedBorderColor: Qt.rgba(highlightBarColor.r, highlightBarColor.g, highlightBarColor.b, 0.7)
    property color pressedBorderColor: Qt.rgba(highlightBarColor.r, highlightBarColor.g, highlightBarColor.b, 0.9)

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    width: {
        // Counting buttons because Repeaters can be counted among visibleChildren
        let visibleButtonCount = 0, minWidth = height * 0.75;
        for (let i = 0; i < parent.visibleChildren.length; ++i) {
            if (parent.width / visibleButtonCount >= minWidth && // make buttons go off the screen if there is physically no room for them
                parent.visibleChildren[i] instanceof T.AbstractButton) { // Checking for AbstractButtons because any AbstractButton can act as a tab
                ++visibleButtonCount
            }
        }
        
        return Math.round(parent.width / visibleButtonCount)
    }

    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    Kirigami.Theme.inherit: false

    // not using the hover handler built into control, since it seems to misbehave and 
    // permanently report hovered after a touch event
    HoverHandler {
        id: hoverHandler
    }

    padding: Kirigami.Units.smallSpacing
    spacing: Kirigami.Units.smallSpacing

    icon.height: Kirigami.Units.iconSizes.smallMedium
    icon.width: Kirigami.Units.iconSizes.smallMedium
    icon.color: control.checked ? control.highlightForegroundColor : control.foregroundColor

    background: Rectangle {
        Kirigami.Theme.colorSet: Kirigami.Theme.Button
        Kirigami.Theme.inherit: false

        implicitHeight: Kirigami.Units.gridUnit * 3 + Kirigami.Units.smallSpacing * 2

        color: "transparent"

        Rectangle {
            width: parent.width - Kirigami.Units.largeSpacing
            height: parent.height - Kirigami.Units.largeSpacing
            anchors.centerIn: parent

            radius: Kirigami.Units.smallSpacing
            color: control.pressed ? pressedColor : (control.checked || hoverHandler.hovered ? hoverSelectColor : "transparent")

            border.color: control.checked ? checkedBorderColor : (control.pressed ? pressedBorderColor : color)
            border.width: 1

            Behavior on color { ColorAnimation { duration: Kirigami.Units.shortDuration } }
            Behavior on border.color { ColorAnimation { duration: Kirigami.Units.shortDuration } }
        }
    }

    contentItem: ColumnLayout {
        spacing: label.lineCount > 1 ? 0 : control.spacing

        Kirigami.Icon {
            id: icon
            source: control.icon.name || control.icon.source
            isMask: control.recolorIcon
            Layout.alignment: Qt.AlignHCenter | (label.lineCount > 1 ? 0 : Qt.AlignBottom)
            implicitHeight: source ? control.icon.height : 0
            implicitWidth: source ? control.icon.width : 0
            visible: control.icon.name !== '' && control.icon.source !== ''
            color: control.icon.color
            Behavior on color { ColorAnimation {} }
            Behavior on opacity { NumberAnimation {} }
        }
        QQC2.Label {
            id: label
            Kirigami.MnemonicData.enabled: control.enabled && control.visible
            Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.MenuItem
            Kirigami.MnemonicData.label: control.text

            text: Kirigami.MnemonicData.richTextLabel
            Layout.alignment: icon.visible ? Qt.AlignHCenter | Qt.AlignTop : Qt.AlignCenter
            horizontalAlignment: Text.AlignHCenter

            wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            color: control.checked ? control.highlightForegroundColor : control.foregroundColor
            font.bold: control.checked
            font.family: Kirigami.Theme.smallFont.family
            font.pointSize: icon.visible ? Kirigami.Theme.smallFont.pointSize : Kirigami.Theme.defaultFont.pointSize * 1.20 // 1.20 is equivalent to level 2 heading

            Behavior on color { ColorAnimation {} }
            Behavior on opacity { NumberAnimation {} }

            // Work around bold text changing implicit size
            Layout.preferredWidth: boldMetrics.implicitWidth
            Layout.preferredHeight: boldMetrics.implicitHeight * label.lineCount
            Layout.fillWidth: true

            QQC2.Label {
                id: boldMetrics
                visible: false
                text: parent.text
                font.bold: true
                font.family: Kirigami.Theme.smallFont.family
                font.pointSize: Kirigami.Theme.smallFont.pointSize
                horizontalAlignment: Text.AlignHCenter
                wrapMode: QQC2.Label.Wrap
                elide: Text.ElideMiddle
            }
        }
    }
}

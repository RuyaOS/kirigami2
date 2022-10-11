/*
 *  SPDX-FileCopyrightText: 2019 Carl-Lucien Schwan <carl@carlschwan.eu>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls

import org.kde.kirigami 2.20 as Kirigami

/**
 * This is advanced textfield. It is recommended to use this class when there
 * is a need to create a create a textfield with action buttons (e.g a clear
 * action).
 *
 * Example usage for a search field:
 * @code
 * import org.kde.kirigami 2.20 as Kirigami
 *
 * Kirigami.ActionTextField {
 *     id: searchField
 *
 *     placeholderText: i18n("Search...")
 *
 *     focusSequence: "Ctrl+F"
 *
 *     rightActions: Kirigami.Action {
 *         icon.name: "edit-clear"
 *         visible: searchField.text !== ""
 *         onTriggered: {
 *             searchField.text = ""
 *             searchField.accepted()
 *         }
 *     }
 *
 *     onAccepted: console.log("Search text is " + searchField.text)
 * }
 * @endcode
 *
 * @since 5.56
 * @inherit QtQuick.Controls.TextField
 */
Controls.TextField
{
    id: root

    /**
     * @brief This property holds a shortcut sequence that will focus the text field.
     * @since 5.56
     */
    property string focusSequence

    /**
     * @brief This property holds a list of actions that will be displayed on the left side of the text field.
     *
     * By default this list is empty.
     *
     * @since 5.56
     */
    property list<QtObject> leftActions

    /**
     * @brief This property holds a list of actions that will be displayed on the right side of the text field.
     *
     * By default this list is empty.
     *
     * @since 5.56
     */
    property list<QtObject> rightActions

    property alias _leftActionsRow: leftActionsRow
    property alias _rightActionsRow: rightActionsRow

    hoverEnabled: true

    horizontalAlignment: Qt.AlignLeft
    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    leftPadding: Kirigami.Units.smallSpacing + (LayoutMirroring.enabled ? rightActionsRow : leftActionsRow).width
    rightPadding: Kirigami.Units.smallSpacing + (LayoutMirroring.enabled ? leftActionsRow : rightActionsRow).width

    Behavior on leftPadding {
        NumberAnimation {
            duration: Kirigami.Units.longDuration
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on rightPadding {
        NumberAnimation {
            duration: Kirigami.Units.longDuration
            easing.type: Easing.InOutQuad
        }
    }

    Shortcut {
        id: focusShortcut
        enabled: root.focusSequence
        sequence: root.focusSequence
        onActivated: {
            root.forceActiveFocus()
            root.selectAll()
        }
    }

    Controls.ToolTip {
        visible: root.focusSequence && root.text.length === 0 && !rightActionsRow.hovered && !leftActionsRow.hovered && hovered
        text: root.focusSequence ? root.focusSequence : ""
    }

    Row {
        id: leftActionsRow
        padding: Kirigami.Units.smallSpacing
        spacing: Kirigami.Units.smallSpacing
        layoutDirection: Qt.LeftToRight
        anchors.left: parent.left
        anchors.leftMargin: Kirigami.Units.smallSpacing
        anchors.top: parent.top
        anchors.topMargin: parent.topPadding
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.bottomPadding
        Repeater {
            model: root.leftActions
            Kirigami.Icon {
                implicitWidth: Kirigami.Units.iconSizes.sizeForLabels
                implicitHeight: Kirigami.Units.iconSizes.sizeForLabels

                anchors.verticalCenter: parent.verticalCenter

                source: modelData.icon.name.length > 0 ? modelData.icon.name : modelData.icon.source
                active: leftActionArea.containsPress
                visible: modelData.visible
                enabled: modelData.enabled
                MouseArea {
                    id: leftActionArea
                    anchors.fill: parent
                    onClicked: modelData.trigger()
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }

    Row {
        id: rightActionsRow
        padding: Kirigami.Units.smallSpacing
        spacing: Kirigami.Units.smallSpacing
        layoutDirection: Qt.RightToLeft
        anchors.right: parent.right
        anchors.rightMargin: Kirigami.Units.smallSpacing
        anchors.top: parent.top
        anchors.topMargin: parent.topPadding
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.bottomPadding
        Repeater {
            model: root.rightActions
            Kirigami.Icon {
                implicitWidth: Kirigami.Units.iconSizes.sizeForLabels
                implicitHeight: Kirigami.Units.iconSizes.sizeForLabels

                anchors.verticalCenter: parent.verticalCenter

                source: modelData.icon.name.length > 0 ? modelData.icon.name : modelData.icon.source
                active: rightActionArea.containsPress
                visible: modelData.visible
                enabled: modelData.enabled
                MouseArea {
                    id: rightActionArea
                    anchors.fill: parent
                    onClicked: modelData.trigger()
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}

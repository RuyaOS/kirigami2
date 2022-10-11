
/*
 *  SPDX-FileCopyrightText: 2019 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */
import QtQuick 2.15
import org.kde.kirigami 2.15 as Kirigami

/**
 * @brief This is the default background for Cards.
 *
 * It provides background feedback on hover and click events, border customizability, and the ability to change the radius of each individual corner.
 *
 * @inherit org::kde::kirigami::ShadowedRectangle
 */
Kirigami.ShadowedRectangle {
    id: root

//BEGIN properties
    /**
     * @brief This property sets whether there should be a background change on a click event.
     *
     * default: ``false``
     */
    property bool clickFeedback: false

    /**
     * @brief This property sets whether there should be a background change on a click event.
     *
     * default: ``false``
     */
    property bool hoverFeedback: false

    /**
     * @brief This property holds the card's normal background color.
     *
     * default: ``Kirigami.Theme.backgroundColor``
     */
    property color defaultColor: Kirigami.Theme.backgroundColor

    /**
     * @brief This property holds the color displayed when a click event is triggered.
     * @see DefaultCardBackground::clickFeedback
     */
    property color pressedColor: Kirigami.ColorUtils.tintWithAlpha(
                                     defaultColor,
                                     Kirigami.Theme.highlightColor, 0.3)

    /**
     * @brief This property holds the color displayed when a hover event is triggered.
     * @see DefaultCardBackground::hoverFeedback
     */
    property color hoverColor: Kirigami.ColorUtils.tintWithAlpha(
                                   defaultColor,
                                   Kirigami.Theme.highlightColor, 0.1)

    /**
     * @brief This property holds the border width which is displayed at the edge of DefaultCardBackground.
     *
     * default: ``1``
     */
    property int borderWidth: 1

    /**
     * @brief This property holds the border color which is displayed at the edge of DefaultCardBackground.
     */
    property color borderColor: Kirigami.ColorUtils.tintWithAlpha(
                                    color, Kirigami.Theme.textColor, 0.2)
//END properties

    color: {
        if (clickFeedback && (parent.down || parent.highlighted))
            return root.pressedColor
        else if (hoverFeedback && parent.hovered)
            return root.hoverColor
        return defaultColor
    }
    radius: Kirigami.Units.smallSpacing
    shadow {
        size: Kirigami.Units.largeSpacing
        color: Qt.rgba(0, 0, 0, 0.2)
        yOffset: 2
    }

    border {
        width: borderWidth
        color: borderColor
    }
}

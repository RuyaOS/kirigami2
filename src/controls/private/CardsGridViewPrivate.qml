/*
 *  SPDX-FileCopyrightText: 2018 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.10
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.4 as Kirigami


GridView {
    id: root

    property Component _delegateComponent


    QtObject {
        id: calculations

        // initialize array so length property can be read
        property var leftMargins: []
        readonly property int delegateWidth: Math.min(cellWidth, maximumColumnWidth) - Kirigami.Units.largeSpacing * 2
    }

    delegate: Kirigami.DelegateRecycler {
        width: calculations.delegateWidth

        anchors.left: parent.left

        sourceComponent: root._delegateComponent
        onWidthChanged: {
            let columnIndex = index % root.columns
            if (index < root.columns) {
                // calulate left margin per column
                calculations.leftMargins[columnIndex] = (width + Kirigami.Units.largeSpacing * 2)
                        * (columnIndex) + root.width / 2
                        - (root.columns * (width + Kirigami.Units.largeSpacing * 2)) / 2;
            }
            anchors.leftMargin = calculations.leftMargins[columnIndex];
        }
    }
    onWidthChanged: {
        if (calculations.leftMargins.length !== root.columns) {
            calculations.leftMargins = new Array(root.columns);
        }
    }
}

//
// This file is part of Sugar Dark, a theme for the Simple Display Desktop Manager.
//
// Copyright 2018 Marian Arlt
//
// Sugar Dark is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Sugar Dark is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Sugar Dark. If not, see <https://www.gnu.org/licenses/>.
//

import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4

RowLayout {

    spacing: root.font.pointSize

    property var suspend: ["Suspend", config.TranslateSuspend || textConstants.suspend, sddm.canSuspend, config.GreenColor]
    property var hibernate: ["Hibernate", config.TranslateHibernate || textConstants.hibernate, sddm.canHibernate, config.YellowColor]
    property var reboot: ["Reboot", config.TranslateReboot || textConstants.reboot, sddm.canReboot, config.OrangeColor]
    property var shutdown: ["Shutdown", config.TranslateShutdown || textConstants.shutdown, sddm.canPowerOff, config.RedColor]

    property Control exposedLogin

    Repeater {

        model: [suspend, hibernate, reboot, shutdown]

        RoundButton {
            id: icon
            text: modelData[1]
            font.pointSize: root.font.pointSize * 0.8
            Layout.alignment: Qt.AlignHCenter
            icon.source: modelData ? Qt.resolvedUrl("../Assets/" + modelData[0] + ".svg") : ""
            icon.height: 2 * Math.round((root.font.pointSize * 3) / 2)
            icon.width: 2 * Math.round((root.font.pointSize * 3) / 2)
            icon.color: modelData[3]
            display: AbstractButton.TextUnderIcon
            visible: modelData[2]
            hoverEnabled: true
            palette.buttonText: modelData[3]
            background: Rectangle {
                height: 2
                color: "transparent"
                width: parent.width
                border.width: parent.visualFocus ? 1 : 0
                border.color: "transparent"
                anchors.top: parent.bottom
            }
            Keys.onReturnPressed: clicked()
            onClicked: {
                parent.forceActiveFocus()
                index == 0 ? sddm.suspend() : index == 1 ? sddm.hibernate() : index == 2 ? sddm.reboot() : sddm.powerOff()
            }
            KeyNavigation.up: exposedLogin
            KeyNavigation.left: index == 0 ? exposedLogin : parent.children[index-1]

            states: [
                State {
                    name: "pressed"
                    when: parent.children[index].down
                    PropertyChanges {
                        target: parent.children[index]
                        palette.buttonText: Qt.darker(modelData[3], 1.2)
                    }
                    PropertyChanges {
                        target: parent.children[index].background
                        border.color: Qt.darker(modelData[3], 1.2)
                    }
                    PropertyChanges {
                        target: parent.children[index].icon
                        color: Qt.darker(modelData[3], 1.5)
                    }
                },
                State {
                    name: "hovered"
                    when: parent.children[index].hovered
                    PropertyChanges {
                        target: parent.children[index]
                        palette.buttonText: Qt.lighter(modelData[3], 1.2)
                    }
                    PropertyChanges {
                        target: parent.children[index].background
                        border.color: Qt.lighter(modelData[3], 1.2)
                    }
                    PropertyChanges {
                        target: parent.children[index].icon
                        color: Qt.lighter(modelData[3], 1.5)
                    }
                },
                State {
                    name: "focused"
                    when: parent.children[index].visualFocus
                    PropertyChanges {
                        target: parent.children[index]
                        palette.buttonText: modelData[3]
                    }
                    PropertyChanges {
                        target: parent.children[index].background
                        border.color: modelData[3]
                    }
                }
            ]

            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "palette.buttonText, border.color"
                        duration: 150
                    }
                }
            ]

        }

    }

}

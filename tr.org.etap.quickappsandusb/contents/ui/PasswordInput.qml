/*****************************************************************************
 *   Copyright (C) 2018 by Yunusemre Şentürk                                 *
 *   <yunusemre.senturk@pardus.org.tr>                                       *
 *                                                                           *
 *   This program is free software; you can redistribute it and/or modify    *
 *   it under the terms of the GNU General Public License as published by    *
 *   the Free Software Foundation; either version 2 of the License, or       *
 *   (at your option) any later version.                                     *
 *                                                                           *
 *   This program is distributed in the hope that it will be useful,         *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *   GNU General Public License for more details.                            *
 *                                                                           *
 *   You should have received a copy of the GNU General Public License       *
 *   along with this program; if not, write to the                           *
 *   Free Software Foundation, Inc.,                                         *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .          *
 *****************************************************************************/

import QtQuick 1.1
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
/**
 * This qml component works like simple transition animation multi components
 * and stands for entering password input according to user type as a teacher
 * for Interactive White Board.
 */
Rectangle {
    id:pop
    color:"#34353a"
    height: minimumWidth * 22 /100
    width: minimumWidth
    property bool isActive : inp.activeFocus
    property string pinCode : inp.text
    Item {
        height: pop.height
        width: minimumWidth
        anchors{
            left: parent.left
            leftMargin: lineAlign / 4
        }
        Row {
            id: mainRow
            spacing: lineAlign / 3
            anchors {
                horizontalCenter: parent.horizontalCenter

            }
            Rectangle {
                id:cancelButtonCover
                visible: true
                color: "transparent"
                height: minimumWidth * 22 /100
                width: cancelButtonCover.height

                anchors{

                    verticalCenter:parent.verticalCenter
                }

                PlasmaWidgets.IconWidget {
                    id: cancelButton
                    icon:QIcon("window-close")
                    anchors.fill:parent
                    onClicked: {
                        widgetrepresenter.state = 'invisible';
                        ebatext.color= "#969699";
                        plasmoid.runCommand("qdbus",["org.eta.virtualkeyboard",
                                                     "/VirtualKeyboard",
                                                     "org.eta.virtualkeyboard.hidePinInput"]);
                    }
                }
            }
            Row {
                id: centerRow
                spacing: lineAlign / 2
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    id:input1
                    height: minimumWidth * 17 /100
                    width: minimumWidth * 50 /100
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    color: "#ffffff"
                    border.color: "#000000"
                    border.width: 3
                    radius: 2

                    TextInput {
                        //inputMask: "9999"
                        id:inp
                        echoMode: TextInput.Password
                        font.bold: true
                        font.pointSize: 14
                        smooth: true
                        horizontalAlignment: Text.AlignHCenter
                        maximumLength: 4
                        //color: "#ffffff"
                        anchors {
                            top: parent.top
                            topMargin: parent.height/4
                            bottom: parent.bottom
                            left: parent.left
                            right: parent.right
                        }

                        onAccepted: {
                            if(activeFocus) {
                                if(widgetrepresenter.state == 'visible') {
                                    plasmoid.runCommand("qdbus",["org.eta.virtualkeyboard",
                                                                 "/VirtualKeyboard",
                                                                 "org.eta.virtualkeyboard.showPinInput"]);
                                }
                            }
                        }
                        onActiveFocusChanged: {
                            pop.isActive = activeFocus
                            if(activeFocus) {
                                if(widgetrepresenter.state == 'visible') {
                                    plasmoid.runCommand("qdbus",["org.eta.virtualkeyboard",
                                                                 "/VirtualKeyboard",
                                                                 "org.eta.virtualkeyboard.showPinInput"]);
                                }


                            } else {
                                plasmoid.runCommand("qdbus",["org.eta.virtualkeyboard",
                                                             "/VirtualKeyboard",
                                                             "org.eta.virtualkeyboard.hidePinInput"]);
                            }
                        }
                        onActiveFocusOnPressChanged: {
                            if(activeFocus) {
                                if(widgetrepresenter.state == 'visible') {
                                    plasmoid.runCommand("qdbus",["org.eta.virtualkeyboard",
                                                                 "/VirtualKeyboard",
                                                                 "org.eta.virtualkeyboard.showPinInput"]);
                                }
                            }
                        }
                        onTextChanged: {
                            pop.pinCode = inp.text
                        }

                    }
                }
            }

            Rectangle {
                id:doneButtonCover
                visible: true
                color: "transparent"
                height: minimumWidth * 22 /100
                width: doneButtonCover.height

                anchors{

                    verticalCenter:parent.verticalCenter
                }
                PlasmaWidgets.IconWidget {
                    id: doneButton
                    icon:QIcon("mail-forward")
                    anchors.fill:parent
                    onClicked: {
                        if (inp.text.length == 4) {
                            widgetrepresenter.state = 'invisible';

                            plasmoid.runCommand("/usr/bin/eta_usblogin",["eba","-p",inp.text.toString()]);
                            plasmoid.runCommand("qdbus",["org.eta.virtualkeyboard",
                                                         "/VirtualKeyboard",
                                                         "org.eta.virtualkeyboard.hidePinInput"]);
                            inp.text = ""
                        }
                        ebatext.color= "#969699";
                    }
                }
            }

        }
        MouseArea {
            id: allMa
            anchors {
                top: mainRow.top
                bottom: mainRow.bottom
                left: mainRow.left
                right: doneButtonMa.left

            }

            onPressAndHold: { doneButton.color= "light green"; }
            onPressed: {doneButton.color= "light green"; }
            onReleased: {
                //plasmoid.runCommand("/usr/bin/etahelp");
                //doneButton.color= "green";
                //widgetrepresenter.state = 'invisible';
                ebatext.color= "#969699";
                plasmoid.runCommand("qdbus",["org.eta.virtualkeyboard",
                                             "/VirtualKeyboard",
                                             "org.eta.virtualkeyboard.hidePinInput"]);
            }

        }

    }


}// passwordInputArea

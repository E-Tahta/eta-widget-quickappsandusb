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
import Qt 4.7
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.runnermodel 0.1 as RunnerModels
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets


/**
 * This qml component specifically prepared for Interactive White Board.
 *
 * It shows some specific application launchers for quick use of them
 * by regarding the current user.
 */
Item {
    id: widgetrepresenter

    property int minimumWidth: screenData.data["Local"]["width"]*14/100
    property string username : userDataSource.data["Local"]["loginname"]
    property int minimumHeight: calculateHeight(username)
    property int leftRightAlign: minimumWidth * 9 / 100
    property int lineAlign: minimumWidth * 7 / 100
    property int textAlign: minimumWidth *4 / 100
    property int toolButtonIconSize : minimumWidth * 21 / 100
    property int toolContainerHeight: minimumWidth * 22 / 100

    property string textColor: "#969699"
    property string textPressedColor: "#FF6C00"

    Column {
        anchors.fill:parent
        Rectangle {
            id: fileManagerContainer
            width: minimumWidth
            height: toolContainerHeight
            color: "transparent"

            Item {
                id:fileManagerIconContainer
                height: parent.height
                width: toolButtonIconSize
                anchors {
                    left:  parent.left
                    leftMargin: leftRightAlign
                    verticalCenter: parent.verticalCenter
                }
                PlasmaWidgets.IconWidget {
                    id: fileManagerIcon
                    anchors.fill:parent
                    onClicked: {
                        plasmoid.runCommand("xdg-open", ["."])
                    }
                    Component.onCompleted: {
                        setIcon("eta-file-manager")
                    }
                }
            }

            Item {
                height: fileManagerContainer.height
                width: fileManagerContainer.width - height - leftRightAlign
                anchors {
                    left:fileManagerIconContainer.right
                    verticalCenter: parent.verticalCenter
                }
                Text {
                    id:fileManagerText
                    text: "DOSYALARIM"
                    color: textColor
                    font.family:textFont
                    font.bold : true
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideLeft
                    anchors {
                        left: parent.left
                        leftMargin: textAlign
                        right: parent.right
                        rightMargin: textAlign
                        verticalCenter: parent.verticalCenter
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onPressAndHold: { fileManagerText.color= textPressedColor }
                    onPressed: { fileManagerText.color= textPressedColor }
                    onReleased: { fileManagerText.color= textColor }
                    onClicked: { fileManagerIcon.clicked() }
                }
            }
        }

        Rectangle {
            id:usb
            width: minimumWidth
            height: toolContainerHeight
            color: "transparent"
            Item {
                id:usbIconContainer
                height: parent.height
                width: toolButtonIconSize
                anchors {
                    left:  parent.left
                    leftMargin: leftRightAlign
                    verticalCenter: parent.verticalCenter
                }
                PlasmaWidgets.IconWidget {
                    id: usbIcon
                    anchors.fill:parent
                    onClicked: {
                        plasmoid.togglePopup()
                    }
                    Component.onCompleted: {
                        setIcon("eta-usb")
                    }
                }
            }
            Item {
                height: usb.height
                width: usb.width - height - leftRightAlign - usbArrowIconContainer.width
                anchors {
                    left:usbIconContainer.right
                    verticalCenter: parent.verticalCenter
                }
                Text {
                    id:usbText
                    text: "USB BELLEK" + " " + mountPoint
                    color: textColor
                    font.family:textFont
                    font.bold : true
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideLeft
                    anchors {
                        left: parent.left
                        leftMargin: textAlign
                        right: parent.right
                        rightMargin: textAlign
                        verticalCenter: parent.verticalCenter
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onPressAndHold: { usbText.color= textPressedColor }
                    onPressed: { usbText.color= textPressedColor }
                    onReleased: { usbText.color= textColor }
                    onClicked: { usbIcon.clicked() }
                }
            }

            Item {
                id:usbArrowIconContainer
                height: parent.height
                width:minimumWidth * 13 /100
                anchors {
                    right: parent.right
                    rightMargin: 2
                    verticalCenter: parent.verticalCenter
                }
                PlasmaWidgets.IconWidget {
                    id: usbarrowIcon
                    anchors.fill:parent
                    Component.onCompleted: {
                        setIcon("eta-usb-arrow")
                    }
                    onClicked:{
                        usbIcon.clicked()
                    }
                }

            }

        }

        Rectangle {
            id: libreOfficeContainer
            width: minimumWidth
            height: toolContainerHeight
            color: "transparent"

            Item {
                id:libreOfficeIconContainer
                height: parent.height
                width: toolButtonIconSize
                anchors {
                    left:  parent.left
                    leftMargin: leftRightAlign
                    verticalCenter: parent.verticalCenter
                }
                PlasmaWidgets.IconWidget {
                    id: libreOfficeIcon
                    anchors.fill:parent
                    onClicked: {
                        plasmoid.runCommand("libreoffice")
                    }
                    Component.onCompleted: {
                        setIcon("libreoffice")
                    }
                }
            }

            Item {
                height: libreOfficeContainer.height
                width: libreOfficeContainer.width - height - leftRightAlign
                anchors {
                    left:libreOfficeIconContainer.right
                    verticalCenter: parent.verticalCenter
                }
                Text {
                    id:libreOfficeText
                    text: "LIBRE OFFICE"
                    color: textColor
                    font.family:textFont
                    font.bold : true
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideLeft
                    anchors {
                        left: parent.left
                        leftMargin: textAlign
                        right: parent.right
                        rightMargin: textAlign
                        verticalCenter: parent.verticalCenter
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onPressAndHold: { libreOfficeText.color= textPressedColor }
                    onPressed: { libreOfficeText.color= textPressedColor }
                    onReleased: { libreOfficeText.color= textColor }
                    onClicked: { libreOfficeIcon.clicked() }
                }
            }
        }

        Rectangle {
            id: browserContainer
            width: minimumWidth
            height: toolContainerHeight
            color: "transparent"

            Item {
                id:browserIconContainer
                height: parent.height
                width: toolButtonIconSize
                anchors {
                    left:  parent.left
                    leftMargin: leftRightAlign
                    verticalCenter: parent.verticalCenter
                }
                PlasmaWidgets.IconWidget {
                    id: browserIcon
                    anchors.fill:parent
                    onClicked: {
                        plasmoid.runCommand("xdg-open", ["https://www.google.com.tr"])
                    }
                    Component.onCompleted: {
                        setIcon("eta-browser")
                    }
                }
            }

            Item {
                height: browserContainer.height
                width: browserContainer.width - height - leftRightAlign
                anchors {
                    left:browserIconContainer.right
                    verticalCenter: parent.verticalCenter
                }
                Text {
                    id:browserText
                    text: "İNTERNET TARAYICISI"
                    color: textColor
                    font.family:textFont
                    font.bold : true
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideLeft
                    anchors {
                        left: parent.left
                        leftMargin: textAlign
                        right: parent.right
                        rightMargin: textAlign
                        verticalCenter: parent.verticalCenter
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onPressAndHold: {browserText.color= textPressedColor }
                    onPressed: { browserText.color= textPressedColor }
                    onReleased: { browserText.color= textColor }
                    onClicked: { browserIcon.clicked() }
                }
            }
        }

        Rectangle {
            id: eba
            width: minimumWidth
            height: toolContainerHeight
            color: "transparent"

            Item {
                id:ebaIconContainer
                height: parent.height
                width: toolButtonIconSize
                anchors {
                    left:  parent.left
                    leftMargin: leftRightAlign
                    verticalCenter: parent.verticalCenter
                }
                PlasmaWidgets.IconWidget {
                    id: ebaIcon
                    anchors.fill:parent
                    onClicked: {
                        plasmoid.runCommand("/usr/bin/ebalogin")
                    }
                    Component.onCompleted: {
                        setIcon("eta-eba")
                    }
                }
            }

            Item {
                height: eba.height
                width: eba.width - height - leftRightAlign
                anchors {
                    left:ebaIconContainer.right
                    verticalCenter: parent.verticalCenter
                }
                Text {
                    id:ebaText
                    text: "EBA"
                    color: textColor
                    font.family:textFont
                    font.bold : true
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideLeft
                    anchors {
                        left: parent.left
                        leftMargin: textAlign
                        right: parent.right
                        rightMargin: textAlign
                        verticalCenter: parent.verticalCenter
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onPressAndHold: { ebaText.color= textPressedColor }
                    onPressed: { ebaText.color= textPressedColor }
                    onReleased: { ebaText.color= textColor }
                    onClicked: { ebaIcon.clicked() }
                }
            }
        }
    }

    /**
     * This function determines minimum height of the widget by regarding
     * current user.
     *
     * @param type:string username
     * @return type:int minimumHeight
     */
    function calculateHeight(name) {
        if(name === "ogrenci") {
            usb.visible=false
            passRect.visible = false
            popUpEnabled = false
            return fileManagerContainer.height+libreOfficeContainer.height+browserContainer.height+eba.height
        }
        return fileManagerContainer.height+usb.height+libreOfficeContainer.height+browserContainer.height+eba.height;
    }

//    PasswordInput {
//        id:passRect
//        width: minimumWidth
//        height: eba.height
//        x:widgetrepresenter.x + passRect.width
//        y:eba.y
//        z:-1
//        opacity: 0

//    }

    states: [
        State {
            name: 'visible'
            PropertyChanges { target: passRect; x: widgetrepresenter.x; y: eba.y; z:100; opacity:1; }
        },
        State {
            name: 'invisible'
            PropertyChanges { target: passRect;
                x: widgetrepresenter.x + passRect.width ;
                y: eba.y; z:-1; opacity:0; }
        }
    ]
    transitions: [
        Transition {
            NumberAnimation { properties: "x,y,opacity"; duration: 200 }
        }
    ]

    /**
     * This is the plasma data-engine that provides current user information.
     */
    PlasmaCore.DataSource {
        id: userDataSource
        engine: "userinfo"
        connectedSources: ["Local"]
        interval: 500
    }
}

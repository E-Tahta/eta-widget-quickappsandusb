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

    /**
     * Indicates that the minimum width of the widget regarding the screen
     * resolution.
     */
    property int minimumWidth: screenData.data["Local"]["width"]*14/100;

    /**
     * Indicates that the minimum height of the widget regarding the sub
     * modules that are quick application launchers' rectangles determined
     * by the function checkUser(string user_nickname).
     */
    property int minimumHeight: checkUser(userDataSource.data["Local"]["loginname"])

    /**
     * Indicates that the global veriable for general left & right alignment
     * regarding the screen resolution.
     */
    property int leftrightAlign: minimumWidth*9/100

    /**
     * Indicates that the global veriable for general line alignment
     * regarding the screen resolution.
     */
    property int lineAlign: minimumWidth * 7 / 100

    /**
     * Indicates that the global veriable for general text left & right
     * alignment regarding the screen resolution.
     */
    property int textAlign: minimumWidth *4 / 100

    property string username : userDataSource.data["Local"]["loginname"]

    property int toolButtonIconSize : minimumWidth * 21 / 100

    Column {
        anchors.fill:parent
        Rectangle {
            id:filemanager
            width: minimumWidth
            height: minimumWidth * 22 /100
            color: "transparent"
            Row {
                anchors {
                    fill:parent
                }
                Item {
                    id:toolbuttonfilemanager
                    height: toolButtonIconSize
                    width: height
                    anchors {
                        left:  parent.left
                        leftMargin: leftrightAlign
                        verticalCenter: parent.verticalCenter
                    }
                    PlasmaWidgets.IconWidget {
                        id: dolphinIcon                        
                        anchors.fill:parent

                        Component.onCompleted: {
                            setIcon("eta-file-manager")
                        }
                    }
                }
                Item {
                    anchors {
                        left:toolbuttonfilemanager.right
                        leftMargin :textAlign
                        verticalCenter: parent.verticalCenter
                    } Text {
                        id:dolphintext
                        text: "DOSYALARIM"
                        color: "#969699"
                        font.family:textFont
                        font.bold : true
                        elide: Text.ElideLeft
                        horizontalAlignment: Text.AlignLeft
                        anchors {
                            left: parent.left
                            leftMargin: 0
                            verticalCenter: parent.verticalCenter
                            verticalCenterOffset: 0
                        }
                    }//label
                }//item labelcontainer
            }//Row
            MouseArea {
                anchors.fill: parent
                onPressAndHold: { dolphintext.color= "#FF6C00" }
                onPressed: {dolphintext.color= "#FF6C00" }
                onReleased: {plasmoid.runCommand("dolphin"); dolphintext.color= "#969699";}
            }
        }
        Rectangle {
            id:usb
            width: minimumWidth
            height: minimumWidth * 22 /100
            color: "transparent"
            Row {
                anchors {
                    top:parent.top
                    topMargin:0
                    fill:parent
                }
                Item {
                    id:toolbuttonusbcontainer
                    height: toolButtonIconSize
                    width: height
                    anchors {
                        left:  parent.left
                        leftMargin: leftrightAlign
                        verticalCenter: parent.verticalCenter
                    }
                    PlasmaWidgets.IconWidget {
                        id: usbIcon                        
                        anchors.fill:parent
                        Component.onCompleted: {
                            setIcon("eta-usb")
                        }
                    }
                }//ToolButton
                Item {
                    anchors {
                        left:toolbuttonusbcontainer.right
                        leftMargin :textAlign
                        verticalCenter: parent.verticalCenter
                    } Text {
                        id:usbtext
                        text: "USB BELLEK " + mountPoint
                        color: "#969699"
                        font.family:textFont
                        font.bold : true
                        elide: Text.ElideLeft
                        horizontalAlignment: Text.AlignLeft
                        anchors {
                            left: parent.left
                            leftMargin: 0
                            verticalCenter: parent.verticalCenter
                            verticalCenterOffset: 0
                        }
                    }//label                    
                }//item labelcontainer
                Item {
                    id:usbarrowContainer
                    width:minimumWidth * 13 /100
                    height: minimumWidth * 18 /100
                    anchors {
                        right: parent.right
                        rightMargin: 2
                        verticalCenter: parent.verticalCenter
                    }

                    PlasmaWidgets.IconWidget
                    {
                      id: usbarrowIcon                      
                      anchors.fill:parent
                      Component.onCompleted: {
                          setIcon("eta-usb-arrow")
                      }
                      onClicked:{
                            plasmoid.togglePopup();
                      }
                    }
                    /*
                    Image {
                        id: usbarrowIcon
                        source: "../images/usb_arrow.png"
                        height: 32
                        width: 32
                        anchors {
                            bottom:parent.bottom
                            right: parent.right
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                plasmoid.togglePopup();
                            }
                        }
                    }
                    */
                }
            }//Row
            MouseArea {
                height: minimumWidth * 18 /100
                width: usb.width-usbarrowContainer.width
                anchors {
                    left:parent.left
                    top:parent.top
                    bottom:parent.bottom
                    right: usbarrowContainer.left
                }
                onPressAndHold: { usbtext.color= "#FF6C00"; }
                onPressed: {usbtext.color= "#FF6C00"; }
                onReleased: {
                    usbtext.color= "#969699";
                    plasmoid.togglePopup();
                    //plasmoid.runCommand("dolphin",[mountPoint]);}
                }
            }
        }
        Rectangle {
            id:libre
            width: minimumWidth
            height: minimumWidth * 22 /100
            color: "transparent"
            Row {
                anchors {
                    top:parent.top
                    topMargin:0
                    fill:parent
                }
                Item {
                    id:toolbuttonlibrecontainer
                    height: toolButtonIconSize
                    width: height
                    anchors {
                        left:  parent.left
                        leftMargin: leftrightAlign
                        verticalCenter: parent.verticalCenter
                    }
                    PlasmaWidgets.IconWidget {
                        id: libreIcon                        
                        anchors.fill:parent
                        Component.onCompleted: {
                            setIcon("libreoffice")
                        }
                    }
                }//ToolButton
                Item {
                    anchors {
                        left:toolbuttonlibrecontainer.right
                        leftMargin :textAlign
                        verticalCenter: parent.verticalCenter
                    } Text {
                        id:libretext
                        text: "LIBRE OFFICE"
                        color: "#969699"
                        font.family:textFont
                        font.bold : true
                        elide: Text.ElideLeft
                        horizontalAlignment: Text.AlignLeft
                        anchors {
                            left: parent.left
                            leftMargin: 0
                            verticalCenter: parent.verticalCenter
                            verticalCenterOffset: 0
                        }
                    }//label
                }//item labelcontainer
            }//Row
            MouseArea {
                anchors.fill: parent
                onPressAndHold: { libretext.color= "#FF6C00"; }
                onPressed: {libretext.color= "#FF6C00"; }
                onReleased: {plasmoid.runCommand("libreoffice"); libretext.color= "#969699";}
            }
        }
        Rectangle {
            id:firefox
            width: minimumWidth
            height: minimumWidth * 22 /100
            color: "transparent"
            Row {
                anchors {
                    top:parent.top
                    topMargin:0
                    fill:parent
                }
                Item {
                    id:toolbuttonfirefoxcontainer
                    height: toolButtonIconSize
                    width: height
                    anchors {
                        left:  parent.left
                        leftMargin: leftrightAlign
                        verticalCenter: parent.verticalCenter
                    }
                    PlasmaWidgets.IconWidget {
                        id: firefoxIcon                        
                        anchors.fill:parent
                        Component.onCompleted: {
                            setIcon("eta-browser")
                        }
                    }
                }//ToolButton
                Item {
                    anchors {
                        left:toolbuttonfirefoxcontainer.right
                        leftMargin :textAlign
                        verticalCenter: parent.verticalCenter
                    }
                    Text {
                        id:firefoxtext
                        text: "İNTERNET TARAYICISI"
                        color: "#969699"
                        font.family:textFont
                        font.bold : true
                        elide: Text.ElideLeft
                        horizontalAlignment: Text.AlignLeft
                        anchors {
                            left: parent.left
                            leftMargin: 0
                            verticalCenter: parent.verticalCenter
                            verticalCenterOffset: 0
                        }
                    }//label
                }//item labelcontainer
            }//Row
            MouseArea {
                anchors.fill: parent

                onPressAndHold: { firefoxtext.color= "#FF6C00"; }
                onPressed: {firefoxtext.color= "#FF6C00"; }
                onReleased: {
                    plasmoid.runCommand("firefox");
                    firefoxtext.color= "#969699";
                }
            }
        }
        Rectangle {
            id:eba
            width: minimumWidth
            height: minimumWidth * 22 /100
            color: "transparent"
            Row {
                anchors {
                    top:parent.top
                    topMargin:0
                    fill:parent
                }
                Item {
                    id:toolbuttonebacontainer
                    height: toolButtonIconSize
                    width: height
                    anchors {
                        left:  parent.left
                        leftMargin: leftrightAlign
                        verticalCenter: parent.verticalCenter
                    }
                    PlasmaWidgets.IconWidget {
                        id: ebaIcon                        
                        anchors.fill:parent
                        Component.onCompleted: {
                            setIcon("eta-eba")
                        }
                    }
                }//ToolButton
                Item {
                    anchors {
                        left:toolbuttonebacontainer.right
                        leftMargin :textAlign
                        verticalCenter: parent.verticalCenter
                    }
                    Text {
                        id:ebatext
                        text: "EBA"
                        color: "#969699"
                        font.family:textFont
                        font.bold : true
                        elide: Text.ElideLeft
                        horizontalAlignment: Text.AlignLeft
                        anchors {
                            left: parent.left
                            leftMargin: 0
                            verticalCenter: parent.verticalCenter
                            verticalCenterOffset: 0
                        }
                    }//label
                }//item labelcontainer
            }//Row
            MouseArea {
                anchors.fill: parent

                onPressAndHold: { ebatext.color= "#FF6C00"; }
                onPressed: {ebatext.color= "#FF6C00"; }

                onReleased: {
                    /*
                    if(widgetrepresenter.username != "ogrenci"){
                        if(widgetrepresenter.state == 'visible') {
                            widgetrepresenter.state = 'invisible';
                            plasmoid.runCommand("qdbus",["org.eta.virtualkeyboard",
                                                         "/VirtualKeyboard",
                                                         "org.eta.virtualkeyboard.hidePinInput"]);
                            ebatext.color= "#969699";
                        } else {
                            widgetrepresenter.state = 'visible';
                            if(passRect.isActive){
                                plasmoid.runCommand("qdbus",["org.eta.virtualkeyboard",
                                                             "/VirtualKeyboard",
                                                             "org.eta.virtualkeyboard.showPinInput"]);
                            }
                            ebatext.color= "#FF6C00";
                        }
                    } else {
                        widgetrepresenter.state = 'invisible';
                        ebatext.color= "#969699";
                        plasmoid.runCommand("firefox",["-new-window",
                                                       "http://eba.gov.tr"]);
                    }
                    */
                    widgetrepresenter.state = 'invisible';
                    ebatext.color= "#969699";
                    plasmoid.runCommand("/usr/bin/ebalogin");
                    //plasmoid.runCommand("chromium",["--new-window",
                    //                               "http://eba.gov.tr"]);
                }
            }
        }
    }//main column

    /**
     * This function determines minimum height of the widget by regarding
     * current user.
     *
     * @param type:string username
     * @return type:int minimumHeight
     */
    function checkUser(username) {
        if(username === "ogrenci") {
            usb.visible=false
            passRect.visible = false
            popUpEnabled = false
            return filemanager.height+libre.height+firefox.height+eba.height
        }
        return filemanager.height+usb.height+libre.height+firefox.height+eba.height;
    }    

    PasswordInput {
        id:passRect
        width: minimumWidth
        height: eba.height
        x:widgetrepresenter.x + passRect.width
        y:eba.y
        z:-1
        opacity: 0

    }

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

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

import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras

Rectangle {
    id: devicenotifier
    property int minimumWidth
    property int minimumHeight
    property string textFont
    property string devicesType: "removable"
    property string expandedDevice
    property string mountPoint
    //property string mainUdi : DataEngineSource
    property Component compactRepresentation: WidgetCompactRepresenter {}
    property bool popUpEnabled : true
    color: "#383838"

    PlasmaCore.Theme {
        id: theme
    }
    PlasmaCore.DataSource {
        id: hpSource
        engine: "hotplug"
        connectedSources: sources
        interval: 0
    }
    PlasmaCore.DataSource {
        id: sdSource
        engine: "soliddevice"
        connectedSources: hpSource.sources
        interval: 0
        property string last
        onSourceAdded: {
            last = source;
            processLastDevice(true)
        }
        onSourceRemoved: {
            if (expandedDevice == source) {
                notifierDialog.currentExpanded = -1;
                expandedDevice = "";
            }
        }
        onDataChanged: {
            processLastDevice(true)
        }
        onNewData: {
            last = sourceName;
            processLastDevice(false);
        }
        function processLastDevice(expand) {
            if (last != "") {
                if (devicesType == "all" ||
                        (devicesType == "removable" && data[last] && data[last]["Removable"] == true) ||
                        (devicesType == "nonRemovable" && data[last] && data[last]["Removable"] == false)) {

                    if (expand && hpSource.data[last]["added"]) {
                        expandDevice(last);

                    }
                    last = "";
                }
            }
        }
    }
    function popupEventSlot(popped) {
        if (!popped) {
            // reset the property that lets us remember if an item was clicked
            // (versus only hovered) for autohide purposes
            notifierDialog.itemClicked = true;
            expandedDevice = "";
            notifierDialog.currentExpanded = -1;
            notifierDialog.currentIndex = -1;
        }
    }

    PlasmaCore.DataSource {
        id: statusSource
        engine: "devicenotifications"
        property string last
        onSourceAdded: {
            last = source;
            connectSource(source);
        }
        onDataChanged: {
            if (last != "") {
                popUpContainer.setData(data[last]["error"], data[last]["errorDetails"], data[last]["udi"]);
                plasmoid.status = "NeedsAttentionStatus";
                if (popUpEnabled) {
                    plasmoid.showPopup(2500);
                }
            }
        }
    }

    PlasmaCore.DataSource {
        id: screenData
        engine: "userinfo"
        connectedSources: ["Local"]

    }
    Component.onCompleted: {
        plasmoid.addEventListener ('ConfigChanged', configChanged);
        plasmoid.popupEvent.connect(popupEventSlot);
        plasmoid.aspectRatioMode = IgnoreAspectRatio;

        if (notifierDialog.count == 0) {
            plasmoid.status = "PassiveStatus"
        }
        
        if (screenData.data["Local"]["loginname"] != "ogrenci") {
            devicenotifier.minimumHeight = screenData.data["Local"]["width"] * 39 / 250;
            devicenotifier.minimumWidth = screenData.data["Local"]["width"]*16 / 100;
        } else {
            devicenotifier.minimumHeight = 0
            devicenotifier.minimumWidth = 0
        }


    }

    function configChanged()
    {
        textFont = plasmoid.readConfig( "textFont" )
    }

    function expandDevice(udi)
    {
        if (hpSource.data[udi]["actions"].length > 1) {
            expandedDevice = udi
        }
        notifierDialog.itemClicked = false;
        if (popUpEnabled) {
            plasmoid.showPopup(7500)
        }

    }

    Timer {
        id: passiveTimer
        interval: 2500
        onTriggered: plasmoid.status = "PassiveStatus"
    }

    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        onEntered: notifierDialog.itemHovered()
        onExited: notifierDialog.itemUnhovered()
        PlasmaCore.Svg {
            id: lineSvg
            imagePath: "widgets/line"
        }
        PlasmaExtras.ScrollArea {
            anchors {
                top : parent.top
                topMargin: 0
                bottom: statusBarSeparator.top
                left: parent.left
                right: parent.right
            }
            ListView {
                id: notifierDialog

                model: PlasmaCore.SortFilterModel {
                    id: filterModel
                    sourceModel: PlasmaCore.DataModel {
                        dataSource: sdSource
                    }
                    filterRole: "Removable"
                    filterRegExp: "true"
                    sortRole: "Timestamp"
                    sortOrder: Qt.DescendingOrder
                }
                property int currentExpanded: -1
                property bool itemClicked: true
                delegate: deviceItem
                //this is needed to make SectionScroller actually work
                //acceptable since one doesn't have a billion of devices
                cacheBuffer: 1000
                onCountChanged: {
                    if (count == 0) {
                        passiveTimer.restart()
                    } else {
                        passiveTimer.stop()
                        plasmoid.status = "ActiveStatus"
                    }
                }
                function itemHovered() {
                    // prevent autohide from catching us!
                    plasmoid.showPopup(0);
                }
                function itemUnhovered() {
                    if (!itemClicked) {
                        if (popUpEnabled) {
                            plasmoid.showPopup(1000);
                        }
                    }
                }
                function itemFocused() {
                    if (!itemClicked) {
                        // prevent autohide from catching us!
                        itemClicked = true;
                        if (popUpEnabled) {
                            plasmoid.showPopup(0)
                        }
                    }
                }
                section {
                    property: "Type Description"
                    delegate: Item {
                        height: childrenRect.height
                        width: notifierDialog.width
                        PlasmaCore.SvgItem {
                            visible: parent.y > 0
                            svg: lineSvg
                            elementId: "horizontal-line"
                            anchors {
                                left: parent.left
                                right: parent.right
                            }
                            height: lineSvg.elementSize("horizontal-line").height
                        }
                        PlasmaComponents.Label {
                            x: 8
                            y: 8
                            opacity: 0.6
                            text: section
                            color: "#ffffff"//theme.textColor
                        }
                    }
                }
                Component.onCompleted: currentIndex=-1
            }
        }
        Component {
            id: deviceItem
            DeviceItem {
                id: wrapper
                width: notifierDialog.width
                udi: DataEngineSource
                icon: sdSource.data[udi]["Icon"]
                deviceName: sdSource.data[udi]["Description"]
                emblemIcon: Emblems[0]
                state: model["State"]

                percentUsage: {
                    var freeSpace = new Number(sdSource.data[udi]["Free Space"]);
                    var size = new Number(model["Size"]);
                    var used = size-freeSpace;
                    return used*100/size;
                }
                leftActionIcon: {
                    if (mounted) {
                        return QIcon("media-eject");
                    } else {
                        return QIcon("emblem-mounted");
                    }
                }

                mounted: model["Accessible"]

                onLeftActionTriggered: {
                    operationName = mounted ? "unmount" : "mount";
                    service = sdSource.serviceForSource(udi);
                    operation = service.operationDescription(operationName);
                    service.startOperationCall(operation);
                }

                property bool isLast: (expandedDevice == udi)
                property int operationResult: (model["Operation result"])

                onIsLastChanged: {
                    if (isLast) {
                        notifierDialog.currentExpanded = index
                        makeCurrent();
                    }
                }
                onOperationResultChanged: {
                    if (operationResult == 1) {

                    } else if (operationResult == 2) {

                    }
                }
                Behavior on height { NumberAnimation { duration: 150 } }
            }
        }

        PlasmaCore.SvgItem {
            id: statusBarSeparator
            svg: lineSvg
            elementId: "horizontal-line"
            height: lineSvg.elementSize("horizontal-line").height
            anchors {
                bottom: popUpContainer.top
                bottomMargin: popUpContainer.visible ? 3:0
                left: parent.left
                right: parent.right
            }
            visible: popUpContainer.height>0
        }
        PopUpContainer {
            id: popUpContainer
            anchors {
                left: parent.left
                leftMargin: 5
                right: parent.right
                rightMargin: 5
                bottom: parent.bottom
                bottomMargin: 5
            }
        }
    } // MouseArea

    function isMounted (udi) {
        var types = sdSource.data[udi]["Device Types"];
        if (types.indexOf("Storage Access")>=0) {
            if (sdSource.data[udi]["Accessible"]) {

                return true;
            }
            else {
                return false;
            }
        }
        else if (types.indexOf("Storage Volume")>=0 && types.indexOf("OpticalDisc")>=0) {
            return true;
        }
        else {
            return false;
        }
    }
}

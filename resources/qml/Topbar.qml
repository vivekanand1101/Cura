// Copyright (c) 2017 Ultimaker B.V.
// Cura is released under the terms of the AGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import UM 1.2 as UM
import Cura 1.0 as Cura
import "Menus"

Rectangle
{
    id: base
    anchors.left: parent.left
    anchors.right: parent.right
    height: UM.Theme.getSize("sidebar_header").height
    color: UM.Theme.getColor("topbar_background_color")

    Behavior on color { ColorAnimation { duration: 100; } }

    property bool printerConnected: Cura.MachineManager.printerOutputDevices.length != 0
    property bool printerAcceptsCommands: printerConnected && Cura.MachineManager.printerOutputDevices[0].acceptsCommands
    property bool monitoringPrint: false
    signal startMonitoringPrint()
    signal stopMonitoringPrint()

    UM.I18nCatalog
    {
        id: catalog
        name:"cura"
    }
    Image
    {
        id: logo;
        anchors.left: parent.left;
        anchors.leftMargin: UM.Theme.getSize("default_margin").width;
        anchors.verticalCenter: parent.verticalCenter;
        source: UM.Theme.getImage("logo");
        width: UM.Theme.getSize("logo").width;
        height: UM.Theme.getSize("logo").height;
        sourceSize.width: width;
        sourceSize.height: height;
    }

    Row {
        anchors.horizontalCenter: base.horizontalCenter;
        Button
        {
            id: openFileButton;
            text: catalog.i18nc("@action:button", "Add model");
            Image {
                source: UM.Theme.getImage("load")
                width: infillbutton.width;
                height: infillbutton.height;
            }
            style: UM.Theme.styles.tool_button
            tooltip: 'Add model';
            action: Cura.Actions.open;
        }
        Button
        {
            id: extruderbutton;
            text: catalog.i18nc("@action:button", "Extruder");
            Image {
                source: UM.Theme.getImage("extruder")
                width: infillbutton.width;
                height: infillbutton.height;
            }
            style: UM.Theme.styles.tool_button
            tooltip: 'Extruder';
            action: Cura.Actions.open;
        }
        Button
        {
            id: resolutionbutton;
            text: catalog.i18nc("@action:button", "Resolution");
            Image {
                source: UM.Theme.getImage("resolution")
                width: infillbutton.width;
                height: infillbutton.height;
            }
            style: UM.Theme.styles.tool_button
            tooltip: 'Resolution';
            action: Cura.Actions.open;
        }
        Button
        {
            id: infillbutton;
            text: catalog.i18nc("@action:button", "Infill");
            Image {
                source: UM.Theme.getImage("infill")
                width: infillbutton.width;
                height: infillbutton.height;
            }
            style: UM.Theme.styles.tool_button
            tooltip: 'Infill';
            action: Cura.Actions.open;
        }
        Button
        {
            id: wallsbutton;
            text: catalog.i18nc("@action:button", "Walls");
            Image {
                source: UM.Theme.getImage("walls")
                width: infillbutton.width;
                height: infillbutton.height;
            }
            style: UM.Theme.styles.tool_button
            tooltip: 'Walls';
            action: Cura.Actions.open;
        }
        Button
        {
            id: supportbutton;
            text: catalog.i18nc("@action:button", "Support");
            Image {
                source: UM.Theme.getImage("support")
                width: infillbutton.width;
                height: infillbutton.height;
            }
            style: UM.Theme.styles.tool_button
            tooltip: 'Support';
            action: Cura.Actions.open;
        }
        Button
        {
            id: advancedbutton;
            text: catalog.i18nc("@action:button", "Advanced");
            Image {
                source: UM.Theme.getImage("advanced")
                width: infillbutton.width;
                height: infillbutton.height;
            }
            style: UM.Theme.styles.tool_button
            tooltip: 'Advanced';
            action: Cura.Actions.open;
        }
    }
    Button
    {
        id: slicebutton;
        //text: catalog.i18nc("@action:button","Slice");
        height: base.height/2;
        width: base.width/15;
        Image {
            source: UM.Theme.getImage("slicing")
            width: slicebutton.width;
            height: slicebutton.height;
        }
        tooltip: 'Slice';
        anchors
        {
            verticalCenter: base.verticalCenter;
            rightMargin: 20;
            right: base.right;
        }
        //action: Cura.Actions.open;
    }
}

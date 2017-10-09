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
    //TextArea {
        //width: 50;
        //text: "Prepare"
        //activeFocusOnPress: false
        //canUndo: false

    //}
    Row {
        anchors.horizontalCenter: base.horizontalCenter;
        Button
        {
            id: openFileButton;
            text: catalog.i18nc("@action:button", "Add model");
            iconSource: UM.Theme.getIcon("load")
            style: UM.Theme.styles.tool_button
            tooltip: '';
            action: Cura.Actions.open;
        }
        Button
        {
            id: extruderbutton;
            text: catalog.i18nc("@action:button", "Extruder");
            iconSource: UM.Theme.getIcon("load")
            style: UM.Theme.styles.tool_button
            tooltip: '';
            action: Cura.Actions.open;
        }
        Button
        {
            id: resolutionbutton;
            text: catalog.i18nc("@action:button", "Resolution");
            iconSource: UM.Theme.getIcon("load")
            style: UM.Theme.styles.tool_button
            tooltip: '';
            action: Cura.Actions.open;
        }
        Button
        {
            id: infillbutton;
            text: catalog.i18nc("@action:button", "Infill");
            iconSource: UM.Theme.getIcon("load")
            style: UM.Theme.styles.tool_button
            tooltip: '';
            action: Cura.Actions.open;
        }
        Button
        {
            id: wallsbutton;
            text: catalog.i18nc("@action:button", "Walls");
            iconSource: UM.Theme.getIcon("load")
            style: UM.Theme.styles.tool_button
            tooltip: '';
            action: Cura.Actions.open;
        }
        Button
        {
            id: supportbutton;
            text: catalog.i18nc("@action:button", "Support");
            iconSource: UM.Theme.getIcon("load")
            style: UM.Theme.styles.tool_button
            tooltip: '';
            action: Cura.Actions.open;
        }
        Button
        {
            id: advancedbutton;
            text: catalog.i18nc("@action:button", "Advanced");
            iconSource: UM.Theme.getIcon("load")
            style: UM.Theme.styles.tool_button
            tooltip: '';
            action: Cura.Actions.open;
        }
    }
    Button
    {
        id: slicebutton;
        text: catalog.i18nc("@action:button","Slice");
        iconSource: UM.Theme.getIcon("load")
        style: UM.Theme.styles.tool_button
        tooltip: '';
        anchors
        {
            rightMargin: 20;
            right: base.right;
        }
        //action: Cura.Actions.open;
    }
    Button
    {
        id: cancel_prepare_button;
        text: catalog.i18nc("@action:button", "Cancel");
        iconSource: UM.Theme.getIcon("load")
        style: UM.Theme.styles.tool_button
        tooltip: 'Cancel';
        anchors
        {
            rightMargin: 20;
            right: slicebutton.left;
        }
        //action: Cura.Actions.open;
    }
}

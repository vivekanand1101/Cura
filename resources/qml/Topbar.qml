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
    color: base.monitoringPrint ? UM.Theme.getColor("topbar_background_color_monitoring") : UM.Theme.getColor("topbar_background_color")

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

    Loader
    {
        id: view_panel

        anchors.top: viewModeButton.bottom
        anchors.topMargin: UM.Theme.getSize("default_margin").height
        anchors.right: viewModeButton.right

        property var buttonTarget: Qt.point(viewModeButton.x + viewModeButton.width / 2, viewModeButton.y + viewModeButton.height / 2)

        height: childrenRect.height;

        source: UM.ActiveView.valid ? UM.ActiveView.activeViewPanel : "";
    }

}

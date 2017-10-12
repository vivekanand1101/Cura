// Copyright (c) 2015 Ultimaker B.V.
// Cura is released under the terms of the AGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import UM 1.2 as UM
import Cura 1.0 as Cura

Rectangle
{
    id: base
    anchors.left: parent.left;
    anchors.right: parent.right;
    height: UM.Theme.getSize("sidebar_header").height
    color: UM.Theme.getColor("toolbar_background_color")
    UM.I18nCatalog
    {
        id: catalog
        name:"cura"
    }

    Row {
        anchors.bottom: base.bottom
        anchors.horizontalCenter: base.horizontalCenter

        Button
        {
            id: duplicateButton
            Image {
                source: UM.Theme.getImage("duplicate")
                width: infillbutton.width
                height: infillbutton.height
            }
            style: UM.Theme.styles.tool_button
            tooltip: 'Duplicate model'
            //action: Cura.Actions.open
        }
        Item {
            height: base.height;
            width: base.height/20;
            visible: true;
        }
        Button
        {
            id: mirrorButton
            Image {
                source: UM.Theme.getImage("mirror")
                width: infillbutton.width
                height: infillbutton.height
            }
            style: UM.Theme.styles.tool_button
            tooltip: 'Mirror'
            //action: Cura.Actions.open
        }
        Item {
            height: base.height;
            width: base.height/20;
            visible: true;
        }
        Button {
            id: moveButton
            Image {
                source: UM.Theme.getImage("move")
                width: infillbutton.width
                height: infillbutton.height
            }
            style: UM.Theme.styles.tool_button
            tooltip: 'Move'
            //action: Cura.Actions.open
        }
        Item {
            height: base.height;
            width: base.height/20;
            visible: true;
        }
        Button
        {
            id: rotateButton
            Image {
                source: UM.Theme.getImage("rotate")
                width: infillbutton.width
                height: infillbutton.height
            }
            style: UM.Theme.styles.tool_button
            tooltip: 'Rotate'
            //action: Cura.Actions.open
        }
        Item {
            height: base.height;
            width: base.height/20;
            visible: true;
        }
        Button
        {
            id: scaleButton
            Image {
                source: UM.Theme.getImage("scale")
                width: infillbutton.width
                height: infillbutton.height
            }
            style: UM.Theme.styles.tool_button
            tooltip: 'Scale'
            //action: Cura.Actions.open
        }
        Item {
            height: base.height;
            width: base.height/20;
            visible: true;
        }
    }
}

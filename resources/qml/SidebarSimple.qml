// Copyright (c) 2017 Ultimaker B.V.
// Cura is released under the terms of the AGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import UM 1.2 as UM
import Cura 1.0 as Cura

Item
{
    id: base;

    signal showTooltip(Item item, point location, string text);
    signal hideTooltip();

    property Action configureSettings;
    property variant minimumPrintTime: PrintInformation.minimumPrintTime;
    property variant maximumPrintTime: PrintInformation.maximumPrintTime;
    property bool settingsEnabled: ExtruderManager.activeExtruderStackId || machineExtruderCount.properties.value == 1

    Component.onCompleted: PrintInformation.enabled = true
    Component.onDestruction: PrintInformation.enabled = false
    UM.I18nCatalog { id: catalog; name: "cura" }

    ScrollView
    {
        anchors.fill: parent
        style: UM.Theme.styles.scrollview
        flickableItem.flickableDirection: Flickable.VerticalFlick

        Rectangle
        {
            width: childrenRect.width
            height: childrenRect.height
            color: UM.Theme.getColor("sidebar")

            //
            // Quality profile
            //
            Rectangle
            {

                Timer {
                        id: qualitySliderChangeTimer
                        interval: 50
                        running: false
                        repeat: false
                        onTriggered: Cura.MachineManager.setActiveQuality(Cura.ProfilesModel.getItem(qualityRowSlider.value).id)
                    }

                Component.onCompleted:
                {
                    qualityRow.updateQualitySliderProperties()
                }

                Connections
                {
                    target: Cura.MachineManager
                    onActiveQualityChanged:
                    {
                        qualityRow.updateQualitySliderProperties()
                    }
                }


                id: qualityRow

                property var totalTicks: 0
                property var availableTotalTicks: 0
                property var qualitySliderStep: qualityRow.totalTicks != 0 ? (base.width * 0.55) / (qualityRow.totalTicks) : 0
                property var qualitySliderSelectedValue: 0

                property var sliderAvailableMin : 0
                property var sliderAvailableMax : 0
                property var sliderMarginRight : 0

                function updateQualitySliderProperties()
                {
                    qualityRow.totalTicks = Cura.ProfilesModel.rowCount() - 1 // minus one, because slider starts from 0

                    var availableMin = -1
                    var availableMax = -1

                    for (var i = 0; i <= Cura.ProfilesModel.rowCount(); i++)
                    {
                        //Find slider range, min and max value
                        if (availableMin == -1 && Cura.ProfilesModel.getItem(i).available)
                        {
                            availableMin = i
                            availableMax = i
                        }
                        else if(Cura.ProfilesModel.getItem(i).available)
                        {
                            availableMax = i
                        }

                        //Find selected value
                        if(Cura.MachineManager.activeQualityId == Cura.ProfilesModel.getItem(i).id)
                        {
                            qualitySliderSelectedValue = i
                        }
                    }

                    if(availableMin !=-1)
                    {
                        availableTotalTicks =  availableMax - availableMin
                    }
                    else
                    {
                        availableTotalTicks = -1
                    }

                    qualitySliderStep = qualityRow.totalTicks != 0 ? (base.width * 0.55) / (qualityRow.totalTicks) : 0

                    if(availableMin == -1)
                    {
                        sliderMarginRight = base.width * 0.55
                    }
                    else if (availableMin == 0 && availableMax == 0)
                    {
                        sliderMarginRight = base.width * 0.55
                    }
                    else if(availableMin == availableMax)
                    {
                        sliderMarginRight = (qualityRow.totalTicks - availableMin) * qualitySliderStep
                    }
                    else if(availableMin != availableMax)
                    {
                        sliderMarginRight = (qualityRow.totalTicks - availableMax) * qualitySliderStep
                    }


                    qualityRow.sliderAvailableMin = availableMin
                    qualityRow.sliderAvailableMax = availableMax
                }

                height: UM.Theme.getSize("sidebar_margin").height

                anchors.topMargin: UM.Theme.getSize("sidebar_margin").height
                anchors.left: parent.left
                anchors.leftMargin: UM.Theme.getSize("sidebar_margin").width
                anchors.right: parent.right

                Text
                {
                    id: qualityRowTitle
                    text: catalog.i18nc("@label", "Layer Height")
                    font: UM.Theme.getFont("default")
                    color: UM.Theme.getColor("text")
                }

                //Show titles for the each quality slider ticks
                Item
                {
                    y: -5;
                    anchors.left: speedSlider.left
                    Repeater
                    {
                        model: qualityRow.totalTicks + 1
                        Text
                        {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.top: parent.top
                            anchors.topMargin: UM.Theme.getSize("sidebar_margin").height / 2
                            color: UM.Theme.getColor("text")
                            text: Cura.ProfilesModel.getItem(index).layer_height_without_unit

                            width: 1
                            x:
                            {
                                if(index != qualityRow.totalTicks)
                                    return (base.width * 0.55 / qualityRow.totalTicks) * index;
                                else
                                    return (base.width * 0.55 / qualityRow.totalTicks) * index - 15;
                            }
                        }
                    }
                }

                //Print speed slider
                Item
                {
                    id: speedSlider
                    width: base.width * 0.55
                    height: UM.Theme.getSize("sidebar_margin").height
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: UM.Theme.getSize("sidebar_margin").height

                    // Draw Unavailable line
                    Rectangle
                    {
                        id: groovechildrect
                        width: base.width * 0.55
                        height: 2
                        color: UM.Theme.getColor("quality_slider_unavailable")
                        //radius: parent.radius
                        anchors.verticalCenter: qualityRowSlider.verticalCenter
                        x: 0
                    }

                    // Draw ticks
                    Repeater
                    {
                        id: qualityRepeater
                        model: qualityRow.totalTicks + 1
                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            color: qualityRow.availableTotalTicks != 0 ?  UM.Theme.getColor("quality_slider_available") : UM.Theme.getColor("quality_slider_unavailable")
                            width: 1
                            height: 6
                            y: 0
                            x: qualityRow.qualitySliderStep * index
                        }
                    }


                    Slider
                    {

                        id: qualityRowSlider
                        height: UM.Theme.getSize("sidebar_margin").height
                        anchors.bottom: speedSlider.bottom
                        enabled: qualityRow.availableTotalTicks != 0
                        updateValueWhileDragging : false

                        minimumValue: qualityRow.sliderAvailableMin
                        maximumValue: qualityRow.sliderAvailableMax
                        stepSize: 1

                        value: qualityRow.qualitySliderSelectedValue

                        width: qualityRow.qualitySliderStep * (qualityRow.availableTotalTicks)

                        anchors.right: parent.right
                        anchors.rightMargin:  qualityRow.sliderMarginRight

                        style: SliderStyle
                        {
                            //Draw Available line
                            groove: Rectangle {
                                implicitHeight: 2
                                anchors.verticalCenter: qualityRowSlider.verticalCenter
                                color: UM.Theme.getColor("quality_slider_available")
                                radius: 1
                            }
                            handle: Item {
                                Rectangle {
                                    id: qualityhandleButton
                                    anchors.verticalCenter: qualityRowSlider.verticalCenter
                                    anchors.centerIn: parent
                                    color: control.enabled ? UM.Theme.getColor("quality_slider_available") : UM.Theme.getColor("quality_slider_unavailable")
                                    implicitWidth: 10
                                    implicitHeight: 10
                                    radius: 10
                                }
                            }
                        }

                        onValueChanged: {

                            //Prevent updating during view initializing. Trigger only if the value changed by user
                            if(qualityRowSlider.value != qualityRow.qualitySliderSelectedValue)
                            {
                                //start updating with short delay
                                qualitySliderChangeTimer.start();
                            }
                        }
                    }
                }

                Text
                {
                    id: speedLabel
                    anchors.top: speedSlider.bottom

                    anchors.left: parent.left

                    text: catalog.i18nc("@label", "Print Speed")
                    font: UM.Theme.getFont("default")
                    color: UM.Theme.getColor("text")
                }

                Text
                {
                    anchors.bottom: speedLabel.bottom
                    anchors.left: speedSlider.left

                    text: catalog.i18nc("@label", "Slower")
                    font: UM.Theme.getFont("default")
                    color: UM.Theme.getColor("text")
                    horizontalAlignment: Text.AlignLeft
                }

                Text
                {
                    anchors.bottom: speedLabel.bottom
                    anchors.right: speedSlider.right

                    text: catalog.i18nc("@label", "Faster")
                    font: UM.Theme.getFont("default")
                    color: UM.Theme.getColor("text")
                    horizontalAlignment: Text.AlignRight
                }
            }



            //
            // Infill
            //
            Item
            {
                id: infillCellLeft

                anchors.top: qualityRow.bottom
                anchors.topMargin: UM.Theme.getSize("sidebar_margin").height * 2
                anchors.left: parent.left

                width: UM.Theme.getSize("sidebar").width * .45 - UM.Theme.getSize("sidebar_margin").width

                Text
                {
                    id: infillLabel
                    text: catalog.i18nc("@label", "Infill")
                    font: UM.Theme.getFont("default")
                    color: UM.Theme.getColor("text")

                    anchors.top: parent.top
                    anchors.topMargin: UM.Theme.getSize("sidebar_margin").height * 1.7
                    anchors.left: parent.left
                    anchors.leftMargin: UM.Theme.getSize("sidebar_margin").width
                }
            }



            Item
            {
                id: infillCellRight

                height: infillSlider.height + enableGradualInfillCheckBox.height + (UM.Theme.getSize("sidebar_margin").height * 2)
                width: UM.Theme.getSize("sidebar").width * .55

                anchors.left: infillCellLeft.right
                anchors.top: infillCellLeft.top
                anchors.topMargin: UM.Theme.getSize("sidebar_margin").height

                Text {
                    id: selectedInfillRateText

                    //anchors.top: parent.top
                    anchors.left: infillSlider.left
                    anchors.leftMargin: (infillSlider.value / infillSlider.stepSize) * (infillSlider.width / (infillSlider.maximumValue / infillSlider.stepSize)) - 10
                    anchors.right: parent.right

                    text: infillSlider.value + "%"
                    horizontalAlignment: Text.AlignLeft

                    color: infillSlider.enabled ? UM.Theme.getColor("quality_slider_available") : UM.Theme.getColor("quality_slider_unavailable")
                }

                Slider
                {
                    id: infillSlider

                    anchors.top: selectedInfillRateText.bottom
                    anchors.left: parent.left
                    anchors.right: infillIcon.left
                    anchors.rightMargin: UM.Theme.getSize("sidebar_margin").width

                    height: UM.Theme.getSize("sidebar_margin").height
                    width: infillCellRight.width - UM.Theme.getSize("sidebar_margin").width - style.handleWidth

                    minimumValue: 0
                    maximumValue: 100
                    stepSize: 10
                    tickmarksEnabled: true

                    // disable slider when gradual support is enabled
                    enabled: parseInt(infillSteps.properties.value) == 0

                    // set initial value from stack
                    value: parseInt(infillDensity.properties.value)

                    onValueChanged: {
                        infillDensity.setPropertyValue("value", infillSlider.value)
                    }

                    style: SliderStyle
                    {

                        groove: Rectangle {
                            id: groove
                            implicitWidth: 200
                            implicitHeight: 2
                            color: control.enabled ? UM.Theme.getColor("quality_slider_available") : UM.Theme.getColor("quality_slider_unavailable")
                            radius: 1
                        }

                        handle: Item {
                            Rectangle {
                                id: handleButton
                                anchors.centerIn: parent
                                color: control.enabled ? UM.Theme.getColor("quality_slider_available") : UM.Theme.getColor("quality_slider_unavailable")
                                implicitWidth: 10
                                implicitHeight: 10
                                radius: 10
                            }
                        }

                        tickmarks: Repeater {
                            id: repeater
                            model: control.maximumValue / control.stepSize + 1
                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                color: control.enabled ? UM.Theme.getColor("quality_slider_available") : UM.Theme.getColor("quality_slider_unavailable")
                                width: 1
                                height: 6
                                y: 0
                                x: styleData.handleWidth / 2 + index * ((repeater.width - styleData.handleWidth) / (repeater.count-1))
                            }
                        }
                    }
                }

                Rectangle
                {
                    id: infillIcon

                    width: (parent.width / 5) - (UM.Theme.getSize("sidebar_margin").width)
                    height: width

                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: UM.Theme.getSize("sidebar_margin").height / 2

                    // we loop over all density icons and only show the one that has the current density and steps
                    Repeater
                    {
                        id: infillIconList
                        model: infillModel
                        anchors.fill: parent

                        property int activeIndex: {
                            for (var i = 0; i < infillModel.count; i++) {
                                var density = parseInt(infillDensity.properties.value)
                                var steps = parseInt(infillSteps.properties.value)
                                var infillModelItem = infillModel.get(i)

                                if (density >= infillModelItem.percentageMin
                                    && density <= infillModelItem.percentageMax
                                    && steps >= infillModelItem.stepsMin
                                    && steps <= infillModelItem.stepsMax){
                                        return i
                                    }
                            }
                            return -1
                        }

                        Rectangle
                        {
                            anchors.fill: parent
                            visible: infillIconList.activeIndex == index

                            border.width: UM.Theme.getSize("default_lining").width
                            border.color: UM.Theme.getColor("quality_slider_available")

                            UM.RecolorImage {
                                anchors.fill: parent
                                anchors.margins: 2
                                sourceSize.width: width
                                sourceSize.height: width
                                source: UM.Theme.getIcon(model.icon)
                                color: UM.Theme.getColor("quality_slider_unavailable")
                            }
                        }
                    }
                }

                //  Gradual Support Infill Checkbox
                CheckBox {
                    id: enableGradualInfillCheckBox
                    property alias _hovered: enableGradualInfillMouseArea.containsMouse

                    anchors.top: infillSlider.bottom
                    anchors.topMargin: UM.Theme.getSize("sidebar_margin").height
                    anchors.left: infillCellRight.left

                    style: UM.Theme.styles.checkbox
                    enabled: base.settingsEnabled
                    checked: parseInt(infillSteps.properties.value) > 0

                    MouseArea {
                        id: enableGradualInfillMouseArea

                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: true

                        onClicked: {
                            infillSteps.setPropertyValue("value", (parseInt(infillSteps.properties.value) == 0) ? 5 : 0)
                            infillDensity.setPropertyValue("value", 90)
                        }

                        onEntered: {
                            base.showTooltip(enableGradualInfillCheckBox, Qt.point(-infillCellRight.x, 0),
                                catalog.i18nc("@label", "Gradual infill will gradually increase the amount of infill towards the top."))
                        }

                        onExited: {
                            base.hideTooltip()
                        }
                    }

                    Text {
                        id: gradualInfillLabel
                        anchors.left: enableGradualInfillCheckBox.right
                        anchors.leftMargin: UM.Theme.getSize("sidebar_margin").width / 2 // FIXME better margin value
                        text: catalog.i18nc("@label", "Enable gradual")
                        font: UM.Theme.getFont("default")
                        color: UM.Theme.getColor("text")
                    }
                }

                //  Infill list model for mapping icon
                ListModel
                {
                    id: infillModel
                    Component.onCompleted:
                    {
                        infillModel.append({
                            percentageMin: -1,
                            percentageMax: 0,
                            stepsMin: -1,
                            stepsMax: 0,
                            icon: "hollow"
                        })
                        infillModel.append({
                            percentageMin: 0,
                            percentageMax: 40,
                            stepsMin: -1,
                            stepsMax: 0,
                            icon: "sparse"
                        })
                        infillModel.append({
                            percentageMin: 40,
                            percentageMax: 89,
                            stepsMin: -1,
                            stepsMax: 0,
                            icon: "dense"
                        })
                        infillModel.append({
                            percentageMin: 90,
                            percentageMax: 9999999999,
                            stepsMin: -1,
                            stepsMax: 0,
                            icon: "solid"
                        })
                        infillModel.append({
                            percentageMin: 0,
                            percentageMax: 9999999999,
                            stepsMin: 1,
                            stepsMax: 9999999999,
                            icon: "gradual"
                        })
                    }
                }
            }

            //
            //  Enable support
            //
            Text
            {
                id: enableSupportLabel
                visible: enableSupportCheckBox.visible

                anchors.top: infillCellRight.bottom
                anchors.topMargin: UM.Theme.getSize("sidebar_margin").height
                anchors.left: parent.left
                anchors.leftMargin: UM.Theme.getSize("sidebar_margin").width
                anchors.verticalCenter: enableSupportCheckBox.verticalCenter

                text: catalog.i18nc("@label", "Generate Support");
                font: UM.Theme.getFont("default");
                color: UM.Theme.getColor("text");
            }

            CheckBox
            {
                id: enableSupportCheckBox
                property alias _hovered: enableSupportMouseArea.containsMouse

                anchors.top: infillCellRight.bottom
                anchors.topMargin: UM.Theme.getSize("sidebar_margin").height
                anchors.left: infillCellRight.left

                style: UM.Theme.styles.checkbox;
                enabled: base.settingsEnabled

                visible: supportEnabled.properties.enabled == "True"
                checked: supportEnabled.properties.value == "True";

                MouseArea
                {
                    id: enableSupportMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: true
                    onClicked:
                    {
                        // The value is a string "True" or "False"
                        supportEnabled.setPropertyValue("value", supportEnabled.properties.value != "True");
                    }
                    onEntered:
                    {
                        base.showTooltip(enableSupportCheckBox, Qt.point(-enableSupportCheckBox.x, 0),
                            catalog.i18nc("@label", "Generate structures to support parts of the model which have overhangs. Without these structures, such parts would collapse during printing."));
                    }
                    onExited:
                    {
                        base.hideTooltip();
                    }
                }
            }

            Text
            {
                id: supportExtruderLabel
                visible: supportExtruderCombobox.visible
                anchors.left: parent.left
                anchors.leftMargin: UM.Theme.getSize("sidebar_margin").width
                anchors.verticalCenter: supportExtruderCombobox.verticalCenter
                text: catalog.i18nc("@label", "Support Extruder");
                font: UM.Theme.getFont("default");
                color: UM.Theme.getColor("text");
            }

            ComboBox
            {
                id: supportExtruderCombobox
                visible: enableSupportCheckBox.visible && (supportEnabled.properties.value == "True") && (machineExtruderCount.properties.value > 1)
                model: extruderModel

                property string color_override: ""  // for manually setting values
                property string color:  // is evaluated automatically, but the first time is before extruderModel being filled
                {
                    var current_extruder = extruderModel.get(currentIndex);
                    color_override = "";
                    if (current_extruder === undefined) return ""
                    return (current_extruder.color) ? current_extruder.color : "";
                }

                textRole: "text"  // this solves that the combobox isn't populated in the first time Cura is started

                anchors.top: enableSupportCheckBox.bottom
                anchors.topMargin: ((supportEnabled.properties.value === "True") && (machineExtruderCount.properties.value > 1)) ? UM.Theme.getSize("sidebar_margin").height : 0
                anchors.left: infillCellRight.left

                width: UM.Theme.getSize("sidebar").width * .55
                height: ((supportEnabled.properties.value == "True") && (machineExtruderCount.properties.value > 1)) ? UM.Theme.getSize("setting_control").height : 0

                Behavior on height { NumberAnimation { duration: 100 } }

                style: UM.Theme.styles.combobox_color
                enabled: base.settingsEnabled
                property alias _hovered: supportExtruderMouseArea.containsMouse

                currentIndex: supportExtruderNr.properties !== null ? parseFloat(supportExtruderNr.properties.value) : 0
                onActivated:
                {
                    // Send the extruder nr as a string.
                    supportExtruderNr.setPropertyValue("value", String(index));
                }
                MouseArea
                {
                    id: supportExtruderMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: base.settingsEnabled
                    acceptedButtons: Qt.NoButton
                    onEntered:
                    {
                        base.showTooltip(supportExtruderCombobox, Qt.point(-supportExtruderCombobox.x, 0),
                            catalog.i18nc("@label", "Select which extruder to use for support. This will build up supporting structures below the model to prevent the model from sagging or printing in mid air."));
                    }
                    onExited:
                    {
                        base.hideTooltip();
                    }
                }

                function updateCurrentColor()
                {
                    var current_extruder = extruderModel.get(currentIndex);
                    if (current_extruder !== undefined) {
                        supportExtruderCombobox.color_override = current_extruder.color;
                    }
                }

            }

            Text
            {
                id: adhesionHelperLabel
                visible: adhesionCheckBox.visible
                anchors.left: parent.left
                anchors.leftMargin: UM.Theme.getSize("sidebar_margin").width
                anchors.right: infillCellLeft.right
                anchors.rightMargin: UM.Theme.getSize("sidebar_margin").width
                anchors.verticalCenter: adhesionCheckBox.verticalCenter
                text: catalog.i18nc("@label", "Build Plate Adhesion");
                font: UM.Theme.getFont("default");
                color: UM.Theme.getColor("text");
                elide: Text.ElideRight
            }

            CheckBox
            {
                id: adhesionCheckBox
                property alias _hovered: adhesionMouseArea.containsMouse

                anchors.top: enableSupportCheckBox.visible ? supportExtruderCombobox.bottom : infillCellRight.bottom
                anchors.topMargin: UM.Theme.getSize("sidebar_margin").height
                anchors.left: infillCellRight.left

                //: Setting enable printing build-plate adhesion helper checkbox
                style: UM.Theme.styles.checkbox;
                enabled: base.settingsEnabled

                visible: platformAdhesionType.properties.enabled == "True"
                checked: platformAdhesionType.properties.value != "skirt" && platformAdhesionType.properties.value != "none"

                MouseArea
                {
                    id: adhesionMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: base.settingsEnabled
                    onClicked:
                    {
                        var adhesionType = "skirt";
                        if(!parent.checked)
                        {
                            // Remove the "user" setting to see if the rest of the stack prescribes a brim or a raft
                            platformAdhesionType.removeFromContainer(0);
                            adhesionType = platformAdhesionType.properties.value;
                            if(adhesionType == "skirt" || adhesionType == "none")
                            {
                                // If the rest of the stack doesn't prescribe an adhesion-type, default to a brim
                                adhesionType = "brim";
                            }
                        }
                        platformAdhesionType.setPropertyValue("value", adhesionType);
                    }
                    onEntered:
                    {
                        base.showTooltip(adhesionCheckBox, Qt.point(-adhesionCheckBox.x, 0),
                            catalog.i18nc("@label", "Enable printing a brim or raft. This will add a flat area around or under your object which is easy to cut off afterwards."));
                    }
                    onExited:
                    {
                        base.hideTooltip();
                    }
                }
            }

            ListModel
            {
                id: extruderModel
                Component.onCompleted: populateExtruderModel()
            }

            //: Model used to populate the extrudelModel
            Cura.ExtrudersModel
            {
                id: extruders
                onModelChanged: populateExtruderModel()
            }

            Item
            {
                id: tipsCell
                anchors.top: adhesionCheckBox.visible ? adhesionCheckBox.bottom : (enableSupportCheckBox.visible ? supportExtruderCombobox.bottom : infillCellRight.bottom)
                anchors.topMargin: UM.Theme.getSize("sidebar_margin").height * 2
                anchors.left: parent.left
                width: parent.width
                height: tipsText.contentHeight * tipsText.lineCount

                Text
                {
                    id: tipsText
                    anchors.left: parent.left
                    anchors.leftMargin: UM.Theme.getSize("sidebar_margin").width
                    anchors.right: parent.right
                    anchors.rightMargin: UM.Theme.getSize("sidebar_margin").width
                    anchors.top: parent.top
                    wrapMode: Text.WordWrap
                    text: catalog.i18nc("@label", "Need help improving your prints?<br>Read the <a href='%1'>Ultimaker Troubleshooting Guides</a>").arg("https://ultimaker.com/en/troubleshooting")
                    font: UM.Theme.getFont("default");
                    color: UM.Theme.getColor("text");
                    linkColor: UM.Theme.getColor("text_link")
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }

            UM.SettingPropertyProvider
            {
                id: infillExtruderNumber

                containerStackId: Cura.MachineManager.activeStackId
                key: "infill_extruder_nr"
                watchedProperties: [ "value" ]
                storeIndex: 0
            }

            UM.SettingPropertyProvider
            {
                id: infillDensity
                containerStackId: Cura.MachineManager.activeStackId
                key: "infill_sparse_density"
                watchedProperties: [ "value" ]
                storeIndex: 0
            }

            UM.SettingPropertyProvider
            {
                id: infillSteps
                containerStackId: Cura.MachineManager.activeStackId
                key: "gradual_infill_steps"
                watchedProperties: ["value"]
                storeIndex: 0
            }

            UM.SettingPropertyProvider
            {
                id: platformAdhesionType

                containerStackId: Cura.MachineManager.activeMachineId
                key: "adhesion_type"
                watchedProperties: [ "value", "enabled" ]
                storeIndex: 0
            }

            UM.SettingPropertyProvider
            {
                id: supportEnabled

                containerStackId: Cura.MachineManager.activeMachineId
                key: "support_enable"
                watchedProperties: [ "value", "enabled", "description" ]
                storeIndex: 0
            }

            UM.SettingPropertyProvider
            {
                id: machineExtruderCount

                containerStackId: Cura.MachineManager.activeMachineId
                key: "machine_extruder_count"
                watchedProperties: [ "value" ]
                storeIndex: 0
            }

            UM.SettingPropertyProvider
            {
                id: supportExtruderNr

                containerStackId: Cura.MachineManager.activeMachineId
                key: "support_extruder_nr"
                watchedProperties: [ "value" ]
                storeIndex: 0
            }
        }
    }

    function populateExtruderModel()
    {
        extruderModel.clear();
        for(var extruderNumber = 0; extruderNumber < extruders.rowCount() ; extruderNumber++)
        {
            extruderModel.append({
                text: extruders.getItem(extruderNumber).name,
                color: extruders.getItem(extruderNumber).color
            })
        }
        supportExtruderCombobox.updateCurrentColor();
    }
}

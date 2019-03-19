// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.1 as Cura


//
// This component contains the content for the "What's new in Ultimaker Cura" page of the welcome on-boarding process.
//
Item
{
    UM.I18nCatalog { id: catalog; name: "cura" }

    property var machineActionsModel: CuraApplication.getFirstStartMachineActionsModel()

    property int currentActionIndex: 0
    property var currentActionItem: currentActionIndex >= machineActionsModel.count
                                    ? null : machineActionsModel.getItem(currentActionIndex)
    property bool hasActions: machineActionsModel.count > 0

    // Reset to the first page if the model gets changed.
    Connections
    {
        target: machineActionsModel
        onItemsChanged: currentActionIndex = 0
    }

    onVisibleChanged:
    {
        if (visible)
        {
            currentActionIndex = 0
            if (!hasActions)
            {
                base.showNextPage()
            }
        }
    }

    Label
    {
        id: titleLabel
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        text: currentActionItem.title
        color: UM.Theme.getColor("primary_button")
        font: UM.Theme.getFont("large_bold")
        renderType: Text.NativeRendering
    }

    Item
    {
        anchors.top: titleLabel.bottom
        anchors.bottom: nextButton.top
        anchors.topMargin: UM.Theme.getSize("default_margin").height
        anchors.bottomMargin: UM.Theme.getSize("default_margin").height
        anchors.left: parent.left
        anchors.right: parent.right

        data: currentActionItem == undefined ? null : currentActionItem.content
    }

    Cura.PrimaryButton
    {
        id: nextButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 40
        text: catalog.i18nc("@button", "Next")
        width: 140
        fixedWidthMode: true
        onClicked:
        {
            // If no more first-start actions to show, go to the next page.
            if (currentActionIndex + 1 >= machineActionsModel.count)
            {
                currentActionIndex = 0
                base.showNextPage()
                return
            }

            currentActionIndex++
        }
    }
}

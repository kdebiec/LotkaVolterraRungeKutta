import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtCharts 2.0

import "gridWorld.js" as GridWorld

Rectangle {
    id: mainWindow
    property ListModel worldMap: ListModel {}

    visible: true
    width: 1280
    height: 800

    Material.theme: Material.Dark
    Material.accent: Material.Purple

    Component.onCompleted: {
        GridWorld.reset()
        timer.start()
    }

    Timer {
        id: timer
        interval: 500;
        running: false;
        repeat: true
        onTriggered: {
            GridWorld.nextDay()
            axisX.max = GridWorld.day+1
            lineSeries1.append(GridWorld.day, GridWorld.xpoints[GridWorld.day]);
            lineSeries2.append(GridWorld.day, GridWorld.ypoints[GridWorld.day]);
        }
    }

    Row {
        anchors.centerIn: parent
        spacing: 50

        Column {
            spacing: 10;
            Label {
                text: "Time in [ms]"
            }
            TextField {
                id: timeValue
                placeholderText: qsTr("Enter time")
                validator: IntValidator { bottom:0; top: 2000}
                text: "500"

                onAccepted: {
                    timer.interval = timeValue.text
                }
            }

            Label {
                text: "Initial percentage of predators:"
            }
            TextField {
                id: predatorPercentageValue
                placeholderText: qsTr("Enter probability")
                validator: DoubleValidator { bottom:0; top: 1}
                text: GridWorld.predatorPercentage

                onAccepted: {
                    GridWorld.predatorPercentage =
                            parseFloat(predatorPercentageValue.text.replace(',', '.'))
                }
            }

            Label {
                text: "Death rate of predators due to \nlack of prey:"
            }
            TextField {
                id: deletePredator
                placeholderText: qsTr("Enter rate")
                validator: DoubleValidator { bottom:0; top: 1}
                text: GridWorld.pDeletePredator

                onAccepted: {
                    GridWorld.pDeletePredator =
                            parseFloat(deletePredator.text.replace(',', '.'))
                }
            }

            Label {
                text: "Prey birth rate when \nthere are no predators:"
            }
            TextField {
                id: newPrey
                placeholderText: qsTr("Enter rate")
                validator: DoubleValidator { bottom:0; top: 1}
                text: GridWorld.pNewPrey

                onAccepted: {
                    GridWorld.pNewPrey =
                            parseFloat(newPrey.text.replace(',', '.'))
                }
            }

            Label {
                text: "The efficiency with which \na predator uses the energy \ngained from eating its prey \n(0 < c <= 1):"
            }
            TextField {
                id: predatorEnergyEfficiency
                placeholderText: qsTr("Enter efficiency:")
                validator: DoubleValidator { bottom:0; top: 1}
                text: GridWorld.pPredatorEnergyEfficiency

                onAccepted: {
                    GridWorld.pPredatorEnergyEfficiency =
                            parseFloat(predatorEnergyEfficiency.text.replace(',', '.'))
                }
            }

            Label {
                text: "Effectiveness of killing prey \nby predators (0<d<=1):"
            }
            TextField {
                id: predatorMurderEfficiency
                placeholderText: qsTr("Enter effectiveness:")
                validator: DoubleValidator { bottom:0; top: 1}
                text: GridWorld.pPredatorMurderEfficiency

                onAccepted: {
                    GridWorld.pPredatorMurderEfficiency =
                            parseFloat(predatorMurderEfficiency.text.replace(',', '.'))
                }
            }

            Row {
                spacing: 10

                Button {
                    text: timer.running ? "Stop" : "Start"
                    onClicked: {
                        if(timer.running) {
                            timer.stop()
                        }
                        else {
                            timer.start()
                        }
                    }
                }

                Button {
                    text: "Reset"
                    onClicked: {
                        GridWorld.reset()
                    }
                }
            }
        }

        ChartView {
            id: chartView
            height: 700
            width: 700
            animationOptions: ChartView.SeriesAnimations

            ValueAxis {
                id: axisY
                min: 0
                max: 10
                titleText: "Population"
            }

            ValueAxis {
                id: axisX
                min: 0
                max: 0
                titleText: "Day"
            }
            LineSeries {
                id: lineSeries1
                name: "Predator population"
                axisX: axisX
                axisY: axisY
                color: "red"
            }
            LineSeries {
                id: lineSeries2
                name: "Prey population"
                axisX: axisX
                axisYRight: axisY
                color: "blue"
            }
        }
    }
}

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

ApplicationWindow {
    id: root
    title: qsTr("Desktop Sharing Preferences")
    width: 510
    height: 405
    minimumWidth: width
    maximumWidth: width
    minimumHeight: height
    maximumHeight: height

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.topMargin: 10
        anchors.bottomMargin: 15
        anchors.rightMargin: 20

        GroupBox {
            title: qsTr("Sharing")
            flat: true

            GroupBox {
                title: qsTr("Allow other users to view your desktop")
                flat: true
                checkable: true

                Column {
                    Item { width: 5; height: 5 }

                    CheckBox {
                        id: mainGroup
                        text: qsTr("Allow other users to control your desktop")
                    }
                }
            }
        }

        GroupBox {
            title: qsTr("Security")
            flat: true
            enabled: mainGroup.enabled

            Column {
                spacing: 7

                CheckBox {
                    text: qsTr("You must confirm each access to this machine")
                }

                Row {
                    CheckBox {
                        text: qsTr("Require the user to enter this password:")
                    }
                    TextField {
                        width: 170
                        echoMode: TextInput.Password
                    }
                }

                CheckBox {
                    text: qsTr("Require the user to support encryption")
                    }

                CheckBox {
                    text: qsTr("Automatically configure UPnP router to open and forward ports")
                }
            }
        }

        GroupBox {
            title: qsTr("Show Notification Area Icon..")
            flat: true
            enabled: mainGroup.enabled

            Column {
                spacing: 7

                ExclusiveGroup { id: group }

                RadioButton {
                    text: qsTr("Always")
                    exclusiveGroup: group
                }
                RadioButton{
                    text: qsTr("Only when someone is connected")
                    exclusiveGroup: group
                }

                RadioButton {
                    text: qsTr("Never")
                    exclusiveGroup: group
                }
            }
        }

        RowLayout {
            Button {
                text: qsTr("Help")
                iconSource: "/usr/share/icons/Humanity/actions/48/help-contents.svg"
            }
            Item {
                Layout.fillWidth: true
            }
            Button {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Close")
                iconSource: "/usr/share/icons/Humanity/actions/48/window-close.svg"
                onClicked: root.close()
            }
        }
    }
}

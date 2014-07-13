import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import io.thp.pyotherside 1.2


ApplicationWindow {
    id: root
    title: qsTr("Desktop Sharing Preferences")
    width: 510
    height: 405
    minimumWidth: width
    maximumWidth: width
    minimumHeight: height
    maximumHeight: height

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));
            importModule_sync('vinogset');
            call('vinogset.get_key', ['icon-visibility'], function(result){
                if (result === "never") {vino_icon_visibility_never.checked = true}
                if (result === "client") {vino_icon_visibility_client.checked = true}
                if (result === "always") {vino_icon_visibility_always.checked = true}
            });
            call('vinogset.get_key', ['use-upnp'], function(result){vino_use_upnp.checked = result});
            call('vinogset.get_key', ['require-encryption'], function(result){vino_require_encryption.checked = result});
            call('vinogset.get_key', ['vnc-password'], function(result){vino_vnc_password.text = result});
            call('vinogset.get_key', ['authentication-methods'], function(result){vino_authentication_methods.checked = (result[0] === "vnc") ? true : false});
            call('vinogset.get_key', ['prompt-enabled'], function(result){vino_prompt_enabled.checked = result});
            call('vinogset.get_key', ['view-only'], function(result){vino_view_only.checked = !result});
            call('vinogset.get_key', ['enabled'], function(result){vino_enabled.checked = result});
        }
        onError: console.log('Error: ' + traceback)
    }

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
                id: vino_enabled
                title: qsTr("Allow other users to view your desktop")
                flat: true
                checkable: true

                Column {
                    Item { width: 5; height: 5 }

                    CheckBox {
                        id: vino_view_only
                        text: qsTr("Allow other users to control your desktop")
                    }
                }
            }
        }

        GroupBox {
            title: qsTr("Security")
            flat: true
            enabled: vino_view_only.enabled

            Column {
                spacing: 7

                CheckBox {
                    id: vino_prompt_enabled
                    text: qsTr("You must confirm each access to this machine")
                }

                Row {
                    CheckBox {
                        id: vino_authentication_methods
                        text: qsTr("Require the user to enter this password:")
                    }
                    TextField {
                        id: vino_vnc_password
                        width: 170
                        echoMode: TextInput.Password
                        enabled: vino_authentication_methods.checked
                    }
                }

                CheckBox {
                    id: vino_require_encryption
                    text: qsTr("Require the user to support encryption")
                }

                CheckBox {
                    id: vino_use_upnp
                    text: qsTr("Automatically configure UPnP router to open and forward ports")
                }
            }
        }

        GroupBox {
            title: qsTr("Show Notification Area Icon..")
            flat: true
            enabled: vino_view_only.enabled

            Column {
                spacing: 7

                ExclusiveGroup { id: vino_icon_visibility_group }

                RadioButton {
                    id: vino_icon_visibility_always
                    text: qsTr("Always")
                    exclusiveGroup: vino_icon_visibility_group
                }

                RadioButton{
                    id: vino_icon_visibility_client
                    text: qsTr("Only when someone is connected")
                    exclusiveGroup: vino_icon_visibility_group
                }

                RadioButton {
                    id: vino_icon_visibility_never
                    text: qsTr("Never")
                    exclusiveGroup: vino_icon_visibility_group
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

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import io.thp.pyotherside 1.2


ApplicationWindow {
    id: root

    title: qsTr("Desktop Sharing Preferences")
    width: 510; height: 405
    minimumWidth: width; maximumWidth: width
    minimumHeight: height; maximumHeight: height

    Python {
        id: vino

        property bool enabled: false
        property bool view_only: true
        property bool prompt_enabled: true
        property bool authentication_methods: false
        property string vnc_password: ""
        property bool require_encryption: true
        property bool use_upnp: false
        property bool icon_visibility_never: false
        property bool icon_visibility_client: false
        property bool icon_visibility_always: false

        function init() {
            call('vinogset.get_value', ['icon-visibility'], function(result){
                if (result === "never") {vino.icon_visibility_never = true}
                if (result === "client") {vino.icon_visibility_client= true}
                if (result === "always") {vino.icon_visibility_always = true}
            });
            call('vinogset.get_value', ['use-upnp'], function(result){vino.use_upnp = result});
            call('vinogset.get_value', ['require-encryption'], function(result){vino.require_encryption = result});
            call('vinogset.get_value', ['vnc-password'], function(result){vino.vnc_password = result});
            call('vinogset.get_value', ['authentication-methods'], function(result){vino.authentication_methods = (result[0] === "vnc") ? true : false});
            call('vinogset.get_value', ['prompt-enabled'], function(result){vino.prompt_enabled = result});
            call('vinogset.get_value', ['view-only'], function(result){vino.view_only = !result});
            call('vinogset.get_value', ['enabled'], function(result){vino.enabled = result});
        }

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));
            importModule_sync('vinogset');
            init();
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
                checked: vino.enabled
                onCheckedChanged: {
                    vino.enabled = checked
                    checked = Qt.binding(function(){return vino.enabled})
                }

                Column {
                    Item { width: 5; height: 5 }

                    CheckBox {
                        id: vino_view_only

                        text: qsTr("Allow other users to control your desktop")
                        checked: vino.view_only
                        onCheckedChanged: {
                            vino.view_only = checked
                            checked = Qt.binding(function(){return vino.view_only})
                        }
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
                    checked: vino.prompt_enabled
                    onCheckedChanged: {
                        vino.prompt_enabled = checked
                        checked = Qt.binding(function(){return vino.prompt_enabled})
                    }
                }

                Row {

                    CheckBox {
                        id: vino_authentication_methods

                        text: qsTr("Require the user to enter this password:")
                        checked: vino.authentication_methods
                        onCheckedChanged: {
                            vino.authentication_methods = checked
                            checked = Qt.binding(function(){return vino.authentication_methods})
                        }
                    }

                    TextField {
                        id: vino_vnc_password

                        width: 170
                        echoMode: TextInput.Password
                        enabled: vino_authentication_methods.checked
                        text: vino.vnc_password
                        onEditingFinished: {
                            vino.vnc_password = text
                            text = Qt.binding(function(){return vino.vnc_password})
                        }
                    }
                }

                CheckBox {
                    id: vino_require_encryption

                    text: qsTr("Remote users accessing the desktop are required to support encryption")
                    checked: vino.require_encryption
                    onCheckedChanged: {
                        vino.require_encryption = checked
                        checked = Qt.binding(function(){return vino.require_encryption})
                    }
                }

                CheckBox {
                    id: vino_use_upnp

                    text: qsTr("Automatically configure UPnP router to open and forward ports")
                    checked: vino.use_upnp
                    onCheckedChanged: {
                        vino.use_upnp = checked
                        checked = Qt.binding(function(){return vino.use_upnp})
                    }
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
                    checked: vino.icon_visibility_always
                    onCheckedChanged: {
                        vino.icon_visibility_always = checked
                        checked = Qt.binding(function(){return vino.icon_visibility_always})
                    }
                }

                RadioButton{
                    id: vino_icon_visibility_client

                    text: qsTr("Only when someone is connected")
                    exclusiveGroup: vino_icon_visibility_group
                    checked: vino.icon_visibility_client
                    onCheckedChanged: {
                        vino.icon_visibility_client = checked
                        checked = Qt.binding(function(){return vino.icon_visibility_client})
                    }
                }

                RadioButton {
                    id: vino_icon_visibility_never

                    text: qsTr("Never")
                    exclusiveGroup: vino_icon_visibility_group
                    checked: vino.icon_visibility_never
                    onCheckedChanged: {
                        vino.icon_visibility_never = checked
                        checked = Qt.binding(function(){return vino.icon_visibility_never})
                    }
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

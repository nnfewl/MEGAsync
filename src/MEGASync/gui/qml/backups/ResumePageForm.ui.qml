import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import common 1.0

import components.texts 1.0 as Texts
import components.buttons 1.0
import components.pages 1.0

Item {
    id: root

    property alias footerButtons: footerButtonsItem

    implicitHeight: mainLayout.height + Constants.defaultComponentSpacing

    Column {
        id: mainLayout

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Item {
            height: Constants.defaultComponentSpacing
            width: parent.width
        }

        Image {
            id: image

            source: Images.megaDevices
            sourceSize: Qt.size(120, 120)
        }

        Item {
            height: 40
            width: parent.width
        }

        Texts.Text {
            id: titleItem

            width: parent.width
            text: BackupsStrings.finalStepBackupTitle
            font {
                pixelSize: Texts.Text.Size.LARGE
                weight: Font.Bold
            }
            wrapMode: Text.Wrap
        }

        Item {
            height: 8
            width: parent.width
        }

        Texts.SecondaryText {
            id: descriptionItem

            width: parent.width
            text: BackupsStrings.finalStepBackup
            font.pixelSize: Texts.Text.Size.MEDIUM
            wrapMode: Text.Wrap
            lineHeight: 20
            lineHeightMode: Text.FixedHeight
        }

        Item {
            height: 8
            width: parent.width
        }

        Texts.SecondaryText {
            id: descriptionItem2

            width: parent.width
            text: BackupsStrings.finalStepBackup2
            font.pixelSize: Texts.Text.Size.MEDIUM
            wrapMode: Text.Wrap
            lineHeight: 20
            lineHeightMode: Text.FixedHeight
            visible: backupCandidatesComponentAccess != null ? !backupCandidatesComponentAccess.comesFromSettings : false
        }

        Item {
            height: Constants.defaultComponentSpacing
            width: parent.width
        }

        Item { // trick: wrapper to avoid the anchoring colision (inside the footerbuttons) with the layout manager. that's the only purpose.
            width: parent.width
            height: footerButtonsItem.implicitHeight

            FooterButtons {
                id: footerButtonsItem

                leftPrimary.visible: false
                rightSecondary {
                    text: Strings.viewInSettings
                    visible: backupCandidatesComponentAccess != null ? !backupCandidatesComponentAccess.comesFromSettings : false
                }
                rightPrimary {
                    text: Strings.done
                    icons: Icon {}
                }
            }
        }

        Item {
            height: Constants.defaultComponentSpacing
            width: parent.width
        }
    }
}

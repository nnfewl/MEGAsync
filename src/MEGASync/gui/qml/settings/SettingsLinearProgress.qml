import QtQuick 2.15
import QtQuick.Layouts 1.15

import common 1.0
import components.buttons 1.0 as Buttons
import components.texts 1.0 as Texts
import components.images 1.0
import components.toolTips 1.0

import AccountStateQuickWidget 1.0

Item {
    id: root

    property int progressPercentage: 0
    property int state: AccountStateQuickWidget.OK
    property string centerText: ""
    property string freeText: ""
    property string freeTooltipText: ""
    property var segments: []
    property bool showLegend: true

    property int defaultMargin: 12
    property int tightSpacing: 2
    property int smallSpacing: 4
    property int compactSpacing: 8
    property int defaultIconSize: 16
    property int bannerTextPixelSize: 12
    property int bannerTextLineHeight: 18
    
    signal bannerActionClicked()

    function hasStateBanner() {
        return state === AccountStateQuickWidget.WARNING
               || state === AccountStateQuickWidget.FULL
    }

    function normalStateColorForType(type) {
        switch (type) {
        case AccountStateQuickWidget.CloudDrive:
            return ColorTheme.indicatorGreen
        case AccountStateQuickWidget.Backups:
            return ColorTheme.indicatorIndigo
        case AccountStateQuickWidget.Versions:
            return ColorTheme.supportSuccess
        case AccountStateQuickWidget.RubbishBin:
            return ColorTheme.iconAccent
        case AccountStateQuickWidget.Other:
            return ColorTheme.surface3
        default:
            return ColorTheme.indicatorGreen
        }
    }

    function warningStateColorForType(type) {
        switch (type) {
        case AccountStateQuickWidget.CloudDrive:
            return ColorTheme.indicatorGreen
        case AccountStateQuickWidget.Backups:
            return ColorTheme.indicatorIndigo
        case AccountStateQuickWidget.Versions:
            return ColorTheme.supportSuccess
        case AccountStateQuickWidget.RubbishBin:
            return ColorTheme.iconAccent
        case AccountStateQuickWidget.Other:
            return ColorTheme.surface3
        default:
            return ColorTheme.indicatorGreen
        }
    }

    function fullStateColorForType(type) {
        switch (type) {
        case AccountStateQuickWidget.CloudDrive:
            return ColorTheme.buttonError
        case AccountStateQuickWidget.Backups:
            return ColorTheme.buttonErrorHover
        case AccountStateQuickWidget.Versions:
            return ColorTheme.buttonErrorHover
        case AccountStateQuickWidget.RubbishBin:
            return ColorTheme.buttonErrorPressed
        case AccountStateQuickWidget.Other:
            return ColorTheme.buttonErrorPressed
        default:
            return ColorTheme.buttonError
        }
    }

    function bannerBackgroundColor() {
        return state === AccountStateQuickWidget.FULL
               ? ColorTheme.notificationError
               : ColorTheme.notificationWarning
    }

    function bannerAccentColor() {
        return state === AccountStateQuickWidget.FULL ? ColorTheme.textError
                                                      : ColorTheme.textWarning
    }

    function bannerTitle() {
        return state === AccountStateQuickWidget.FULL
               ? SettingsStrings.yourMegaAccountIsFull
               : SettingsStrings.yourMegaAccountIsNearlyFull
    }

    function bannerDescription() {
        return state === AccountStateQuickWidget.FULL
               ? SettingsStrings.uploadsDisabledDescription
               : SettingsStrings.nearlyFullDescription
    }

    function segmentFillColor(segment) {
        if (!segment) {
            return ColorTheme.indicatorGreen
        }

        const type = Number(segment.type)

        if (state === AccountStateQuickWidget.FULL) {
            return root.fullStateColorForType(type)
        }

        if (state === AccountStateQuickWidget.WARNING) {
            return root.warningStateColorForType(type)
        }

        return root.normalStateColorForType(type)
    }

    function visibleSegments() {
        return (segments || []).filter(function(segment) {
            return segment && Number(segment.value) > 0
        })
    }

    function totalVisibleValue() {
        return visibleSegments().reduce(function(total, segment) {
            return total + Number(segment.value)
        }, 0)
    }

    function tooltipTextForSegment(segment) {
        if (!segment) {
            return ""
        }

        const label = segment.label || ""
        const sizeText = segment.sizeText || ""
        return sizeText.length > 0 ? label + "\n" + sizeText : label
    }

    function tooltipTextForFreeArea() {
        return freeTooltipText.length > 0 ? freeTooltipText : freeText
    }

    function hasFreeArea() {
        return freeArea.width > 0
    }

    clip: true
    implicitHeight: progressColumn.implicitHeight

    ColumnLayout {
        id: progressColumn

        anchors.fill: parent
        spacing: root.defaultMargin

        Item {
            id: progressBarContainer

            Layout.fillWidth: true
            implicitHeight: 24

            Rectangle {
                id: progressTrack

                anchors.fill: parent
                radius: 4
                color: ColorTheme.surface3
            }

            Item {
                id: progressFill

                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                width: Math.max(0,
                                parent.width * Math.max(0, Math.min(100, root.progressPercentage))
                                / 100.0)
                clip: true

                Row {
                    id: progressSegmentsLayout

                    anchors.fill: parent
                    spacing: visibleRepeater.count > 1 ? root.tightSpacing : 0

                    Repeater {
                        id: visibleRepeater
                        model: root.visibleSegments()

                        Rectangle {
                            required property var modelData
                            required property int index

                            readonly property bool isFirstVisible: index === 0
                            readonly property bool isLastVisible: index === visibleRepeater.count - 1
                            readonly property bool shouldRoundRightEdge: isLastVisible
                                                                         && !root.hasFreeArea()
                            readonly property real normalizedWidth: {
                                const total = root.totalVisibleValue()
                                return total > 0 ? Number(modelData.value) / total : 0
                            }

                            width: visibleRepeater.count > 0
                                   ? Math.max(0,
                                              (progressFill.width - parent.spacing * (visibleRepeater.count - 1))
                                              * normalizedWidth)
                                   : 0
                            height: progressFill.height
                            color: root.segmentFillColor(modelData)
                            radius: (isFirstVisible || shouldRoundRightEdge) ? 4 : 0

                            Rectangle {
                                anchors {
                                    top: parent.top
                                    right: parent.right
                                    bottom: parent.bottom
                                }
                                width: parent.isFirstVisible && !parent.shouldRoundRightEdge
                                       ? Math.max(0, parent.width - 4)
                                       : 0
                                visible: parent.isFirstVisible
                                         && !parent.shouldRoundRightEdge
                                         && parent.width > 4
                                color: parent.color
                            }

                            Rectangle {
                                anchors {
                                    left: parent.left
                                    top: parent.top
                                    bottom: parent.bottom
                                }
                                width: parent.shouldRoundRightEdge && !parent.isFirstVisible
                                       ? Math.max(0, parent.width - 4)
                                       : 0
                                visible: parent.shouldRoundRightEdge
                                         && !parent.isFirstVisible
                                         && parent.width > 4
                                color: parent.color
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true

                                ToolTip {
                                    visible: parent.containsMouse
                                    text: root.tooltipTextForSegment(modelData)
                                    delay: 300
                                    timeout: 5000
                                }
                            }
                        }
                    }
                }
            }

            Item {
                id: freeArea

                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                }
                width: Math.max(0, parent.width - progressFill.width)
                clip: true

                Rectangle {
                    anchors.fill: parent
                    radius: 4
                    color: ColorTheme.surface3
                }

                Rectangle {
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                    }
                    width: freeArea.width > 4 ? freeArea.width - 4 : 0
                    visible: freeArea.width > 4
                    color: ColorTheme.surface3
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: root.tooltipTextForFreeArea().length > 0

                    ToolTip {
                        visible: parent.containsMouse && parent.enabled
                        text: root.tooltipTextForFreeArea()
                        delay: 300
                        timeout: 5000
                    }
                }

                Texts.Text {
                    id: freeAreaText

                    anchors.centerIn: parent
                    visible: root.freeText.length > 0
                             && freeArea.width > implicitWidth + 8
                    text: root.freeText
                    color: ColorTheme.textPrimary
                    font.pixelSize: Texts.Text.Size.NORMAL
                    font.weight: Font.DemiBold
                }
            }

            Texts.Text {
                id: centerTextLabel

                anchors.centerIn: parent
                visible: root.freeText.length === 0 && root.centerText.length > 0
                text: root.centerText
                color: ColorTheme.textPrimary
                font.pixelSize: Texts.Text.Size.NORMAL
                font.weight: Font.DemiBold
            }
        }

        RowLayout {
            id: legendLayout

            Layout.fillWidth: true
            visible: root.showLegend
            spacing: 24

            Repeater {
                id: legendRepeater

                model: root.visibleSegments()

                RowLayout {
                    id: legendItemLayout

                    required property var modelData

                    spacing: root.tightSpacing

                    Item {
                        id: legendDotContainer

                        implicitWidth: 16
                        implicitHeight: 16

                        Rectangle {
                            id: legendDot

                            anchors.centerIn: parent
                            width: 7.5
                            height: 7.5
                            radius: width / 2
                            color: root.segmentFillColor(modelData)
                        }
                    }

                    Texts.Text {
                        id: legendText

                        text: modelData.label
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                        lineHeight: 16
                        lineHeightMode: Text.FixedHeight
                        color: ColorTheme.textSecondary
                        renderType: Text.NativeRendering // Avoids the slightly blurred text appearance from default QML rendering in embedded QQuickWidget content.
                    }
                }
            }
        }

        Rectangle {
            id: stateBanner

            Layout.fillWidth: true
            visible: root.hasStateBanner()
            radius: 8
            color: root.bannerBackgroundColor()
            implicitHeight: bannerRow.implicitHeight + 24

            RowLayout {
                id: bannerRow

                anchors {
                    fill: parent
                    leftMargin: root.defaultMargin
                    topMargin: root.defaultMargin
                    rightMargin: 20 - bannerActionButton.sizes.focusBorderWidth
                    bottomMargin: root.defaultMargin
                }
                spacing: root.smallSpacing

                RowLayout {
                    id: bannerContentLayout

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: root.compactSpacing

                    SvgImage {
                        id: bannerIcon

                        Layout.alignment: Qt.AlignTop
                        source: root.state === AccountStateQuickWidget.FULL
                                ? Images.alertCircle
                                : Images.alertTriangle
                        color: root.bannerAccentColor()
                        sourceSize: Qt.size(root.defaultIconSize, root.defaultIconSize)
                    }

                    ColumnLayout {
                        id: bannerTextLayout

                        Layout.fillWidth: true
                        spacing: root.smallSpacing

                        Texts.Text {
                            id: bannerTitleText

                            Layout.fillWidth: true
                            text: root.bannerTitle()
                            color: ColorTheme.textPrimary
                            font.pixelSize: root.bannerTextPixelSize
                            font.weight: Font.DemiBold
                            lineHeight: root.bannerTextLineHeight
                            lineHeightMode: Text.FixedHeight
                            renderType: Text.NativeRendering // Avoids the slightly blurred text appearance from default QML rendering in embedded QQuickWidget content.
                        }

                        Texts.Text {
                            id: bannerDescriptionText

                            Layout.fillWidth: true
                            text: root.bannerDescription()
                            color: ColorTheme.textPrimary
                            wrapMode: Text.WordWrap
                            font.pixelSize: root.bannerTextPixelSize
                            font.weight: Font.Normal
                            lineHeight: root.bannerTextLineHeight
                            lineHeightMode: Text.FixedHeight
                            renderType: Text.NativeRendering // Avoids the slightly blurred text appearance from default QML rendering in embedded QQuickWidget content.
                        }
                    }
                }

                Buttons.PrimaryButton {
                    id: bannerActionButton

                    Layout.alignment: Qt.AlignVCenter
                    text: SettingsStrings.buyMoreStorage
                    onClicked: root.bannerActionClicked()
                }
            }
        }
    }
}

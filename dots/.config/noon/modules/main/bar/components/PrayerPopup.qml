import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

StyledPopup {
    id: root

    ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        width: parent?.width * 0.9 ?? 0
        spacing: 12

        ColumnLayout {
            Layout.leftMargin: Padding.small
            Layout.fillWidth: true
            spacing: 2

            StyledText {
                text: Qt.formatDateTime(DateTimeService.clock.date, "dddd") + " , " + DateTimeService.arabicDayName
                color: Colors.m3.m3onSurface
                font.pixelSize: Fonts.sizes.large
                font.weight: Font.Bold
            }

            StyledText {
                text: `${PrayerService.prayerTimes.date} • ${PrayerService.prayerTimes.hijriDate}`
                color: Colors.m3.m3onSurfaceVariant
                font.pixelSize: Fonts.sizes.small
                opacity: 0.7
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Colors.m3.m3outlineVariant
            opacity: 0.2
            Layout.topMargin: 4
        }

        RowLayout {
            Layout.fillWidth: true
            visible: PrayerService.nextPrayer !== ""

            StyledText {
                text: "NEXT PRAYER"
                color: Colors.m3.m3onSurfaceVariant
                font.pixelSize: Fonts.sizes.small
                font.weight: Font.Black
                font.letterSpacing: 1.1
            }

            StyledText {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                text: `${PrayerService.nextPrayer} in ${PrayerService.timeUntilNext}`
                color: Colors.m3.m3primary
                font.pixelSize: Fonts.sizes.normal
                font.weight: Font.DemiBold
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Repeater {
                model: [
                    {
                        name: "Fajr",
                        time: PrayerService.prayerTimes.fajr
                    },
                    {
                        name: "Sunrise",
                        time: PrayerService.prayerTimes.sunrise
                    },
                    {
                        name: "Dhuhr",
                        time: PrayerService.prayerTimes.dhuhr
                    },
                    {
                        name: "Asr",
                        time: PrayerService.prayerTimes.asr
                    },
                    {
                        name: "Maghrib",
                        time: PrayerService.prayerTimes.maghrib
                    },
                    {
                        name: "Isha",
                        time: PrayerService.prayerTimes.isha
                    }
                ]

                delegate: RowLayout {
                    Layout.fillWidth: true
                    visible: modelData.time !== ""

                    property bool isNext: PrayerService.nextPrayer === modelData.name

                    StyledText {
                        text: modelData.name
                        color: isNext ? Colors.m3.m3primary : Colors.m3.m3onSurfaceVariant
                        font.pixelSize: Fonts.sizes.small
                        font.weight: isNext ? Font.Bold : Font.Medium
                        opacity: isNext ? 1.0 : 0.7
                    }

                    StyledText {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignRight
                        text: modelData.time
                        color: isNext ? Colors.m3.m3primary : Colors.m3.m3onSurface
                        font.pixelSize: Fonts.sizes.small
                        font.weight: isNext ? Font.Bold : Font.Medium
                    }

                    StyledText {
                        text: PrayerService.remainingTimes[modelData.name].formatted
                        color: Colors.m3.m3onSurfaceVariant
                        font.pixelSize: Fonts.sizes.small
                        opacity: 0.5
                        visible: !isNext
                    }
                }
            }
        }
    }
}

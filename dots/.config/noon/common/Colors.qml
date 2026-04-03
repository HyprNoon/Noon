pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.common.functions
import qs.services

Singleton {
    id: root

    readonly property QtObject m3: ColorsService.colors
    readonly property real transparency: Mem.options.appearance.transparency.enabled ? Mem.options.appearance.transparency.scale : 0
    readonly property color colOnBackground: WallpaperService.isBright ? colLayer0 : colOnLayer0
    readonly property color colOnBackgroundSubtext: ColorUtils.colorWithLightness(colOnBackground, 0.25)
    readonly property color colSubtext: m3.m3outline
    readonly property color colLayer0: ColorUtils.transparentize(m3.m3background, transparency)
    readonly property color colOnLayer0: m3.m3onBackground
    readonly property color colLayer0Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer0, colOnLayer0, 0.9), transparency)
    readonly property color colLayer0Active: ColorUtils.transparentize(ColorUtils.mix(colLayer0, colOnLayer0, 0.8), transparency)
    readonly property color colLayer0Border: ColorUtils.mix(m3.m3outlineVariant, colLayer0, 0.4)
    readonly property color colLayer1: ColorUtils.transparentize(ColorUtils.mix(m3.m3surfaceContainerLow, m3.m3background, 0.8), transparency)
    readonly property color colOnLayer1: m3.m3onSurfaceVariant
    readonly property color colOnLayer1Inactive: ColorUtils.mix(colOnLayer1, colLayer1, 0.45)
    readonly property color colLayer1Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer1, colOnLayer1, 0.92), transparency)
    readonly property color colLayer1Active: ColorUtils.transparentize(ColorUtils.mix(colLayer1, colOnLayer1, 0.85), transparency)
    readonly property color colLayer2: ColorUtils.transparentize(ColorUtils.mix(m3.m3surfaceContainer, m3.m3surfaceContainerHigh, 0.7), transparency)
    readonly property color colOnLayer2: m3.m3onSurface
    readonly property color colOnLayer2Disabled: ColorUtils.mix(colOnLayer2, m3.m3background, 0.4)
    readonly property color colLayer2Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer2, colOnLayer2, 0.9), transparency)
    readonly property color colLayer2Active: ColorUtils.transparentize(ColorUtils.mix(colLayer2, colOnLayer2, 0.8), transparency)
    readonly property color colLayer2Disabled: ColorUtils.transparentize(ColorUtils.mix(colLayer2, m3.m3background, 0.8), transparency)
    readonly property color colLayer3: ColorUtils.transparentize(ColorUtils.mix(m3.m3surfaceContainerHigh, m3.m3onSurface, 0.96), transparency)
    readonly property color colOnLayer3: m3.m3onSurface
    readonly property color colLayer3Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer3, colOnLayer3, 0.9), transparency)
    readonly property color colLayer3Active: ColorUtils.transparentize(ColorUtils.mix(colLayer3, colOnLayer3, 0.8), transparency)
    readonly property color colLayer4: ColorUtils.transparentize(m3.m3surfaceContainerHighest, transparency)
    readonly property color colOnLayer4: m3.m3onSurface
    readonly property color colLayer4Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer4, colOnLayer4, 0.9), transparency)
    readonly property color colLayer4Active: ColorUtils.transparentize(ColorUtils.mix(colLayer4, colOnLayer4, 0.8), transparency)
    readonly property color colPrimary: m3.m3primary
    readonly property color colOnPrimary: m3.m3onPrimary
    readonly property color colPrimaryHover: ColorUtils.mix(colPrimary, colLayer1Hover, 0.87)
    readonly property color colPrimaryActive: ColorUtils.mix(colPrimary, colLayer1Active, 0.7)
    readonly property color colPrimaryContainer: m3.m3primaryContainer
    readonly property color colPrimaryContainerHover: ColorUtils.mix(colPrimaryContainer, colLayer1Hover, 0.7)
    readonly property color colPrimaryContainerActive: ColorUtils.mix(colPrimaryContainer, colLayer1Active, 0.6)
    readonly property color colOnPrimaryContainer: m3.m3onPrimaryContainer
    readonly property color colSecondary: m3.m3secondary
    readonly property color colOnSecondary: m3.m3onSecondary
    readonly property color colSecondaryHover: ColorUtils.mix(colSecondary, colLayer1Hover, 0.85)
    readonly property color colSecondaryActive: ColorUtils.mix(colSecondary, colLayer1Active, 0.4)
    readonly property color colSecondaryContainer: ColorUtils.transparentize(m3.m3secondaryContainer, transparency)
    readonly property color colSecondaryContainerHover: ColorUtils.mix(colSecondaryContainer, colLayer1Hover, 0.6)
    readonly property color colSecondaryContainerActive: ColorUtils.mix(colSecondaryContainer, colLayer1Active, 0.54)
    readonly property color colOnSecondaryContainer: m3.m3onSecondaryContainer
    readonly property color colOnSurface: m3.m3onSurface
    readonly property color colOnSurfaceVariant: m3.m3onSurfaceVariant
    readonly property color colOnSurfaceDisabled: ColorUtils.mix(colOnSurface, m3.m3background, 0.4)
    readonly property color colOnSurfaceLowEmphasis: ColorUtils.mix(colOnSurface, colOnSurfaceVariant, 0.6)
    readonly property color colInverseSurface: m3.m3inverseSurface
    readonly property color colInverseOnSurface: m3.m3inverseOnSurface
    readonly property color colTertiary: m3.m3tertiary
    readonly property color colOnTertiary: m3.m3onTertiary
    readonly property color colTertiaryContainer: ColorUtils.transparentize(m3.m3tertiaryContainer, transparency)
    readonly property color colTertiaryHover: ColorUtils.mix(colTertiary, colLayer1Hover, 0.85)
    readonly property color colTertiaryActive: ColorUtils.mix(colTertiary, colLayer1Active, 0.4)
    readonly property color colTertiaryContainerHover: ColorUtils.mix(colTertiaryContainer, colLayer1Hover, 0.7)
    readonly property color colTertiaryContainerActive: ColorUtils.mix(colTertiaryContainer, colLayer1Active, 0.6)
    readonly property color colSurfaceContainerLow: ColorUtils.transparentize(m3.m3surfaceContainerLow, transparency)
    readonly property color colSurfaceContainer: ColorUtils.transparentize(m3.m3surfaceContainer, transparency)
    readonly property color colSurfaceContainerHigh: ColorUtils.transparentize(m3.m3surfaceContainerHigh, transparency)
    readonly property color colSurfaceContainerHighest: ColorUtils.transparentize(m3.m3surfaceContainerHighest, transparency)
    readonly property color colSurfaceContainerHighestHover: ColorUtils.mix(m3.m3surfaceContainerHighest, m3.m3onSurface, 0.95)
    readonly property color colSurfaceContainerHighestActive: ColorUtils.mix(m3.m3surfaceContainerHighest, m3.m3onSurface, 0.85)
    readonly property color colSuccess: m3.m3success
    readonly property color colOnSuccess: m3.m3onSuccess
    readonly property color colSuccessContainer: m3.m3successContainer
    readonly property color colOnSuccessContainer: m3.m3onSuccessContainer
    readonly property color colError: m3.m3error
    readonly property color colOnError: m3.m3onError
    readonly property color colErrorHover: ColorUtils.mix(colError, colLayer1Hover, 0.85)
    readonly property color colErrorActive: ColorUtils.mix(colError, colLayer1Active, 0.7)
    readonly property color colErrorContainer: m3.m3errorContainer
    readonly property color colErrorContainerHover: ColorUtils.mix(colErrorContainer, m3.m3onErrorContainer, 0.9)
    readonly property color colErrorContainerActive: ColorUtils.mix(colErrorContainer, m3.m3onErrorContainer, 0.7)
    readonly property color colOnErrorContainer: m3.m3onErrorContainer
    readonly property color colOutline: ColorUtils.transparentize(m3.m3outline, 0.85)
    readonly property color colOutlineVariant: m3.m3outlineVariant
    readonly property color colTooltip: m3.darkmode ? ColorUtils.mix(m3.m3background, "#3C4043", 0.5) : "#3C4043"
    readonly property color colOnTooltip: m3.m3onBackground
    readonly property color colScrim: ColorUtils.transparentize(m3.m3scrim, 0.45)
    readonly property color colShadow: ColorUtils.transparentize(m3.m3shadow, 0.45)
}

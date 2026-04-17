pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.common.functions
import qs.services

Singleton {
    id: root
    function t(c, t = transparency) {
        return ColorUtils.transparentize(c, t);
    }
    function m(c1, c2, p) {
        return ColorUtils.mix(c1, c2, p);
    }
    function tm(c1, c2, p) {
        return t(m(c1, c2, p));
    }

    readonly property QtObject m3: ColorsService.colors
    readonly property real transparency: Mem.options.appearance.transparency.enabled ? Mem.options.appearance.transparency.scale : 0

    readonly property color colOnBackground: WallpaperService.isBright ? colLayer0 : colOnLayer0
    readonly property color colSubtext: m3.m3outline

    readonly property color colLayer0: t(m3.m3background)
    readonly property color colOnLayer0: m3.m3onBackground
    readonly property color colLayer0Hover: tm(colLayer0, colOnLayer0, 0.92)
    readonly property color colLayer0Active: tm(colLayer0, colOnLayer0, 0.88)
    readonly property color colLayer0Border: m(m3.m3outlineVariant, colLayer0, 0.4)

    readonly property color colLayer1: tm(m3.m3surfaceContainerLow, m3.m3background, 0.8)
    readonly property color colOnLayer1: m3.m3onSurfaceVariant
    readonly property color colOnLayer1Inactive: m(colOnLayer1, colLayer1, 0.45)
    readonly property color colLayer1Hover: tm(colLayer1, colOnLayer1, 0.92)
    readonly property color colLayer1Active: tm(colLayer1, colOnLayer1, 0.88)

    readonly property color colLayer2: tm(m3.m3surfaceContainer, m3.m3surfaceContainerHigh, 0.7)
    readonly property color colOnLayer2: m3.m3onSurface
    readonly property color colOnLayer2Disabled: m(colOnLayer2, m3.m3background, 0.4)
    readonly property color colLayer2Hover: tm(colLayer2, colOnLayer2, 0.92)
    readonly property color colLayer2Active: tm(colLayer2, colOnLayer2, 0.88)
    readonly property color colLayer2Disabled: tm(colLayer2, m3.m3background, 0.8)

    readonly property color colLayer3: tm(m3.m3surfaceContainerHigh, m3.m3onSurface, 0.96)
    readonly property color colOnLayer3: m3.m3onSurface
    readonly property color colLayer3Hover: tm(colLayer3, colOnLayer3, 0.92)
    readonly property color colLayer3Active: tm(colLayer3, colOnLayer3, 0.88)

    readonly property color colLayer4: t(m3.m3surfaceContainerHighest)
    readonly property color colOnLayer4: m3.m3onSurface
    readonly property color colLayer4Hover: tm(colLayer4, colOnLayer4, 0.92)
    readonly property color colLayer4Active: tm(colLayer4, colOnLayer4, 0.88)

    readonly property color colPrimary: m3.m3primary
    readonly property color colOnPrimary: m3.m3onPrimary
    readonly property color colPrimaryHover: m(colPrimary, colOnPrimary, 0.92)
    readonly property color colPrimaryActive: m(colPrimary, colOnPrimary, 0.88)

    readonly property color colPrimaryContainer: m3.m3primaryContainer
    readonly property color colOnPrimaryContainer: m3.m3onPrimaryContainer
    readonly property color colPrimaryContainerHover: m(colPrimaryContainer, colOnPrimaryContainer, 0.92)
    readonly property color colPrimaryContainerActive: m(colPrimaryContainer, colOnPrimaryContainer, 0.88)

    readonly property color colSecondary: m3.m3secondary
    readonly property color colOnSecondary: m3.m3onSecondary
    readonly property color colSecondaryHover: m(colSecondary, colOnSecondary, 0.92)
    readonly property color colSecondaryActive: m(colSecondary, colOnSecondary, 0.88)

    readonly property color colSecondaryContainer: t(m3.m3secondaryContainer)
    readonly property color colOnSecondaryContainer: m3.m3onSecondaryContainer
    readonly property color colSecondaryContainerHover: m(colSecondaryContainer, colOnSecondaryContainer, 0.92)
    readonly property color colSecondaryContainerActive: m(colSecondaryContainer, colOnSecondaryContainer, 0.88)

    readonly property color colTertiary: m3.m3tertiary
    readonly property color colOnTertiary: m3.m3onTertiary
    readonly property color colTertiaryHover: m(colTertiary, colOnTertiary, 0.92)
    readonly property color colTertiaryActive: m(colTertiary, colOnTertiary, 0.88)

    readonly property color colTertiaryContainer: t(m3.m3tertiaryContainer)
    readonly property color colOnTertiaryContainer: m3.m3onTertiaryContainer
    readonly property color colTertiaryContainerHover: m(colTertiaryContainer, colOnTertiaryContainer, 0.92)
    readonly property color colTertiaryContainerActive: m(colTertiaryContainer, colOnTertiaryContainer, 0.88)

    readonly property color colOnSurface: m3.m3onSurface
    readonly property color colOnSurfaceVariant: m3.m3onSurfaceVariant
    readonly property color colOnSurfaceDisabled: m(colOnSurface, m3.m3background, 0.4)
    readonly property color colOnSurfaceLowEmphasis: m(colOnSurface, colOnSurfaceVariant, 0.6)
    readonly property color colInverseSurface: m3.m3inverseSurface
    readonly property color colInverseOnSurface: m3.m3inverseOnSurface

    readonly property color colSurfaceContainerLow: t(m3.m3surfaceContainerLow)
    readonly property color colSurfaceContainer: t(m3.m3surfaceContainer)
    readonly property color colSurfaceContainerHigh: t(m3.m3surfaceContainerHigh)
    readonly property color colSurfaceContainerHighest: t(m3.m3surfaceContainerHighest)
    readonly property color colSurfaceContainerHighestHover: m(m3.m3surfaceContainerHighest, m3.m3onSurface, 0.92)
    readonly property color colSurfaceContainerHighestActive: m(m3.m3surfaceContainerHighest, m3.m3onSurface, 0.88)

    readonly property color colSuccess: m3.m3success
    readonly property color colOnSuccess: m3.m3onSuccess
    readonly property color colSuccessContainer: m3.m3successContainer
    readonly property color colOnSuccessContainer: m3.m3onSuccessContainer

    readonly property color colError: m3.m3error
    readonly property color colOnError: m3.m3onError
    readonly property color colErrorHover: m(colError, colOnError, 0.92)
    readonly property color colErrorActive: m(colError, colOnError, 0.88)

    readonly property color colErrorContainer: m3.m3errorContainer
    readonly property color colOnErrorContainer: m3.m3onErrorContainer
    readonly property color colErrorContainerHover: m(colErrorContainer, colOnErrorContainer, 0.92)
    readonly property color colErrorContainerActive: m(colErrorContainer, colOnErrorContainer, 0.88)

    readonly property color colOutline: t(m3.m3outline, 0.8)
    readonly property color colOutlineVariant: m3.m3outlineVariant
    readonly property color colTooltip: m3.darkmode ? m(m3.m3background, "#3C4043", 0.5) : "#3C4043"
    readonly property color colOnTooltip: m3.m3onBackground
    readonly property color colScrim: t(m3.m3scrim, 0.4)
    readonly property color colShadow: t(m3.m3shadow, 0.4)
}

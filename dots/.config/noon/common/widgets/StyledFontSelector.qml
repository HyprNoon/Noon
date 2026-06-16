import Noon.Utils.Dialogs
import qs.common

RippleButtonWithIcon {
    id: root
    implicitSize: 45
    colBackground: root.colors.colLayer3
    materialIcon: "match_case"
    materialIconFill: true
    releaseAction: () => {
        NoonUtils.callIpc("sidebar hide");
        NoonUtils.pickGlobalFont();
    }
}

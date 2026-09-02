//@ pragma Env QS_CRASHREPORT_URL=https://github.com/caelestia-dots/shell/issues/new?template=crash.yml
//@ pragma DefaultEnv QS_NO_RELOAD_POPUP=1
//@ pragma DefaultEnv QS_DROP_EXPENSIVE_FONTS=1
//@ pragma DefaultEnv QSG_RENDER_LOOP=threaded
//@ pragma DefaultEnv QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import "modules"
import "modules/drawers"
import "modules/background"
import "modules/areapicker"
import "modules/lock"
import QtQuick
import Quickshell
import qs.services

ShellRoot {
    id: root

    settings.watchFiles: true
    readonly property bool toolingMode: Quickshell.env("CAELESTIA_QML_TOOLING") === "1"

    // ShellState.shellRoot is read by services during construction, so this
    // binding stays outside the tooling Loader -- it instantiates nothing.
    Binding {
        target: ShellState
        property: "shellRoot"
        value: root
    }

    // The fork wraps the shell in a Loader so `CAELESTIA_QML_TOOLING=1` can
    // load this file for qmlls without bringing up a real shell. Upstream's
    // GSFLoader/ServiceLoader go inside it for the same reason.
    Loader {
        active: !root.toolingMode
        sourceComponent: Item {
            GSFLoader {}
            ServiceLoader {}

            Background {}
            Drawers {}
            AreaPicker {}
            Lock {
                id: lock
            }

            Shortcuts {}
            BatteryMonitor {}
            IdleMonitors {
                lock: lock
            }
        }
    }
}

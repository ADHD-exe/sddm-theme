import QtQuick
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import SddmComponents 2.0

Rectangle {
    readonly property real s: Screen.height / 768
    id: root
    width: Screen.width
    height: Screen.height
    color: "#050203"

    // ── Properties ────────────────────────────────────────────────────
    property int sessionIndex: (sessionModel && sessionModel.lastIndex >= 0)
                               ? sessionModel.lastIndex : 0
    property real ui: 0
    property real typingGlow: 0

    // Palette
    readonly property color red1:  "#7a2cff"
    readonly property color red2:  "#4b148f"
    readonly property color red3:  "#241042"
    readonly property color pink1: "#ff8dfd"
    readonly property color pink2: "#f14fff"
    readonly property color pink3: "#ffb6ff"
    readonly property color chalk: "#f2ede8"
    readonly property color smoke: "#7a7068"
    readonly property color smokeBright: "#b6a6c5"

    TextConstants { id: textConstants }

    // ── Font ─────────────────────────────────────────────────────────
    FontLoader { id: tektur; source: "Tektur-VariableFont_wdth,wght.ttf" }

    // ── Helpers ───────────────────────────────────────────────────────
    ListView {
        id: sessionHelper; model: sessionModel; currentIndex: root.sessionIndex
        visible: false; width: 0; height: 0
        delegate: Item { property string sName: model.name || "" }
    }
    ListView {
        id: userHelper; model: userModel
        currentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0
        visible: false; width: 0; height: 0
        delegate: Item {
            property string displayName: model.realName || model.name || ""
            property string loginName: model.name || ""
        }
    }

    // ── Boot Fade-in ──────────────────────────────────────────────────
    Component.onCompleted: fadeAnim.start()
    NumberAnimation {
        id: fadeAnim; target: root; property: "ui"
        from: 0; to: 1; duration: 2000; easing.type: Easing.OutCubic
    }

    // ══════════════════════════════════════════════════════════════════
    //  BACKGROUND
    // ══════════════════════════════════════════════════════════════════
    Rectangle { anchors.fill: parent; color: "#050203" }
    Loader { anchors.fill: parent; source: "BackgroundVideo.qml" }


    // Bottom blackout
    Rectangle {
        anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
        height: 150 * s
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: "#f8050203" }
        }
    }

    // Top blackout
    Rectangle {
        anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
        height: 150 * s
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#e8050203" }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }


    // ══════════════════════════════════════════════════════════════════
    //  VERTICAL STRIPES — livery accents
    // ══════════════════════════════════════════════════════════════════
    Item {
        id: leftStripe
        x: 0; y: 0
        width: 3 * s; height: root.height
        opacity: root.ui * 0.7

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.3; color: root.pink2 }
                GradientStop { position: 0.7; color: root.pink2 }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
    }

    Item {
        id: rightStripe
        x: root.width - 3 * s; y: 0
        width: 3 * s; height: root.height
        opacity: root.ui * 0.7

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.3; color: root.pink2 }
                GradientStop { position: 0.7; color: root.pink2 }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
    }

    // ══════════════════════════════════════════════════════════════════
    //  TOP — Driver ID (top-left) & Clock (top-right)
    // ══════════════════════════════════════════════════════════════════

    // ANIMATION 3: Driver display slides UP from below on boot
    Item {
        id: driverDisplay
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 38 * s
        anchors.leftMargin: 28 * s
        width: root.width * 0.5
        opacity: root.ui

        // Slide-up entrance tied to the ui fade
        transform: Translate {
            y: (1.0 - root.ui) * 22 * s
        }

        // Tiny status row
        Row {
            id: statusRow
            spacing: 7 * s

            Rectangle {
                width: 5 * s; height: 5 * s; radius: 2.5 * s
                color: root.pink2
                anchors.verticalCenter: parent.verticalCenter
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.15; duration: 900; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 1.0;  duration: 900; easing.type: Easing.InOutSine }
                }
            }
            Text {
                text: "USER ID"
                color: root.pink2; font.family: tektur.name
                font.pixelSize: 9 * s; font.letterSpacing: 4 * s; font.weight: Font.Medium
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Text {
            id: userText
            anchors.top: statusRow.bottom
            anchors.topMargin: 6 * s
            text: (userHelper.currentItem && userHelper.currentItem.displayName)
                  ? userHelper.currentItem.displayName.toUpperCase()
                  : (userModel.lastUser || "DRIVER").toUpperCase()
            color: root.chalk
            font.family: tektur.name
            font.pixelSize: 52 * s
            font.weight: Font.Black
            font.letterSpacing: -0.5 * s
            style: Text.Outline
            styleColor: "#2a0d3d"
            clip: true
            width: root.width * 0.55
        }
    }

    // Clock — top right
    Item {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 38 * s
        anchors.rightMargin: 36 * s
        opacity: root.ui

        transform: Translate {
            y: (1.0 - root.ui) * -18 * s
            x: (1.0 - root.ui) * 8 * s
        }

        Column {
            anchors.right: parent.right
            spacing: 0

            Text {
                id: clockText
                anchors.right: parent.right
                text: Qt.formatTime(new Date(), "HH:mm")
                color: root.chalk
                font.family: tektur.name
                font.pixelSize: 44 * s
                font.weight: Font.Thin
                font.letterSpacing: 2 * s
                Timer {
                    interval: 1000; running: true; repeat: true
                    onTriggered: clockText.text = Qt.formatTime(new Date(), "HH:mm")
                }
            }

            Text {
                id: dateText
                anchors.right: parent.right
                text: Qt.formatDate(new Date(), "ddd  d MMM").toUpperCase()
                color: root.smokeBright
                font.family: tektur.name
                font.pixelSize: 10 * s
                font.letterSpacing: 3.5 * s
                font.weight: Font.Medium
                Timer {
                    interval: 60000; running: true; repeat: true
                    onTriggered: dateText.text = Qt.formatDate(new Date(), "ddd  d MMM").toUpperCase()
                }
            }
        }
    }

    // ══════════════════════════════════════════════════════════════════
    //  TAILLIGHT BAR
    // ══════════════════════════════════════════════════════════════════
    Item {
        id: taillightBar
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 68 * s
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.width * 0.62
        height: 56 * s
        opacity: root.ui

        // ANIMATION 5: boot slide-up for the bar itself
        transform: Translate {
            y: (1.0 - root.ui) * 16 * s
        }

        // ── Top hairline — LED strip ──────────────────────────────────
        Item {
            id: topLineArea
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 2 * s
            clip: true

            // Static gradient base
            Rectangle {
                id: topLine
                anchors.fill: parent
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0;  color: "transparent" }
                    GradientStop { position: 0.08; color: root.pink1 }
                    GradientStop { position: 0.5;  color: root.pink2 }
                    GradientStop { position: 0.92; color: root.pink1 }
                    GradientStop { position: 1.0;  color: "transparent" }
                }
                layer.enabled: passwordField.activeFocus
                layer.effect: DropShadow {
                    color: root.pink1
                    radius: 24; spread: 0.18; samples: 28
                    verticalOffset: 0
                }
            }
        }

        // ANIMATION 7: TYPING FLASH — topLine flares bright white on each character typed
        Rectangle {
            id: typeFlash
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 2 * s
            color: root.pink3
            opacity: 0
            // Triggered by keystroke via onTextChanged
        }

        // Dark translucent backing
        Rectangle {
            id: barBacking
            anchors.top: topLineArea.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: Qt.rgba(0.02, 0.01, 0.01, 0.78)
            border.width: 1
            border.color: Qt.rgba(1.0, 0.55, 0.99, 0.12 + root.typingGlow * 0.38)
            layer.enabled: true
            layer.effect: DropShadow {
                color: Qt.rgba(1.0, 0.55, 0.99, 0.12 + root.typingGlow * 0.24)
                radius: 18 + root.typingGlow * 10
                spread: 0.08 + root.typingGlow * 0.06
                samples: 28
                verticalOffset: 0
            }
        }

        // ── Content zone ──────────────────────────────────────────────
        Item {
            id: contentZone
            anchors.top: topLineArea.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            // TextInput
            TextInput {
                id: passwordField
                anchors.left: parent.left
                anchors.leftMargin: 48 * s
                anchors.right: engageArea.left
                anchors.rightMargin: 10 * s
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: TextInput.AlignVCenter
                leftPadding: 6 * s
                color: root.chalk
                font.family: tektur.name
                font.pixelSize: 15 * s
                font.letterSpacing: 5 * s
                font.weight: Font.Medium
                echoMode: TextInput.Password
                passwordCharacter: "●"
                focus: true; clip: true
                Keys.onReturnPressed: doLogin()
                Keys.onEnterPressed:  doLogin()

                // ANIMATION 7 trigger: flash topLine on every keystroke
                onTextChanged: {
                    root.typingGlow = text.length > 0 ? 1.0 : 0.0
                    typingGlowFade.stop()
                    if (text.length > 0)
                        typingGlowHold.restart()
                    typeFlash.opacity = 0.55
                    typeFlashAnim.restart()
                }
            }

            // Lock indicator circle
            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 22 * s
                anchors.verticalCenter: parent.verticalCenter
                width: 8 * s; height: 8 * s; radius: 4 * s
                color: "transparent"
                border.color: passwordField.activeFocus ? root.pink2 : root.red3
                border.width: 1.8 * s
                Behavior on border.color { ColorAnimation { duration: 300 } }
            }

            // Placeholder
            Text {
                anchors.left: parent.left
                anchors.leftMargin: 54 * s
                anchors.verticalCenter: parent.verticalCenter
                text: "ENTER ACCESS CODE"
                color: root.smokeBright
                font.family: tektur.name
                font.pixelSize: 13 * s
                font.letterSpacing: 3.5 * s
                font.weight: Font.Medium
                opacity: 0.72
                visible: !passwordField.text && !passwordField.activeFocus
            }

            // ANIMATION 8: GO button that PULSES (scale beat) when text is entered
            Item {
                id: engageArea
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 80 * s

                // Track whether we just went from empty to having text
                property bool hasText: passwordField.text.length > 0
                onHasTextChanged: {
                    if (hasText) goScaleAnim.start()
                }

                // Divider border
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 1 * s
                    color: engageMouse.containsMouse
                           ? Qt.rgba(1.0, 0.55, 0.99, 0.86)
                           : Qt.rgba(0.29, 0.08, 0.44, engageArea.hasText ? 0.68 : 0.18)
                    Behavior on color { ColorAnimation { duration: 300 } }
                }

                // Hover fill
                Rectangle {
                    anchors.fill: parent
                    color: engageMouse.containsMouse
                           ? Qt.rgba(1.0, 0.55, 0.99, 0.48)
                           : Qt.rgba(0.29, 0.08, 0.44, 0.08 + root.typingGlow * 0.10)
                    Behavior on color { ColorAnimation { duration: 180 } }
                }

                Text {
                    anchors.centerIn: parent
                    text: "GO!"
                    color: engageArea.hasText
                           ? (engageMouse.containsMouse ? root.pink3 : root.chalk)
                           : Qt.rgba(0.95, 0.88, 0.96, 0.72)
                    font.family: tektur.name
                    font.pixelSize: 13 * s
                    font.letterSpacing: 4 * s
                    font.weight: Font.Black
                    style: Text.Outline
                    styleColor: engageMouse.containsMouse ? root.pink2 : "#2a0d3d"
                    opacity: engageMouse.containsMouse ? 1.0 : 0.92
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                // Scale beat animation
                SequentialAnimation {
                    id: goScaleAnim
                    NumberAnimation { target: engageArea; property: "scale"; to: 1.12; duration: 120; easing.type: Easing.OutQuad }
                    NumberAnimation { target: engageArea; property: "scale"; to: 0.96; duration: 100; easing.type: Easing.InOutSine }
                    NumberAnimation { target: engageArea; property: "scale"; to: 1.0;  duration: 140; easing.type: Easing.OutBounce }
                }

                MouseArea {
                    id: engageMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: doLogin()
                }
            }
        }
    }

    // ── Typing flash fade-out animation ───────────────────────────────
    NumberAnimation {
        id: typeFlashAnim
        target: typeFlash; property: "opacity"
        to: 0; duration: 350; easing.type: Easing.OutCubic
    }

    Timer {
        id: typingGlowHold
        interval: 180
        repeat: false
        onTriggered: typingGlowFade.restart()
    }

    NumberAnimation {
        id: typingGlowFade
        target: root
        property: "typingGlow"
        to: 0
        duration: 900
        easing.type: Easing.OutCubic
    }

    // ── Error Message ─────────────────────────────────────────────────
    Text {
        id: errorMessage
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: taillightBar.top
        anchors.bottomMargin: 10 * s
        text: ""
        color: root.pink2
        font.family: tektur.name
        font.pixelSize: 9 * s
        font.letterSpacing: 4 * s
        opacity: root.ui
        // ANIMATION: error fades in from below
        transform: Translate { y: errorMessage.text !== "" ? 0 : 6 * s }
        Behavior on transform { }
    }

    // Shake animation
    SequentialAnimation {
        id: shakeAnim
        NumberAnimation { target: taillightBar; property: "x"; to: taillightBar.x + 12; duration: 40 }
        NumberAnimation { target: taillightBar; property: "x"; to: taillightBar.x - 10; duration: 40 }
        NumberAnimation { target: taillightBar; property: "x"; to: taillightBar.x + 7;  duration: 40 }
        NumberAnimation { target: taillightBar; property: "x"; to: taillightBar.x - 4;  duration: 40 }
        NumberAnimation { target: taillightBar; property: "x"; to: taillightBar.x;      duration: 40 }
    }

    // ══════════════════════════════════════════════════════════════════
    //  VERY BOTTOM — Session & Power
    // ══════════════════════════════════════════════════════════════════
    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24 * s
        anchors.left: parent.left
        anchors.leftMargin: 28 * s
        spacing: 6 * s
        opacity: root.ui * 0.5

        Text {
            text: "◂"
            color: root.smokeBright; font.pixelSize: 9 * s
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: (sessionHelper.currentItem && sessionHelper.currentItem.sName)
                  ? sessionHelper.currentItem.sName.toUpperCase() : "SESSION"
            color: root.smokeBright
            font.family: tektur.name; font.pixelSize: 10 * s; font.letterSpacing: 2.5 * s; font.weight: Font.Medium
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                onEntered: parent.color = root.pink1
                onExited: parent.color = root.smokeBright
                onClicked: {
                    if (sessionModel && sessionModel.rowCount() > 0)
                        root.sessionIndex = (root.sessionIndex + 1) % sessionModel.rowCount()
                }
            }
        }
    }

    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24 * s
        anchors.right: parent.right
        anchors.rightMargin: 36 * s
        spacing: 24 * s
        opacity: root.ui * 0.5

        Repeater {
            model: [ { t: "RESTART", a: 0 }, { t: "SHUTDOWN", a: 1 } ]
            delegate: Text {
                property var d: modelData
                text: d.t
                color: root.smokeBright
                font.family: tektur.name; font.pixelSize: 10 * s; font.letterSpacing: 2.5 * s; font.weight: Font.Medium
                Behavior on color { ColorAnimation { duration: 150 } }
                MouseArea {
                    anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onEntered: parent.color = root.pink1
                    onExited:  parent.color = root.smokeBright
                    onClicked: { if (d.a === 0) sddm.reboot(); else sddm.powerOff() }
                }
            }
        }
    }

    // ══════════════════════════════════════════════════════════════════
    //  LOGIC
    // ══════════════════════════════════════════════════════════════════
    Connections {
        target: sddm
        function onLoginFailed() {
            errorMessage.text = "// ACCESS DENIED"
            passwordField.text = ""
            root.typingGlow = 0
            passwordField.focus = true
            shakeAnim.start()
        }
    }

    function doLogin() {
        var uname = (userHelper.currentItem && userHelper.currentItem.loginName)
                    ? userHelper.currentItem.loginName : userModel.lastUser
        sddm.login(uname, passwordField.text, root.sessionIndex)
    }
}

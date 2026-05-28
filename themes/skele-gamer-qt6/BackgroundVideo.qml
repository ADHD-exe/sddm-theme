import QtQuick
import QtQuick.Window
import QtMultimedia

Item {
    readonly property real s: Screen.height / 768
    anchors.fill: parent

    Image {
        id: poster
        anchors.fill: parent
        source: "preview.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }

    MediaPlayer {
        id: player
        audioOutput: AudioOutput { volume: 0.0 }
        autoPlay: true
        loops: MediaPlayer.Infinite
        source: Qt.resolvedUrl("bg.mp4")
        videoOutput: videoOutput
    }

    VideoOutput {
        id: videoOutput
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
    }
}

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Item {
  property var user: userField.text
  property var password: passwordField.text
  property var session: sessionPanel.session
  property var inputHeight: Screen.height * 0.032
  property var inputWidth: Screen.width * 0.16

  Rectangle {
    id: loginBackground
    anchors {
      verticalCenter: parent.verticalCenter
      horizontalCenter: parent.horizontalCenter
    }
    height: inputHeight * 5.3
    width: inputWidth * 1.2
    radius: 24
    visible: config.LoginBackground == "true" ? true : false
    color: config.mantle
  }

  Column {
    spacing: 8
    anchors {
      bottom: parent.bottom
      left: parent.left
    }
    PowerButton {
      id: powerButton
    }
    RebootButton {
      id: rebootButton
    }
    SleepButton {
      id: sleepButton
    }
    z: 5
  }

  Column {
    spacing: 8
    z: 5
    anchors {
      verticalCenter: parent.verticalCenter
      horizontalCenter: parent.horizontalCenter
    }

    UserField {
      id: userField
      height: inputHeight
      width: parent.width
    }

    PasswordField {
      id: passwordField
      height: inputHeight
      width: parent.width
      onAccepted: loginButton.clicked()
    }

    Row {
      spacing: 8
      anchors.horizontalCenter: parent.horizontalCenter

      Button {
        id: loginButton
        height: inputHeight
        width: inputWidth
        enabled: user != "" && password != "" ? true : false
        hoverEnabled: true
        contentItem: Text {
          id: buttonText
          renderType: Text.NativeRendering
          font {
            family: config.Font
            pointSize: config.FontSize
            bold: true
          }
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          color: config.crust
          text: "Login"
        }
        background: Rectangle {
          id: buttonBackground
          color: config.sapphire
          radius: 24
        }
        states: [
          State {
            name: "pressed"
            when: loginButton.down
            PropertyChanges {
              target: buttonBackground
              color: config.teal
            }
          },
          State {
            name: "hovered"
            when: loginButton.hovered
            PropertyChanges {
              target: buttonBackground
              color: config.teal
            }
          },
          State {
            name: "enabled"
            when: loginButton.enabled
            PropertyChanges {
              target: buttonBackground
            }
          }
        ]
        transitions: Transition {
          PropertyAnimation {
            properties: "color"
            duration: 300
          }
        }
        onClicked: {
          sddm.login(user, password, session)
        }
      }

      SessionPanel {
        id: sessionPanel
        height: inputHeight
      }
    }
  }

  Connections {
    target: sddm

    function onLoginFailed() {
      passwordField.text = ""
      passwordField.focus = true
    }
  }
}


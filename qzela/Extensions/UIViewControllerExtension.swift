//
// Created by Edson Rocha on 30/01/22.
//

import UIKit

extension UIViewController {

/// Show alert view
/// - Parameter title: title of alert
/// - Parameter message: message of alert
/// - Parameter actionTitles: List of action button titles(ex : "OK","Cancel" etc)
/// - Parameter style: Style of the buttons
/// - Parameter actions: actions repective to each actionTitles
/// - Parameter preferredActionIndex: Index of the button that needs to be shown in bold. If nil is passed, default button will be cancel.

/**
 Example usage:-
 Just make sure actionTitles and actions array the same count.

 /********** 1. Pass nil if you don't need any action handler closure. **************/
 self.showAlert(title: "Title", message: "message", actionTitles: ["OK"], style: [.deafult], actions: [nil])

 /*********** 2. Alert view with one action **************/

 ///     let okActionHandler: ((UIAlertAction) -> Void) = {(action) in
 //Perform action of Ok here
 }
 self.showAlert(title: "Title", message: "message", actionTitles: ["OK", "CANCEL"], style: [.default, .cancel], actions: [okayActionHandler, nil])

 /********** 3.Alert view with two actions **************/

 let okActionHandler: ((UIAlertAction) -> Void) = {(action) in
 //Perform action of ok here
 }

 let cancelActionHandler: ((UIAlertAction) -> Void) = {(action) in
 //Perform action of cancel here
 }

 self.showAlert(title: "Title", message: "message", actionTitles: ["OK", "CANCEL"], style: [.default, .cancel], actions: [okActionHandler,cancelActionHandler], preferredActionIndex: 1)
 */
    public enum Alert {
        case error
        case message
        case attention
        case info
    }

    public func showAlert(title: String,
                          message: String,
                          type: Alert,
                          actionTitles: [String?],
                          style: [UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)?],
                          preferredActionIndex: Int? = nil) {


        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.view.cornerRadius = 12
        alert.view.layer.borderWidth = 6

        var titleString: NSAttributedString!
        if (type == Alert.message) {
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.colorSuccess]
            titleString = NSAttributedString(string: title, attributes: titleAttributes)
            alert.view.layer.borderColor = UIColor.colorSuccess.cgColor
        } else if (type == Alert.attention) {
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.colorOrange]
            titleString = NSAttributedString(string: title, attributes: titleAttributes)
            alert.view.layer.borderColor = UIColor.colorOrange.cgColor
        } else if (type == Alert.error) {
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.colorError]
            titleString = NSAttributedString(string: title, attributes: titleAttributes)
            alert.view.layer.borderColor = UIColor.colorRed.cgColor
        } else {
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.qzelaLightBlue]
            titleString = NSAttributedString(string: title, attributes: titleAttributes)
            alert.view.layer.borderColor = UIColor.qzelaLightBlue.cgColor
        }
        alert.view.layer.backgroundColor = UIColor.colorWhite.cgColor
        let messageAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let messageString = NSAttributedString(string: message, attributes: messageAttributes)
        alert.setValue(titleString, forKey: "attributedTitle")
        alert.setValue(messageString, forKey: "attributedMessage")

        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: style[index], handler: actions[index])
            alert.addAction(action)
        }
        if let preferredActionIndex = preferredActionIndex { alert.preferredAction = alert.actions[preferredActionIndex] }
        present(alert, animated: true, completion: nil)
    }
}

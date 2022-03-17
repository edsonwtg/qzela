//
// Created by Edson Rocha on 30/01/22.
//

import UIKit

struct ProgressDialog {
    static var alert = UIAlertController()
    static var progressView = UIProgressView()
    static var progressPoint : Float = 0{
        didSet{
            if(progressPoint == 1){
                ProgressDialog.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension UIViewController {

    public enum Alert {
        case error
        case message
        case attention
        case info
        case loading
    }


    func LoadingStart(title: String, message: String, style: UIAlertController.Style, type: Alert){
        ProgressDialog.alert = UIAlertController(title: title, message: message, preferredStyle: style)
        // Accessing alert view backgroundColor :
        // ProgressDialog.alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.qzelaOrange
        if (type == Alert.attention) {
            ProgressDialog.alert.view.layer.borderWidth = 4
            ProgressDialog.alert.view.layer.borderColor = UIColor.colorRed.cgColor
        } else {
            ProgressDialog.alert.view.layer.borderWidth = 4
            ProgressDialog.alert.view.layer.borderColor = UIColor.qzelaDarkBlue.cgColor
        }
        ProgressDialog.alert.view.layer.cornerRadius = 12
        // Accessing alert title color :
        ProgressDialog.alert.setValue(NSAttributedString(string: ProgressDialog.alert.title!,
                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17,weight: UIFont.Weight.medium),
                             NSAttributedString.Key.foregroundColor : UIColor.qzelaOrange]),
                forKey: "attributedTitle")
        // Accessing alert message color :
        ProgressDialog.alert.setValue(NSAttributedString(string: ProgressDialog.alert.message!,
                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium),
                             NSAttributedString.Key.foregroundColor : UIColor.qzelaDarkBlue]),
                forKey: "attributedMessage")
        if (type == Alert.loading) {
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 15, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.color = .qzelaDarkBlue
            loadingIndicator.style = UIActivityIndicatorView.Style.large
            loadingIndicator.startAnimating();
            ProgressDialog.alert.view.addSubview(loadingIndicator)
        }
        present(ProgressDialog.alert, animated: true, completion: nil)
    }

    func LoadingStop(){
        ProgressDialog.alert.dismiss(animated: true, completion: nil)
    }


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
 self.showAlert(title: "Title", message: "message", actionTitles: ["OK", "CANCEL"], style: [.default, .cancel], actions: [okActionHandler, nil])

 /********** 3.Alert view with two actions **************/

 let okActionHandler: ((UIAlertAction) -> Void) = {(action) in
 //Perform action of ok here
 }

 let cancelActionHandler: ((UIAlertAction) -> Void) = {(action) in
 //Perform action of cancel here
 }

 self.showAlert(title: "Title", message: "message", actionTitles: ["OK", "CANCEL"], style: [.default, .cancel], actions: [okActionHandler,cancelActionHandler], preferredActionIndex: 1)
 */

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

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

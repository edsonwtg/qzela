//
//  PreviewViewController.swift
//  qzela
//
//  Created by Edson Rocha on 20/11/21.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBAction func btGotoNotification(_ sender: Any) {

        gotoViewControllerWithBack(viewController: "NotificationViewController")

    }
    @IBAction func btBackTabbar(_ sender: Any) {
        tabBarController?.selectedIndex = 2
        dismiss(animated: true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func gotoViewControllerWithBack(viewController: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: viewController)
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.modalTransitionStyle = .flipHorizontal
        self.present(nextViewController, animated:true)
    }

}

//
//  ProfileTabbarController.swift
//  qzela
//
//  Created by Edson Rocha on 19/11/21.
//

import UIKit

class ProfileTabbarController: UIViewController {

    @IBAction func btGotoNotification(_ sender: Any) {

        gotoViewControllerWithBack(viewController: "PreviewViewController")

    }

    @IBAction func btnGotoDashboard(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func gotoNewRootViewController(viewController: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: viewController)
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }
    func gotoViewControllerWithBack(viewController: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: viewController)
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.modalTransitionStyle = .flipHorizontal
        self.present(nextViewController, animated:true)
    }
}

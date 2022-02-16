//
//  LoginViewController.swift
//  qzela
//
//  Created by Edson Rocha on 20/11/21.
//

import UIKit

class LoginViewController: UIViewController {

    let config = Config()

    @IBAction func btGotoTabbar(_ sender: Any) {
        
        gotoNewRootViewController(viewController: "TabBarController")
     }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("GO TO TabBar *********")
        gotoNewRootViewController(viewController: "TabBarController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Config.qzelaToken = "121436c7d02486ee124049af1e8aa35ff9c003125baa77c9e4e6ce6a6dd6aa51ebd8b26f880a05d279f1c5cac3e6b716970657c48c01d9077ab8c1ce784993b62eec46e9e168e5a6c53abdadb5b44121be25b149538b771d3a5c6d7b55ec2260d2c32ad16598d3495c2ddc211589bd59"
        Config.qzelaUserId = "5d987cacdef23b533dd00a36"

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

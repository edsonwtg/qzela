//
//  LoginViewController.swift
//  qzela
//
//  Created by Edson Rocha on 20/11/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func btGotoTabbar(_ sender: Any) {
        
        gotoNewRootViewController(viewController: "TabBarController")
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

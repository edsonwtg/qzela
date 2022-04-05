//
//  NotificationViewController.swift
//  qzela
//
//  Created by Edson Rocha on 20/11/21.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBAction func btBacktoPreview(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btBacktoTabbar(_ sender: Any) {
        let tabBarController = self.view.window?.windowScene?.keyWindow?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = Config.MENU_ITEM_DASHBOARD
//        self.presentingViewController!.presentingViewController!.dismiss(animated: false, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
//        dismissViewControllers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func dismissViewControllers() {

        guard let vc = self.presentingViewController else { return }

        while (vc.presentingViewController != nil) {
            vc.dismiss(animated: true, completion: nil)
        }
    }

    
}

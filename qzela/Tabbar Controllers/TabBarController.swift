//
//  ViewController.swift
//  qzela
//
//  Created by Edson Rocha on 19/11/21.
//

import UIKit

class TabBarController: UITabBarController {

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("***** TabBarController viewDidAppear *****")
//        print(tabBarController?.selectedIndex)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.rootViewController = tabBarController
        selectedIndex = Config.MENU_ITEM_DASHBOARD
        tabBar.unselectedItemTintColor = UIColor.colorWhite
    }


}


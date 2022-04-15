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
        view.window?.rootViewController = tabBarController
        selectedIndex = Config.MENU_ITEM_MAP
//        tabBar.unselectedItemTintColor = UIColor.colorGray
        tabBar.items![0].title = "text_item_dashboard".localized()
        tabBar.items![1].title = "text_item_map".localized()
        tabBar.items![2].title = "text_item_event".localized()
        tabBar.items![3].title = "text_item_profile".localized()
    }


}


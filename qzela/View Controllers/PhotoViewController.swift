//
//  PhotoViewController.swift
//  qzela
//
//  Created by Edson Rocha on 19/12/21.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBAction func btBacktoTabBar(_ sender: Any) {
        tabBarController?.selectedIndex = 2
        dismiss(animated: true, completion: nil)
   }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  PreviewViewController.swift
//  qzela
//
//  Created by Edson Rocha on 20/11/21.
//

import UIKit

class PreviewViewController: UIViewController {

    // var to receive data from PhotoViewController
    var urlImage: String?

    @IBOutlet weak var imageView: UIImageView!

    @IBAction func btClick(_ sender: UIButton) {

        switch sender.restorationIdentifier {
        case "btOk":
            Config.deletePhoto = 0
            dismiss(animated: true, completion: nil)
        case "btDelete":
            // pass data to view controller
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if urlImage == nil {
            dismiss(animated: true, completion: nil)
        }

        imageView.image = UIImage(contentsOfFile: urlImage!)
    }

}

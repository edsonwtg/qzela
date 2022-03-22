//
//  SplashViewController.swift
//  qzela
//
//  Created by Edson Rocha on 20/11/21.
//

import UIKit

class SplashViewController: UIViewController {

    let config = Config()
    let fileManager = FileManager.default

    @IBAction func btGotoLogin(_ sender: Any) {
        gotoNewRootViewController(viewController: "LoginViewController")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // print("GO TO Login *********")
        gotoNewRootViewController(viewController: "LoginViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Pass this functionality to initialize APP function
        // check if simulator or device
        #if (arch(i386) || arch(x86_64)) && (!os(macOS))
        Config.isSimulator = true
        #else
        Config.isSimulator = false
        #endif

        // Clean and create document directory
        // print("************** CLEAN PATH_TEMP_FILES ************", #file.components(separatedBy: "/").last!, #line)
        config.cleanDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
        // print("************** CREATE PATH_SAVED_FILES ************", #file.components(separatedBy: "/").last!, #line)
        config.createDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)

//        config.cleanDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)
//        config.listDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)
//        print("************** CLEAN USER DEFAULTS ************", #file.components(separatedBy: "/").last!, #line)
//        config.clearUserDefault()

//        print("************** getUserDefaults ************", #file.components(separatedBy: "/").last!, #line)
        config.getUserDefaults()
//        print(Config.saveQtdIncidents)
//        print(Config.saveIncidents)
//        config.listDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)

        // Delete files saved more 1 day.
        if (Config.saveQtdIncidents > 0) {
            var countIncident = 0
            for incident in Config.saveIncidents {
                let diffInDays = Calendar.current.dateComponents([.day], from: incident.dateTime, to: Date()).day
                if (diffInDays! > 0) {
                    Config.saveQtdIncidents -= 1
                    Config.saveIncidents.remove(at: countIncident)
                    for imageSave in incident.savedImages {
                        let fileDelete = Config.PATH_SAVED_FILES+"/"+imageSave.fileImage
                        config.deleteImage(fileManager: fileManager, pathFileFrom: fileDelete)
                    }
                } else {
                    countIncident += 1
                }
            }
            // Save user defaults
            let data = try! JSONEncoder().encode(Config.saveIncidents)
            Config.userDefaults.set(data, forKey: "incidentSaved")
            Config.userDefaults.set(Config.saveQtdIncidents, forKey: "qtdIncidentSaved")
        }
    }

    func gotoNewRootViewController(viewController: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: viewController)
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }

    func gotoViewControllerWithBack(viewController: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: viewController)
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.modalTransitionStyle = .flipHorizontal
        self.present(nextViewController, animated: true)
    }
}

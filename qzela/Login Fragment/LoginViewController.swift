//
//  LoginViewController.swift
//  qzela
//
//  Created by Edson Rocha on 20/11/21.
//

import UIKit
import Apollo

class LoginViewController: UIViewController {

    let config = Config()

    @IBAction func btGotoTabbar(_ sender: Any) {
        
        config.gotoNewRootViewController(view: view, withReuseIdentifier: "TabBarController")
     }

    override func viewDidLoad() {
        super.viewDidLoad()

        if (Config.SAV_ACCESS_TOKEN == "") {
            // TODO: get login data from user
            // CorpUser
//            Config.SAV_ACCESS_TOKEN = "121436c7d02486ee124049af1e8aa35ff9c003125baa77c9e4e6ce6a6dd6aa51ebd8b26f880a05d279f1c5cac3e6b716970657c48c01d9077ab8c1ce784993b62eec46e9e168e5a6c53abdadb5b44121be25b149538b771d3a5c6d7b55ec2260d2c32ad16598d3495c2ddc211589bd59"
//            Config.SAV_CD_USUARIO = "5d987cacdef23b533dd00a36"
            // Edson Rocha Teste
                            //            Config.SAV_ACCESS_TOKEN = "43f645701012ff0c8eba4f7bb4fde5e69c4847c81da34d3a92c09e1e68a24abd2a582af01ae9f77e848f5d5cc84845ec834852ea142e8b0e70cfd6a636fe028461e7a7840d33207d8e021585823113d79551d545888e8af06c18c96854bfd49f"
                            //            Config.SAV_CD_USUARIO = "5ec7cd72d625e878ab3dc70f"
            Config.SAV_DC_EMAIL = "edsonrocha@teste.com";
            Config.SAV_DC_SENHA = "123456";
            Config.SAV_OUTER_AUTH = 0;
            Config.SAV_NOTIFICATION_ID = "cFFwwH5Q58gsdVOq_fnMoM:APA91bHPmhZrQMucXGSj5D4P2lRRxifNWvxOWoNo7t0NNbCNuhLZS22jMThVI5h7tYzYLhkbOz9J9V7pBl73KO2St8CFQpLLVbF2K82WGzP6s0CHb8H1_9AbVXP5M4PXMD8DsdfYmYPk";
//            "email": "edsonrocha@teste.com",
//            "password": "123456",
//            "deviceId":  "bc1692b6e90631f0",
//            "devicePlatform": "Android",
//            "language" : "en_US",
//            "notificationId": "cFFwwH5Q58gsdVOq_fnMoM:APA91bHPmhZrQMucXGSj5D4P2lRRxifNWvxOWoNo7t0NNbCNuhLZS22jMThVI5h7tYzYLhkbOz9J9V7pBl73KO2St8CFQpLLVbF2K82WGzP6s0CHb8H1_9AbVXP5M4PXMD8DsdfYmYPk"

            // Edson Rocha Terra
//            Config.SAV_ACCESS_TOKEN = "eb78135a19865e5185cc503bb3b0697832b985aca7eb4d82c424e59ccfa4cd67085fac5d93e902a010a2d01633ec1e4917430fc93d911e2f8ee103e17ea1887c34a5644b962a24129c29b54aaa1803b1eaf39d9f8e11c7c6c23cfbc693c19e1a9a5e870bc7ba1a8062f141e1c545e5df50fe655c1ed3a2d69f356a4bed234e8d"
//            Config.SAV_CD_USUARIO = "5ece7b9be7334d11ce91a31c"
//            Config.SAV_OUTER_AUTH = 0;
//            Config.SAV_NOTIFICATION_ID = "cFFwwH5Q58gsdVOq_fnMoM:APA91bHPmhZrQMucXGSj5D4P2lRRxifNWvxOWoNo7t0NNbCNuhLZS22jMThVI5h7tYzYLhkbOz9J9V7pBl73KO2St8CFQpLLVbF2K82WGzP6s0CHb8H1_9AbVXP5M4PXMD8DsdfYmYPk";
///            "email": "edsonrocha@terra.com.br",
//            "password": "123456",
//            "deviceId":  "bc1692b6e90631f0",
//            "devicePlatform": "Android",
//            "language" : "en_US",
//            "notificationId": "cFFwwH5Q58gsdVOq_fnMoM:APA91bHPmhZrQMucXGSj5D4P2lRRxifNWvxOWoNo7t0NNbCNuhLZS22jMThVI5h7tYzYLhkbOz9J9V7pBl73KO2St8CFQpLLVbF2K82WGzP6s0CHb8H1_9AbVXP5M4PXMD8DsdfYmYPk"
        }
        Config.SAV_ACCESS_TOKEN = ""
        Config.SAV_CD_USUARIO = ""
        Config.SAV_DC_EMAIL = "edsonrocha@teste.com";
        Config.SAV_DC_SENHA = "123456";
        Config.SAV_OUTER_AUTH = 0;
        Config.SAV_NOTIFICATION_ID = "cFFwwH5Q58gsdVOq_fnMoM:APA91bHPmhZrQMucXGSj5D4P2lRRxifNWvxOWoNo7t0NNbCNuhLZS22jMThVI5h7tYzYLhkbOz9J9V7pBl73KO2St8CFQpLLVbF2K82WGzP6s0CHb8H1_9AbVXP5M4PXMD8DsdfYmYPk";

        let login  = Login()
        login.getLogin(
                email: Config.SAV_DC_EMAIL,
                password: Config.SAV_DC_SENHA,
                notificationId: Config.SAV_NOTIFICATION_ID
        ){ result in
           if !(login.getMessage() == "Login Ok") {
                self.showAlert(title: "text_warning".localized(),
                        message: login.getMessage().localized(),
                        type: .attention,
                        actionTitles: ["text_got_it".localized()],
                        style: [.default],
                        actions: [nil]
                )
                return
            } else {
                Config.SAV_ACCESS_TOKEN = login.getAccessToken()
                Config.SAV_CD_USUARIO = login.getUserId()
                Config.userDefaults.set(Config.SAV_ACCESS_TOKEN, forKey: "accessToken")
                Config.userDefaults.set(Config.SAV_CD_USUARIO, forKey: "cdUser")
                Config.userDefaults.set(Config.SAV_DC_EMAIL, forKey: "dcEmail")
                Config.userDefaults.set(Config.SAV_DC_SENHA, forKey: "dcSenha")
                Config.userDefaults.set(Config.SAV_OUTER_AUTH, forKey: "outherOAuth")
                self.config.gotoNewRootViewController(view: self.view, withReuseIdentifier: "TabBarController")
            }
        }

//        ApolloIOS.shared.apollo.perform(mutation: LoginCitizenMutation(
//                email: Config.SAV_DC_EMAIL,
//                password: Config.SAV_DC_SENHA,
//                deviceId: "bc1692b6e90631f0",
//                devicePlatform: "Ios",
//                language: "en_US",
//                notificationId: Config.SAV_NOTIFICATION_ID)
//        ) { result in
//            switch result {
//            case .success(let graphQLResult):
//                print("Success! Result: \(graphQLResult)")
//                if (graphQLResult.data != nil) {
//                    Config.SAV_ACCESS_TOKEN = (graphQLResult.data?.loginCitizen.accessToken)!
//                    Config.SAV_CD_USUARIO = (graphQLResult.data?.loginCitizen.userId)!
//                    self.config.gotoNewRootViewController(view: self.view, withReuseIdentifier: "TabBarController")
//                }
//                if (graphQLResult.errors != nil) {
//                    if (graphQLResult.errors?.description == "[You are already logged in!]") {
//                        self.config.gotoNewRootViewController(view: self.view, withReuseIdentifier: "TabBarController")
//                    }
//                    print("ERROR: \(String(describing: graphQLResult.errors?.description))")
//                }
//            case .failure(let error):
//                print("Failure! Error: \(error)")
//            }
//        }
    }
}

//
// Created by Edson Rocha on 23/03/22.
//

import Foundation
import Apollo

class Login: NSObject {

    private var accessToken: String!
    private var userId: String!
    private var message: String!

    override init() {
        super.init()
        message = "wait"
    }

    public func getLogin(email: String, password: String, notificationId: String, completion: @escaping ( String ) -> Void) {
        ApolloIOS.shared.apollo.perform(mutation: LoginCitizenMutation(
                email: email,
                password: password,
                deviceId: Config.SAV_DEVICE_ID,
                devicePlatform: Config.SAV_DEVICE_PLATFORM,
                language: Config.CURRENT_LANGUAGE,
                notificationId: notificationId)
        ) { result in
            switch result {
            case .success(let graphQLResult):
                if (graphQLResult.data != nil) {
                    self.accessToken = (graphQLResult.data?.loginCitizen.accessToken)!
                    self.userId = (graphQLResult.data?.loginCitizen.userId)!
                    self.message = "Login Ok"
                }
                if (graphQLResult.errors != nil) {
                    self.accessToken = ""
                    self.userId = ""
                    self.message = graphQLResult.errors?.description
                }
            case .failure(let error):
                print("Failure! Error: \(error)")
                self.accessToken = ""
                self.userId = ""
                self.message = "Login ERROR"
            }
            self.convertMessage(message: self.message)
            completion(self.message)
        }
    }

    private func convertMessage(message: String) {

        switch message {
        case "[You are already logged in!]":
            accessToken = Config.SAV_ACCESS_TOKEN
            userId = Config.SAV_CD_USUARIO
            setMessage(message: "Login Ok")
            break
        case "You are already logged in!":
            accessToken = Config.SAV_ACCESS_TOKEN
            userId = Config.SAV_CD_USUARIO
            setMessage(message: "Login Ok")
            break

        case "Need to confirm e-mail.":
            Config.SAV_ACCESS_TOKEN = accessToken
            Config.SAV_CD_USUARIO = userId
            setMessage(message: "text_confirm_email".localized())
            break

        case "Wrong password or e-mail.":
            Config.SAV_ACCESS_TOKEN = accessToken
            Config.SAV_CD_USUARIO = userId
            setMessage(message: "text_wrong_email_pass".localized())
            break

        case "Email already in use.":
            Config.SAV_ACCESS_TOKEN = accessToken
            Config.SAV_CD_USUARIO = userId
            setMessage(message: "text_email_used".localized())
            break

        case "E-mail not registered.":
            Config.SAV_ACCESS_TOKEN = accessToken
            Config.SAV_CD_USUARIO = userId
            setMessage(message: "text_email_not_registered".localized())
            break

        case "This email is registered via E-mail":
            Config.SAV_ACCESS_TOKEN = accessToken
            Config.SAV_CD_USUARIO = userId
            setMessage(message: "text_wrong_email_auth_email".localized())
            break

        case "This email is registered via Google":
            Config.SAV_ACCESS_TOKEN = accessToken
            Config.SAV_CD_USUARIO = userId
            setMessage(message: "text_wrong_email_auth_google".localized())
            break

        case "This email is registered via Facebook":
            Config.SAV_ACCESS_TOKEN = accessToken
            Config.SAV_CD_USUARIO = userId
            setMessage(message: "text_wrong_email_auth_facebook".localized())
            break

        case "This email is registered via Apple":
            Config.SAV_ACCESS_TOKEN = accessToken
            Config.SAV_CD_USUARIO = userId
            setMessage(message: "text_wrong_email_auth_apple".localized())
            break

        case "Login ERROR":
            Config.SAV_ACCESS_TOKEN = accessToken
            Config.SAV_CD_USUARIO = userId
            setMessage(message: "text_service_unavalible".localized())
            break

        case "Login Ok":
            Config.SAV_ACCESS_TOKEN = accessToken
            Config.SAV_CD_USUARIO = userId
            setMessage(message: "Login Ok")
            break

        case "SignUp Ok":
            setMessage(message: "SignUp Ok")
            break

        case "SignUp ERROR":
            setMessage(message: "text_service_unavailable".localized())
            break

        default:
            setMessage(message: "text_service_unavailable".localized())
            break
        }
    }

    public func getAccessToken() -> String {
        accessToken
    }

    public func getUserId() -> String {
        userId
    }

    public func getMessage() -> String {
        message
    }

    public func setMessage(message: String) {
        self.message = message
    }
}

//
// Created by Edson Rocha on 11/04/22.
//

import Foundation
import Apollo
import FirebaseStorage
import CoreLocation


class SendIncident: NSObject {

//    var view: UIViewController!
//    var segmentId: Int!
//    var occurrencesItem: [String] = []
//    var commentary: String!
//    var placeCoordinate: CLLocation!
//    var addressGeocoding = Config.Geocoding()
//    var imageFiles: Array<String>
//    var imageType: String!

    private var mapImageFile: String!
    private var downloadUrlImageFiles: Array<String> = []

    // Create Firebase Bucket Directory
    private let dateIncident = Date()
    private let dateFormatter = DateFormatter()
    private var buketDirectory: String!
    private let config = Config()

    override init() {
        super.init()
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: dateIncident) + "/"
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: dateIncident) + "/"
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: dateIncident) + "/"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        buketDirectory = year + month + day + dateFormatter.string(from: dateIncident) + "/"
    }

    func sendOpenIncident(view: UIViewController,
                          segmentId: Int,
                          occurrencesItem: [String],
                          commentary: String,
                          placeCoordinate: CLLocation,
                          addressGeocoding: Config.Geocoding,
                          imageFiles: Array<String>,
                          imageType: String,
                          completion: @escaping (Bool) -> Void
    ) {
//        print("************ PREPARE FOR INSERT INCIDENT ***************")
//        print("CitizenID: \(Config.SAV_CD_USUARIO)")
//        print("SegmentId: \(segmentId)")
//        print("OccurrencesIds: \(occurrencesItem)")
//        print("Commentary: \(String(describing: commentary))")
//        print("Latitude: \(placeCoordinate.coordinate.latitude)")
//        print("Longitude: \(placeCoordinate.coordinate.longitude)")
//        print("IMAGE Type: \(String(describing: imageType))")
//        print("IMAGE Files: \(imageFiles)")
//        print("Endere??o Completo: \(addressGeocoding.completeAddress + " " + addressGeocoding.number)");
//        print("Endere??o: \(addressGeocoding.address)");
//        print("Numero: \(addressGeocoding.number)");
//        print("Pais: \(addressGeocoding.country)");
//        print("Estado: \(addressGeocoding.state)");
//        print("Cidade: \(addressGeocoding.city)");
//        print("Bairro: \(addressGeocoding.district)");
//        print("CEP: \(addressGeocoding.postalCode)")

        LoadingStart(view: view,
                title: "text_please_wait".localized(),
                message: "text_send_incident".localized(),
                style: .alert,
                type: .loading)
        sendImages(imageFiles: imageFiles, imageType: imageType) { [self] result in
//                print("IMAGE SEND: \(result)")
            downloadUrlImageFiles = downloadUrlImageFiles.sorted()
            sendOpenData(segmentId: segmentId,
                    occurrencesItem: occurrencesItem,
                    commentary: commentary,
                    placeCoordinate: placeCoordinate,
                    addressGeocoding: addressGeocoding,
                    imageType: imageType
            ) { [self] result in
                LoadingStop()
                let secondsToDelay = 3.0
                LoadingStart(
                        view: view,
                        title: "text_thankyou".localized(),
                        message: "text_incident_resolved".localized(),
                        style: .alert,
                        type: .message)
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    self.LoadingStop()
                    completion(result)
                }
            }
        }
    }

    func sendCloseIncident(view: UIViewController,
                           incidentId: String,
                           citizenId: String,
                           imageFiles: Array<String>,
                           imageType: String,
                           completion: @escaping (Bool) -> Void) {

        LoadingStart(view: view,
                title: "text_please_wait".localized(),
                message:  "text_send_incident".localized(),
                style: .alert,
                type: .loading)
        sendImages(imageFiles: imageFiles, imageType: imageType) { [self] result in
//                print("IMAGE SEND: \(result)")
            downloadUrlImageFiles = downloadUrlImageFiles.sorted()
            sendCloseData(incidentId: incidentId, imageType: imageType) { [self] result in
                LoadingStop()
                let secondsToDelay = 3.0
                LoadingStart(
                        view: view,
                        title: "text_thankyou".localized(),
                        message: "text_incident_resolved".localized(),
                        style: .alert,
                        type: .message)
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    self.LoadingStop()
                    completion(result)
                }
            }
        }

    }

    private func sendImages(imageFiles: [String], imageType: String, completion: @escaping ([String]) -> Void) {

        var totSend = 0
        // Create Storage
        var storage: Storage!
        if (Config.CLOSE_INCIDENT && (Config.SAV_CLOSE_BUCKET == Config.FIREBASE_INCIDENTS_BUCKET_LEGACY)) {
            storage = Storage.storage(url: Config.FIREBASE_INCIDENTS_BUCKET_URI_LEGACY)
        } else {
            storage = Storage.storage(url: Config.FIREBASE_INCIDENTS_BUCKET_URI)
        }
        let metadata = StorageMetadata()
        let storageRef = storage.reference()

        for i in 0..<imageFiles.count {

            // Create a root reference
            var fileRef: StorageReference!

            let url = NSURL(fileURLWithPath: imageFiles[i])
            if (imageFiles[i].contains("MAP_")) {
                metadata.contentType = "image/jpeg"
                fileRef = storageRef.child(Config.INCIDENTS_IMAGES_PATH + buketDirectory + "map.jpg")
            } else if (imageType == Config.TYPE_IMAGE_PHOTO) {
                metadata.contentType = "image/jpeg"
                if (Config.CLOSE_INCIDENT) {
                    fileRef = storageRef.child(Config.SAV_CLOSE_IMAGE_DIRECTORY + "/img_close_" + String(i) + ".jpg")
                } else {
                    fileRef = storageRef.child(Config.INCIDENTS_IMAGES_PATH + buketDirectory + "img_open_" + String(i) + ".jpg")
                }
            } else {
                metadata.contentType = "video/mp4"
                if (Config.CLOSE_INCIDENT) {
                    fileRef = storageRef.child("gs://"+Config.SAV_CLOSE_IMAGE_DIRECTORY + "/vid_close_" + String(i) + ".mp4")
                } else {
                    fileRef = storageRef.child(Config.INCIDENTS_IMAGES_PATH + buketDirectory + "vid_open_" + String(i) + ".mp4")
                }
            }
            fileRef.putFile(from: url as URL, metadata: metadata) { metadata, error in
                guard metadata != nil else {
                    print("Uh-oh, an error occurred!")
                    return
                }
//                print("URL: \(metadata)")
                // You can also access to download URL after upload.
                fileRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
//                    print("Image URL: \(downloadURL.description)")
                    self.downloadUrlImageFiles.append(downloadURL.description)
                    totSend += 1
                    if (totSend == imageFiles.count) {
                        completion(self.downloadUrlImageFiles)
                    }
                }
            }
        }
    }

    private func sendOpenData(segmentId: Int,
                              occurrencesItem: [String],
                              commentary: String,
                              placeCoordinate: CLLocation,
                              addressGeocoding: Config.Geocoding,
                              imageType: String,
                              completion: @escaping (Bool) -> Void) {
        ApolloIOS.shared.apollo.perform(mutation: SetOpenIncidentMutation(
                cdSegment: segmentId,
                locCoord: [placeCoordinate.coordinate.latitude, placeCoordinate.coordinate.longitude],
                dcAddress: addressGeocoding.address + "," + addressGeocoding.number,
                dcCity: addressGeocoding.city,
                dcState: addressGeocoding.state,
                dcCountry: addressGeocoding.country,
                dcNeighborhood: addressGeocoding.district,
                dcZipCode: addressGeocoding.postalCode,
                occurrencesIds: occurrencesItem,
                citizenId: Config.SAV_CD_USUARIO,
                dtOpen: ISODate.now,
                txComment: commentary,
                tpMedia: imageType == Config.TYPE_IMAGE_PHOTO ? TPMEDIA_ENUM.photo : TPMEDIA_ENUM.video,
                mediaData: downloadUrlImageFiles)
        ) { result in
            switch result {
            case .success(let graphQLResult):
//                print("Success! Result: \(String(describing: graphQLResult.data?.openIncident.description))")
                if (graphQLResult.errors != nil) {
                    print("ERROR: \(String(describing: graphQLResult.errors?.description))")
                    completion(false)
                } else {
                    completion(true)
                }
            case .failure(let error):
                print("Failure! Error: \(error)")
                completion(false)
            }
        }
    }

    private  func sendCloseData(incidentId: String, imageType: String,
                                completion: @escaping (Bool) -> Void) {
        ApolloIOS.shared.apollo.perform(mutation:SetCloseIncidentMutation(
                incidentId: incidentId,
                dtClose: ISODate.now,
                mediaData: downloadUrlImageFiles,
                tpAction: .close,
                tpMedia: imageType == Config.TYPE_IMAGE_PHOTO ? TPMEDIA_ENUM.photo : TPMEDIA_ENUM.video,
                citizenId: Config.SAV_CD_USUARIO)
        ) { result in
            switch result {
            case .success(let graphQLResult):
                // print("Success! Result: \(String(describing: graphQLResult.data?.closeIncident.description))")
                if (graphQLResult.errors != nil) {
                    print("ERROR: \(String(describing: graphQLResult.errors?.description))")
                    completion(false)
                } else {
                    completion(true)
                }
            case .failure(let error):
                print("Failure! Error: \(error)")
                completion(false)
            }
        }
    }

    private enum Alert {
        case error
        case message
        case attention
        case info
        case loading
    }

    private func LoadingStart(view: UIViewController, title: String, message: String, style: UIAlertController.Style, type: Alert) {
        ProgressDialog.alert = UIAlertController(title: title, message: message, preferredStyle: style)
        // Accessing alert view backgroundColor :
        // ProgressDialog.alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.qzelaOrange
        if (type == Alert.attention) {
            ProgressDialog.alert.view.layer.borderWidth = 4
            ProgressDialog.alert.view.layer.borderColor = UIColor.colorRed.cgColor
        } else {
            ProgressDialog.alert.view.layer.borderWidth = 4
            ProgressDialog.alert.view.layer.borderColor = UIColor.qzelaDarkBlue.cgColor
        }
        ProgressDialog.alert.view.layer.cornerRadius = 12
        // Accessing alert title color :
        ProgressDialog.alert.setValue(NSAttributedString(string: ProgressDialog.alert.title!,
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium),
                             NSAttributedString.Key.foregroundColor: UIColor.qzelaOrange]),
                forKey: "attributedTitle")
        // Accessing alert message color :
        ProgressDialog.alert.setValue(NSAttributedString(string: ProgressDialog.alert.message!,
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium),
                             NSAttributedString.Key.foregroundColor: UIColor.qzelaDarkBlue]),
                forKey: "attributedMessage")
        if (type == Alert.loading) {
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 15, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.color = .qzelaDarkBlue
            loadingIndicator.style = UIActivityIndicatorView.Style.large
            loadingIndicator.startAnimating();
            ProgressDialog.alert.view.addSubview(loadingIndicator)
        }
        view.present(ProgressDialog.alert, animated: true, completion: nil)
    }

    private func LoadingStop() {
        ProgressDialog.alert.dismiss(animated: true, completion: nil)
    }

}
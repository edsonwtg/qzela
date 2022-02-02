//
//  PhotoViewController.swift
//  qzela
//
//  Created by Edson Rocha on 19/12/21.
//

import UIKit
import AVFoundation
import MapKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var stackViewPhoto: UIStackView!
    @IBOutlet weak var photoImage1: UIImageView!
    @IBOutlet weak var photoImage2: UIImageView!
    @IBOutlet weak var photoImage3: UIImageView!
    @IBOutlet weak var btPhotoVideo: UIButton!
    @IBOutlet weak var btFlash: UIButton!
    @IBOutlet weak var btTakePhoto: UIButton!
    @IBOutlet weak var btRecordVideo: UIButton!
    @IBOutlet weak var btSave: UIButton!
    @IBOutlet weak var btContinue: UIButton!


    // Capture Session
    var session: AVCaptureSession?
    // Photo Output
    let output = AVCapturePhotoOutput()
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    // Storage
    enum StorageType {
        case userDefaults
        case fileSystem
    }
    let fileManager = FileManager.default

    var bShootPhoto = false
    var bShootVideo = false

    var bPhoto = true
    var tpFlash = 1

    var bPhoto1 = false
    var bPhoto2 = false
    var bPhoto3 = false

    var filePhoto1: String = ""
    var filePhoto2: String = ""
    var filePhoto3: String = ""

    var imageFileName: String = ""

    var gpsLocation = qzela.GPSLocation()
    let config = Config()


    override func viewDidLoad() {
        super.viewDidLoad()

        let tap1 = UITapGestureRecognizer(target: self, action: #selector(showPhoto))
        photoImage1.layer.borderWidth = 2
        photoImage1.layer.borderColor = UIColor.colorWhite.cgColor
        photoImage1.alpha = 0.75
        photoImage1.isUserInteractionEnabled = true
        photoImage1.addGestureRecognizer(tap1)

        photoImage2.layer.borderWidth = 2
        photoImage2.layer.borderColor = UIColor.colorWhite.cgColor
        photoImage2.alpha = 0.75
        photoImage2.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(showPhoto))
        photoImage2.addGestureRecognizer(tap2)

        photoImage3.layer.borderWidth = 2
        photoImage3.layer.borderColor = UIColor.colorWhite.cgColor
        photoImage3.alpha = 0.75
        photoImage3.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(showPhoto))
        photoImage3.addGestureRecognizer(tap3)

        btRecordVideo.visibility = .invisible
        btSave.setTitle("text_save".localized(), for: .normal)
        btSave.isEnabled = false
        btContinue.setTitle("text_continue".localized(), for: .normal)
        btContinue.isEnabled = false
        // TODO: Pass thisd functionality to initialize APP function
        // create document diretory
        config.cleanDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
//        config.cleanDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)
//        config.clearUserDefault()
        config.getUserDefaults()


        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds

        setupCamera()
    }

    @IBAction func btBacktoTabBar(_ sender: Any) {
        tabBarController?.selectedIndex = 2
        dismiss(animated: true, completion: nil)
    }

    @IBAction func btClick(_ sender: UIButton) {
        switch sender.restorationIdentifier {
        case "btPhotoVideo":
            print("btPhotoVideo")
            tpFlash = 1
            btFlash.setImage(UIImage(systemName: "bolt.badge.a.fill"), for: .normal)
            if (bPhoto) {
                bPhoto = false
                btPhotoVideo.setImage(UIImage(systemName: "camera.fill"), for: .normal)
                btTakePhoto.visibility = .invisible
                btRecordVideo.visibility = .visible
                photoImage2.visibility = .invisible
                photoImage3.visibility = .invisible
            } else {
                bPhoto = true
                btPhotoVideo.setImage(UIImage(systemName: "video.fill"), for: .normal)
                btRecordVideo.visibility = .invisible
                btTakePhoto.visibility = .visible
                photoImage2.visibility = .visible
                photoImage3.visibility = .visible
            }
        case "btRecorVideo":
            print("btRecordVideo")
        case "btFlash":
            print("btFlash")
            if (tpFlash == 1) {
                tpFlash = 2
                btFlash.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
            } else if (tpFlash == 2) {
                tpFlash = 3
                btFlash.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
            } else {
                tpFlash = 1
                btFlash.setImage(UIImage(systemName: "bolt.badge.a.fill"), for: .normal)
            }
        case "btTakePhoto":
//            let photoSettings = AVCapturePhotoSettings()
//            if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
//                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
//                output.capturePhoto(with: photoSettings, delegate: self)
//            }
            photoToTest()
        case "btSave":
            print("btSave")

            print("************** PATH_TEMP_FILES ************")
            config.listDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
            print("************** PATH_SAVED_FILES ************")
            config.listDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)

            if (bPhoto1) {
                config.moveImage(fileManager: fileManager, pathFileFrom: filePhoto1, pathTo: Config.PATH_SAVED_FILES)
                Config.saveImages.append(Config.SaveIncidents.SavedImages(fileImage: filePhoto1))
                photoImage1.image = nil
                bPhoto1 = false
            }
            if (bPhoto2) {
                config.moveImage(fileManager: fileManager, pathFileFrom: filePhoto2, pathTo: Config.PATH_SAVED_FILES)
                Config.saveImages.append(Config.SaveIncidents.SavedImages(fileImage: filePhoto2))
                photoImage2.image = nil
                bPhoto2 = false
            }
            if (bPhoto3) {
                config.moveImage(fileManager: fileManager, pathFileFrom: filePhoto3, pathTo: Config.PATH_SAVED_FILES)
                Config.saveImages.append(Config.SaveIncidents.SavedImages(fileImage: filePhoto3))
                photoImage3.image = nil
                bPhoto1 = false
            }
            Config.savCoordinate = CLLocationCoordinate2D(latitude: -23.612992, longitude: -46.682762)
            Config.saveQtdIncidents += 1
            Config.saveIncidents.append(Config.SaveIncidents(
                    id: Config.saveQtdIncidents,
                    latitude: Config.savCoordinate.latitude,
                    longitude: Config.savCoordinate.longitude,
                    dateTime:  Date(),
                    savedImages: Config.saveImages)
            )
            print(Config.saveIncidents)
            // Save user defaults
            let data = try! JSONEncoder().encode(Config.saveIncidents)
            Config.userDefaults.set(data, forKey: "incidentSaved")
            Config.userDefaults.set(Config.saveQtdIncidents, forKey: "qtdIncidentSaved")
            print("************** PATH_TEMP_FILES ************")
            config.listDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
            print("************** PATH_SAVED_FILES ************")
            config.listDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)

            let actionHandler: (UIAlertAction) -> Void = { (action) in
                //Back to Map
                Config.backSaveIncident = true
                self.dismiss(animated: true, completion: nil)
                print("****** EXIT ******")
            }
            showAlert(title: "text_success".localized(),
                    message: "text_image_save".localized(),
                    actionTitles: ["text_ok".localized()],
                    style: [.default],
                    actions: [actionHandler])
        case "btContinue":
            print("btContinue")
            config.cleanDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
            print("************** PATH_TEMP_FILES ************")
            config.listDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)

//            config.cleanDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)
//            config.clearUserDefault()
//            print("************** PATH_SAVED_FILES ************")
//            config.listDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)
//            config.getUserDefaults()

            photoImage1.image = nil
            bPhoto1 = false
            photoImage2.image = nil
            bPhoto2 = false
            photoImage3.image = nil
            bPhoto3 = false
            btTakePhoto.isEnabled = true
        default:
            break
        }
    }

    // Função para teste no simulador
    func photoToTest() {

        var image: UIImage!
        if (!bPhoto1) {
            image = UIImage(named: "img_open_0")!
            btSave.isEnabled = true
            btContinue.isEnabled = true
        } else if (!bPhoto2) {
            image = UIImage(named: "img_open_1")!
        } else if (!bPhoto3) {
            image = UIImage(named: "img_open_2")!
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        imageFileName = "IMG_" + formatter.string(from: Date()) + ".jpg"
        guard let urlString = config.saveImage(
                fileManager: fileManager,
                path: Config.PATH_TEMP_FILES,
                fileName: imageFileName,
                image: image)
                else {return}
        if (!bPhoto1) {
            filePhoto1 = urlString
            photoImage1.image = UIImage(contentsOfFile: urlString)
            bPhoto1 = true
            print("Photo 1 Localization: " + filePhoto1)
        } else if (!bPhoto2) {
            filePhoto2 = urlString
            photoImage2.image = UIImage(contentsOfFile: urlString)
            bPhoto2 = true
            print("Photo 2 Localization: " + filePhoto2)
        } else if (!bPhoto3) {
            filePhoto3 = urlString
            photoImage3.image = UIImage(contentsOfFile: urlString)
            bPhoto3 = true
            print("Photo 3 Localization: " + filePhoto3)
            btTakePhoto.isEnabled = false
        }
    }

    private func setupCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session

                session.startRunning()
                self.session = session
            }
            catch {
                print("*********** ERROR CAPTURE CAMERA")
            }
        }
    }
    @objc func showPhoto (_ sender: UITapGestureRecognizer) {
        print("SHOW PHOTO: \(String(describing: sender.view?.restorationIdentifier))")
        switch sender.view?.restorationIdentifier {
        case "photoImage1":
            if (bPhoto1) {
                print("PHOTO: 1")
            } else {
                print("NO PHOTO: 1")
            }
        case "photoImage2":
            if (bPhoto1) {
                print("PHOTO: 2")
            }else {
                print("NO PHOTO: 2")
            }
        case "photoImage3":
            if (bPhoto1) {
                print("PHOTO: 3")
            }else {
                print("NO PHOTO: 3")
            }
        default:
            break
        }
    }

}

extension PhotoViewController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: data)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        imageFileName = "IMG_" + formatter.string(from: Date()) + ".jpg"

        guard let urlString = config.saveImage(
                fileManager: fileManager,
                path: Config.PATH_TEMP_FILES,
                fileName: imageFileName,
                image: image!)
        else {
            return
        }
        if (!bPhoto1) {
            filePhoto1 = urlString
            photoImage1.image = UIImage(contentsOfFile: urlString)
            bPhoto1 = true
            btSave.isEnabled = true
            btContinue.isEnabled = true
            print("Photo 1 Localization: " + filePhoto1)
        } else if (!bPhoto2) {
            filePhoto2 = urlString
            photoImage2.image = UIImage(contentsOfFile: urlString)
            bPhoto2 = true
            print("Photo 2 Localization: " + filePhoto2)
        } else if (!bPhoto3) {
            filePhoto3 = urlString
            photoImage3.image = UIImage(contentsOfFile: urlString)
            bPhoto3 = true
            print("Photo 3 Localization: " + filePhoto3)
            btTakePhoto.isEnabled = false
        }
    }
}



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

    //  Photo/Video =device input
    var videoDeviceInput: AVCaptureDeviceInput!

    // Capture Session
    var session = AVCaptureSession()
    var captureSession = AVCaptureSession()

    // Photo Output
    let output = AVCapturePhotoOutput()
    let photoOutput = AVCapturePhotoOutput()
    let videoOutput = AVCaptureMovieFileOutput()
    // Video Preview
    var previewLayer = AVCaptureVideoPreviewLayer()


    private enum DepthDataDeliveryMode {
        case on
        case off
    }

    private enum PortraitEffectsMatteDeliveryMode {
        case on
        case off
    }

    private var depthDataDeliveryMode: DepthDataDeliveryMode = .off
    private var portraitEffectsMatteDeliveryMode: PortraitEffectsMatteDeliveryMode = .off
    private var selectedSemanticSegmentationMatteTypes = [AVSemanticSegmentationMatte.MatteType]()
    private var photoQualityPrioritizationMode: AVCapturePhotoOutput.QualityPrioritization = .balanced



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

    var orientation = UIDevice.current.orientation

    override open var shouldAutorotate: Bool {

        orientation = UIDevice.current.orientation

        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill

        switch (orientation) {
        case .portrait:
            previewLayer.connection?.videoOrientation = .portrait
        case .portraitUpsideDown:
            previewLayer.connection?.videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            previewLayer.connection?.videoOrientation = .landscapeRight
        case .landscapeRight:
            previewLayer.connection?.videoOrientation = .landscapeLeft
        default:
            previewLayer.connection?.videoOrientation = .portrait
        }
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (Config.deletePhoto != 0 ) {
            print("************** PATH_TEMP_FILES ************")
            config.listDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
            print("***** DELETE PHOTO: \(Config.deletePhoto) *****")
            if (Config.deletePhoto == 1) {
                config.deleteImage(fileManager: fileManager, pathFileFrom: filePhoto1)
                photoImage1.image = photoImage2.image
                filePhoto1 = filePhoto2
                photoImage2.image = photoImage3.image
                filePhoto2 = filePhoto3
            }
            if (Config.deletePhoto == 2) {
                config.deleteImage(fileManager: fileManager, pathFileFrom: filePhoto2)
                photoImage2.image = photoImage3.image
                filePhoto2 = filePhoto3
            }
            if (Config.deletePhoto == 3) {
                config.deleteImage(fileManager: fileManager, pathFileFrom: filePhoto3)
            }
            if (filePhoto2 == "") {
                bPhoto2 = false
                photoImage2.image = nil
            }
            if (filePhoto1 == "") {
                bPhoto1 = false
                photoImage1.image = nil
            }
            Config.deletePhoto = 0
            btTakePhoto.isEnabled = true
            photoImage3.image = nil
            filePhoto3 = ""
            bPhoto3 = false
            if (!bPhoto1 && !bPhoto2 && !bPhoto3) {
                btSave.isEnabled = false
                btContinue.isEnabled = false
            }
            print("************** PATH_TEMP_FILES ************")
            config.listDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapGestureImage))
        photoImage1.layer.borderWidth = 2
        photoImage1.layer.borderColor = UIColor.colorWhite.cgColor
        photoImage1.alpha = 0.75
        photoImage1.isUserInteractionEnabled = true
        photoImage1.addGestureRecognizer(tap1)

        photoImage2.layer.borderWidth = 2
        photoImage2.layer.borderColor = UIColor.colorWhite.cgColor
        photoImage2.alpha = 0.75
        photoImage2.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapGestureImage))
        photoImage2.addGestureRecognizer(tap2)

        photoImage3.layer.borderWidth = 2
        photoImage3.layer.borderColor = UIColor.colorWhite.cgColor
        photoImage3.alpha = 0.75
        photoImage3.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(tapGestureImage))
        photoImage3.addGestureRecognizer(tap3)

        btRecordVideo.visibility = .invisible
        btSave.setTitle("text_save".localized(), for: .normal)
        btSave.isEnabled = false
        btContinue.setTitle("text_continue".localized(), for: .normal)
        btContinue.isEnabled = false
        // TODO: Pass thisd functionality to initialize APP function
        // check if simulator or device
        #if (arch(i386) || arch(x86_64)) && (!os(macOS))
            Config.isSimulator = true
        #else
            Config.isSimulator = false
        #endif

        // create document diretory
        config.cleanDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
//        config.cleanDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)
//        config.clearUserDefault()
        config.getUserDefaults()

        cameraStart()
//        setupCamera()
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
            recordVideo()
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
            if Config.isSimulator {
                photoToTest()
            } else {
                takePhoto()
            }
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

            config.cleanDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)
            config.clearUserDefault()
            print("************** PATH_SAVED_FILES ************")
            config.listDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)
            config.getUserDefaults()
            photoImage1.image = nil
            filePhoto1 = ""
            bPhoto1 = false
            photoImage2.image = nil
            filePhoto2 = ""
            bPhoto2 = false
            photoImage3.image = nil
            filePhoto3 = ""
            bPhoto3 = false
            btTakePhoto.isEnabled = true
            Config.deletePhoto = 0
            Config.backSaveIncident = false
        default:
            break
        }
    }

    func takePhoto() {

        if let photoOutputConnection = photoOutput.connection(with: .video) {
            switch (orientation) {
            case .portrait:
                photoOutputConnection.videoOrientation = .portrait
            case .portraitUpsideDown:
                photoOutputConnection.videoOrientation = .portraitUpsideDown
            case .landscapeLeft:
                photoOutputConnection.videoOrientation = .landscapeRight
            case .landscapeRight:
                photoOutputConnection.videoOrientation = .landscapeLeft
            default:
                photoOutputConnection.videoOrientation = .portrait
            }
        }

        let photoSettings = AVCapturePhotoSettings()

        if videoDeviceInput.device.isFlashAvailable {
            if (tpFlash == 1) {
                photoSettings.flashMode = .auto
            } else if (tpFlash == 2){
                photoSettings.flashMode = .on
            } else {
                photoSettings.flashMode = .off
            }
        }

        videoDeviceInput.device.focusMode = .autoFocus

        if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
        }
//
//        photoSettings.isDepthDataDeliveryEnabled = (depthDataDeliveryMode == .on
//                && photoOutput.isDepthDataDeliveryEnabled)
//
//        photoSettings.isPortraitEffectsMatteDeliveryEnabled = (portraitEffectsMatteDeliveryMode == .on
//                && photoOutput.isPortraitEffectsMatteDeliveryEnabled)
//
//        if photoSettings.isDepthDataDeliveryEnabled {
//            if !photoOutput.availableSemanticSegmentationMatteTypes.isEmpty {
//                photoSettings.enabledSemanticSegmentationMatteTypes = selectedSemanticSegmentationMatteTypes
//            }
//        }
//
//        photoSettings.photoQualityPrioritization = photoQualityPrioritizationMode

        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func recordVideo() {
        
    }

    // Função para teste no simulador
    func photoToTest() {

        var image: UIImage!
        if (!bPhoto1) {
            image = UIImage(named: "img_open_0")!
            btSave.isEnabled = true
            btContinue.isEnabled = true
        } else if (!bPhoto2) {
            image = UIImage(named: "open_img_0")!
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
            Config.deletePhoto = 1
        } else if (!bPhoto2) {
            filePhoto2 = urlString
            photoImage2.image = UIImage(contentsOfFile: urlString)
            bPhoto2 = true
            print("Photo 2 Localization: " + filePhoto2)
            Config.deletePhoto = 2
        } else if (!bPhoto3) {
            filePhoto3 = urlString
            photoImage3.image = UIImage(contentsOfFile: urlString)
            bPhoto3 = true
            print("Photo 3 Localization: " + filePhoto3)
            btTakePhoto.isEnabled = false
            Config.deletePhoto = 3
        }
        showImage(urlImage: urlString)
    }

    func showImage(urlImage: String) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        // pass data to view controller
        controller.urlImage = urlImage
        present(controller, animated: true)
    }

    private func cameraStart() {
        captureSession.beginConfiguration()

        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                for: .video, position: .unspecified)
        // Inputs
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice!)
            captureSession.canAddInput(videoDeviceInput)
            captureSession.addInput(videoDeviceInput)

            //  Photo Outputs
            guard captureSession.canAddOutput(photoOutput) else { return }
            captureSession.sessionPreset = .photo
            captureSession.addOutput(photoOutput)

            //  Video Outputs
            guard captureSession.canAddOutput(videoOutput) else { return }
            captureSession.sessionPreset = .iFrame960x540
            captureSession.addOutput(videoOutput)

            captureSession.commitConfiguration()

            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.session = captureSession

            captureSession.startRunning()

            view.layer.insertSublayer(previewLayer, at: 0)
            previewLayer.frame = view.bounds
        } catch {
            print("******* ERROR Config Photo")
        }
    }

    private func setupCamera() {
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

                view.layer.insertSublayer(previewLayer, at: 0)
                previewLayer.frame = view.bounds
            }
            catch {
                print("*********** ERROR CAPTURE CAMERA")
            }
        }
    }

    @objc func tapGestureImage (_ sender: UITapGestureRecognizer) {

        var filePhoto: String!
        switch sender.view?.restorationIdentifier {
        case "photoImage1":
            if (bPhoto1) {
                filePhoto = filePhoto1
                Config.deletePhoto = 1
            } else {
                return
            }
        case "photoImage2":
            if (bPhoto2) {
                filePhoto = filePhoto2
                Config.deletePhoto = 2
            } else {
                return
            }
        case "photoImage3":
            if (bPhoto3) {
                filePhoto = filePhoto3
                Config.deletePhoto = 3
            } else {
                return
            }
        default:
            break
        }
        showImage(urlImage: filePhoto)
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
            Config.deletePhoto = 1
        } else if (!bPhoto2) {
            filePhoto2 = urlString
            photoImage2.image = UIImage(contentsOfFile: urlString)
            bPhoto2 = true
            print("Photo 2 Localization: " + filePhoto2)
            Config.deletePhoto = 2
        } else if (!bPhoto3) {
            filePhoto3 = urlString
            photoImage3.image = UIImage(contentsOfFile: urlString)
            bPhoto3 = true
            print("Photo 3 Localization: " + filePhoto3)
            btTakePhoto.isEnabled = false
            Config.deletePhoto = 3
        }
        showImage(urlImage: urlString)
    }
}



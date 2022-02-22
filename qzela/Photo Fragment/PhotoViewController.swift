//
//  PhotoViewController.swift
//  qzela
//
//  Created by Edson Rocha on 19/12/21.
//

import UIKit
import AVFoundation
import AVKit
import MapKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var stackViewPhoto: UIStackView!
    @IBOutlet weak var stackViewTakeButtons: UIStackView!
    @IBOutlet weak var stackViewSaveContinue: UIStackView!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var photoImage1: UIImageView!
    @IBOutlet weak var photoImage2: UIImageView!
    @IBOutlet weak var photoImage3: UIImageView!
    @IBOutlet weak var btPhotoVideo: UIButton!
    @IBOutlet weak var btFlash: UIButton!
    @IBOutlet weak var btTakePhoto: UIButton!
    @IBOutlet weak var btRecordVideo: UIButton!
    @IBOutlet weak var btSave: UIButton!
    @IBOutlet weak var btContinue: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    //  Photo/Video =device input
    var videoDeviceInput: AVCaptureDeviceInput!

    // Capture Session
    var session = AVCaptureSession()
    var captureSession = AVCaptureSession()

    // Photo Output
    let output = AVCapturePhotoOutput()
    let photoOutput = AVCapturePhotoOutput()
    let videoOutput = AVCaptureMovieFileOutput()

    var videoPathFile = URL(string: Config.PATH_TEMP_FILES)

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
    var fileVideo: String = ""

    var imageFileName: String = ""

    var networkListener = NetworkListener()
    var gpsLocation = qzela.GPSLocation()
    let config = Config()

    var orientation = UIDevice.current.orientation

    var secondsRemaining = 10
    var timerTest : Timer?

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("***** PhotoViewController viewDidAppear *****")
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoViewController.changeStatusInternet), name: NSNotification.Name(rawValue: Config.internetNotificationKey), object: nil)
        // check Internet
        if (!networkListener.isNetworkAvailable()) {
            print("******** NO INTERNET CONNECTION *********")
            btContinue.visibility = .invisible
        } else {
            btContinue.visibility = .visible
        }
        if (Config.deletePhoto != 0 ) {
            print("************** PATH_TEMP_FILES ************")
            config.listDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
            if (bPhoto) {
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
                enableDisablePhotoButton(enable: true)
                photoImage3.image = nil
                filePhoto3 = ""
                bPhoto3 = false
                if (!bPhoto1 && !bPhoto2 && !bPhoto3) {
                    btSave.isEnabled = false
                    btContinue.isEnabled = false
                }
            } else {
                print("***** DELETE VIDEO: \(Config.deletePhoto) *****")
                if (Config.deletePhoto == 4) {
                    fileVideo = URL(string: fileVideo)!.path
                    config.deleteImage(fileManager: fileManager, pathFileFrom: fileVideo)
                    bShootVideo = false
                    videoImage.image = nil
                    enableDisableRecordButton(enable: true)
                    fileVideo = ""
                    btSave.isEnabled = false
                    btContinue.isEnabled = false
                }
            }
            Config.deletePhoto = 0
            print("************** PATH_TEMP_FILES ************")
            config.listDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
        }
    }

    @objc func changeStatusInternet(notification: NSNotification) {
        guard let type = notification.userInfo!["type"] else { return }
        print("******* RECEIVED Notification PhotoViewController - Network Listener \(type) ********")
        if (type as! String == "unknown") {
            btContinue.visibility = .invisible
        } else {
            btContinue.visibility = .visible
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("***** PhotoViewController viewDidDisappear *****")
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        progressBar.visibility = .invisible
        progressBar.progress = 0.0
        progressBar.progressTintColor = .qzelaDarkBlue
        progressBar.layer.borderWidth = 2
        progressBar.layer.borderColor = UIColor.colorWhite.cgColor

        videoImage.layer.borderWidth = 2
        videoImage.layer.borderColor = UIColor.colorWhite.cgColor
        videoImage.alpha = 0.75
        let tapV = UITapGestureRecognizer(target: self, action: #selector(tapGestureImage))
        videoImage.isUserInteractionEnabled = true
        videoImage.addGestureRecognizer(tapV)
        videoImage.visibility = .invisible

        photoImage1.layer.borderWidth = 2
        photoImage1.layer.borderColor = UIColor.colorWhite.cgColor
        photoImage1.alpha = 0.75
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapGestureImage))
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
//        #if (arch(i386) || arch(x86_64)) && (!os(macOS))
//            Config.isSimulator = true
//        #else
//            Config.isSimulator = false
//        #endif

//        print("************** CLEAN PATH_TEMP_FILES ************", #file.components(separatedBy: "/").last!, #line)
//        config.listDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
//        config.cleanDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
//
//        print("************** CLEAN PATH_SAVED_FILES ************", #file.components(separatedBy: "/").last!, #line)
//        config.listDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)
//        config.cleanDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)
//        print("************** CLEAN USER DEFAULTS ************", #file.components(separatedBy: "/").last!, #line)
//        config.clearUserDefault()
//
//        print("************** getUserDefaults ************", #file.components(separatedBy: "/").last!, #line)
//        config.getUserDefaults()
//        Config.savCoordinate = CLLocationCoordinate2D(latitude: -23.612992, longitude: -46.682762)

        cameraStart()
    }

    @objc func tapGestureImage (_ sender: UITapGestureRecognizer) {

        switch sender.view?.restorationIdentifier {
        case "photoImage1":
            if (bPhoto1) {
                Config.deletePhoto = 1
                showImage(imageFilePath: filePhoto1, bVideo: false)
            } else {
                return
            }
        case "photoImage2":
            if (bPhoto2) {
                Config.deletePhoto = 2
                showImage(imageFilePath: filePhoto2, bVideo: false)
            } else {
                return
            }
        case "photoImage3":
            if (bPhoto3) {
                Config.deletePhoto = 3
                showImage(imageFilePath: filePhoto3, bVideo: false)
            } else {
                return
            }
        case "videoImage":
            print("VIDEO ******")
            if (bShootVideo) {
                Config.deletePhoto = 4
                showImage(imageFilePath: fileVideo, bVideo: true)
            }
        default:
            break
        }
    }

    @IBAction func btBacktoTabBar(_ sender: Any) {
        if (bShootVideo) {
            let okActionHandler: (UIAlertAction) -> Void = {(action) in
                self.config.cleanDirectory(fileManager: self.fileManager, path: Config.PATH_TEMP_FILES)
                print("************** PATH_TEMP_FILES ************")
                self.config.listDirectory(fileManager: self.fileManager, path: Config.PATH_TEMP_FILES)
                self.tabBarController?.selectedIndex = 2
                self.dismiss(animated: true, completion: nil)
            }
            showAlert(title:  "text_attention".localized(),
                    message: "text_change_video".localized(),
                    type: .attention,
                    actionTitles: ["text_cancel".localized(), "text_confirm".localized()],
                    style: [.cancel, .destructive],
                    actions: [nil, okActionHandler])
        } else if (bPhoto1 || bPhoto2 || bPhoto3){
            let okActionHandler: (UIAlertAction) -> Void = {(action) in
                self.config.cleanDirectory(fileManager: self.fileManager, path: Config.PATH_TEMP_FILES)
                print("************** PATH_TEMP_FILES ************")
                self.config.listDirectory(fileManager: self.fileManager, path: Config.PATH_TEMP_FILES)
                self.tabBarController?.selectedIndex = 2
                self.dismiss(animated: true, completion: nil)
            }
            showAlert(
                    title: "text_attention".localized(),
                    message: "text_change_photo".localized(),
                    type: .attention,
                    actionTitles: ["text_cancel".localized(), "text_confirm".localized()],
                    style: [.cancel, .destructive],
                    actions: [nil, okActionHandler]
            )
        } else {
            tabBarController?.selectedIndex = 2
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func btClick(_ sender: UIButton) {
        switch sender.restorationIdentifier {
        case "btPhotoVideo":
            print("btPhotoVideo")
            tpFlash = 1
            btFlash.setImage(UIImage(systemName: "bolt.badge.a.fill"), for: .normal)
            btSave.isEnabled = false
            btContinue.isEnabled = false
            if (bPhoto) {
                if (bPhoto1 || bPhoto2 || bPhoto3) {
                    let okActionHandler: (UIAlertAction) -> Void = {(action) in
                        self.changePhotoVideo()
                    }
                    showAlert(
                            title: "text_attention".localized(),
                            message: "text_change_photo".localized(),
                            type: .attention,
                            actionTitles: ["text_cancel".localized(), "text_confirm".localized()],
                            style: [.cancel, .destructive],
                            actions: [nil, okActionHandler]
                    )
                } else {
                    changePhotoVideo()
                }
            } else {
                if (bShootVideo) {
                    let okActionHandler: (UIAlertAction) -> Void = {(action) in
                        self.changePhotoVideo()
                    }
                    showAlert(title:  "text_attention".localized(),
                            message: "text_change_video".localized(),
                            type: .attention,
                            actionTitles: ["text_cancel".localized(), "text_confirm".localized()],
                            style: [.cancel, .destructive],
                            actions: [nil, okActionHandler])
                } else {
                    changePhotoVideo()
                }
            }
        case "btRecordVideo":
            if Config.isSimulator {
                photoToTest(media: "video")
            } else {
                recordVideo()
            }
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
                photoToTest(media: "photo")
            } else {
                takePhoto()
            }
        case "btSave":
            print("btSave")
            print("************** PATH_TEMP_FILES ************")
            config.listDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
            print("************** PATH_SAVED_FILES ************")
            config.listDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)
            var imageType: String!
            Config.saveImages.removeAll()
            if (bPhoto) {
                imageType = "photo"
                if (bPhoto1) {
                    let fileSaved = Config.PATH_SAVED_FILES+"/"+filePhoto1.components(separatedBy: "/").last!
                    config.moveImage(fileManager: fileManager, pathFileFrom: filePhoto1, pathFileTo: fileSaved)
                    Config.saveImages.append(Config.SaveIncidents.SavedImages(fileImage: fileSaved.components(separatedBy: "/").last!))
                    photoImage1.image = nil
                    bPhoto1 = false
                    filePhoto1 = ""
                }
                if (bPhoto2) {
                    let fileSaved = Config.PATH_SAVED_FILES+"/"+filePhoto2.components(separatedBy: "/").last!
                    config.moveImage(fileManager: fileManager, pathFileFrom: filePhoto2, pathFileTo: fileSaved)
                    Config.saveImages.append(Config.SaveIncidents.SavedImages(fileImage: fileSaved.components(separatedBy: "/").last!))
                    photoImage2.image = nil
                    bPhoto2 = false
                    filePhoto2 = ""
                }
                if (bPhoto3) {
                    let fileSaved = Config.PATH_SAVED_FILES+"/"+filePhoto3.components(separatedBy: "/").last!
                    config.moveImage(fileManager: fileManager, pathFileFrom: filePhoto3, pathFileTo: fileSaved)
                    Config.saveImages.append(Config.SaveIncidents.SavedImages(fileImage: fileSaved.components(separatedBy: "/").last!))
                    photoImage3.image = nil
                    bPhoto1 = false
                    filePhoto3 = ""
                }
            } else {
                imageType = "video"
                if (bShootVideo) {
                    let fileSaved = Config.PATH_SAVED_FILES+"/"+fileVideo.components(separatedBy: "/").last!
                    config.moveImage(fileManager: fileManager, pathFileFrom: fileVideo, pathFileTo: fileSaved)
                    Config.saveImages.append(Config.SaveIncidents.SavedImages(fileImage: fileSaved.components(separatedBy: "/").last!))
                    videoImage.image = nil
                    bShootVideo = false
                    fileVideo = ""
                }
            }
            Config.saveQtdIncidents += 1
//            Config.saveIncidents.append(Config.SaveIncidents(
//                    id: Config.saveQtdIncidents,
//                    latitude: Config.savCoordinate.latitude,
//                    longitude: Config.savCoordinate.longitude,
//                    dateTime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
//                    imageType: imageType,
//                    savedImages: Config.saveImages)
//            )
            Config.saveIncidents.append(Config.SaveIncidents(
                    id: Config.saveQtdIncidents,
                    latitude: Config.savCoordinate.latitude,
                    longitude: Config.savCoordinate.longitude,
                    dateTime: Date(),
                    imageType: imageType,
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
                    message: (bPhoto ? "text_image_save".localized() : "text_video_save".localized()),
                    type: .message,
                    actionTitles: ["text_ok".localized()],
                    style: [.default],
                    actions: [actionHandler])

        case "btContinue":
            print("btContinue")
            if (!networkListener.isNetworkAvailable()) {
                print("******** NO INTERNET CONNECTION *********")
                break
            }
            // Go to Photo View Controller
            let controller = storyboard?.instantiateViewController(withIdentifier: "SegmentViewController") as! SegmentViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true)

//            config.cleanDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
//            print("************** PATH_TEMP_FILES ************")
//            config.listDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
//
//            config.cleanDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)
//            config.clearUserDefault()
//            print("************** PATH_SAVED_FILES ************")
//            config.listDirectory(fileManager: fileManager, path: Config.PATH_SAVED_FILES)
//            config.getUserDefaults()
//            photoImage1.image = nil
//            filePhoto1 = ""
//            bPhoto1 = false
//            photoImage2.image = nil
//            filePhoto2 = ""
//            bPhoto2 = false
//            photoImage3.image = nil
//            filePhoto3 = ""
//            bPhoto3 = false
//            enableDisablePhotoButton(enable: true)
//            Config.deletePhoto = 0
//            Config.backSaveIncident = false
        default:
            break
        }
    }

    func cameraStart() {

         if let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                for: .video, position: .unspecified) {
            do {

                captureSession.beginConfiguration()

                // Inputs
                videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                captureSession.canAddInput(videoDeviceInput)
                captureSession.addInput(videoDeviceInput)


                //  Photo Outputs
                guard captureSession.canAddOutput(photoOutput) else {
                    return
                }
                captureSession.sessionPreset = .photo
                captureSession.addOutput(photoOutput)

                //  Video Outputs
                guard captureSession.canAddOutput(videoOutput) else {
                    return
                }
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
    }

    func takePhoto() {

        bPhoto = true

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

//        videoDeviceInput.device.focusMode = .autoFocus

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

        bPhoto = false

        if let videoOutputConnection = videoOutput.connection(with: .video) {
            switch (orientation) {
            case .portrait:
                videoOutputConnection.videoOrientation = .portrait
            case .portraitUpsideDown:
                videoOutputConnection.videoOrientation = .portraitUpsideDown
            case .landscapeLeft:
                videoOutputConnection.videoOrientation = .landscapeRight
            case .landscapeRight:
                videoOutputConnection.videoOrientation = .landscapeLeft
            default:
                videoOutputConnection.videoOrientation = .portrait
            }
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        imageFileName = "VID_" + formatter.string(from: Date()) + ".mp4"

        videoPathFile = NSURL.fileURL(withPath: Config.PATH_TEMP_FILES+"/"+imageFileName)
        print("************** PATH_TEMP_FILES ************")
        config.listDirectory(fileManager: fileManager, path: Config.PATH_TEMP_FILES)
        try? FileManager.default.removeItem(at: videoPathFile!)
        videoOutput.startRecording(to: videoPathFile!, recordingDelegate: self)
        startVideoRecordTimer()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.stopRecording()
//        }
    }
    
    func stopRecording() {
        if videoOutput.isRecording {
            print("###### STOP VIDEO OK #######")
            videoOutput.stopRecording()
        }
    }

    // Função para teste de foto no simulador
    func photoToTest(media: String) {

        if (media == "photo") {
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
                    else {
                return
            }
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
                enableDisablePhotoButton(enable: false)
                Config.deletePhoto = 3
            }
            showImage(imageFilePath: urlString, bVideo: false)
        } else {
            startVideoRecordTimer()
        }
    }

    func startVideoRecordTimer() {

        progressBar.progress = 0.0
        progressBar.visibility = .visible
        stackViewPhoto.visibility = .invisible
        stackViewTakeButtons.visibility = .invisible
        stackViewSaveContinue.visibility = .invisible
        secondsRemaining = 0
        timerTest = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    @objc func updateCounter(){
        print("\(secondsRemaining) seconds.")
        secondsRemaining += 1
        progressBar.progress = Float(secondsRemaining)/Float(Config.RECORD_VIDEO_TIME)
        if secondsRemaining >= Config.RECORD_VIDEO_TIME {
            print("STOP RECORDER")
            if !Config.isSimulator {
                stopRecording()
            } else {
                fileVideo = "https://firebasestorage.googleapis.com/v0/b/qz-user-data/o/videos%2Fprd%2F2021%2F8%2F12%2Fopen%2F2021-08-12T20%3A23%3A12.872Z-4%2Fvideo.mp4?alt=media&token=d3bd77e6-d0a8-4497-8504-50cf5a25cf7b"
                config.getThumbnailImageFromVideoUrl(url: URL(string: fileVideo)!) { (thumbImage) in
                    guard let resImage = thumbImage else { return }
                    self.videoImage.image = resImage
                }
            }
            progressBar.visibility = .invisible
            stackViewPhoto.visibility = .visible
            stackViewTakeButtons.visibility = .visible
            stackViewSaveContinue.visibility = .visible
            btSave.isEnabled = true
            btContinue.isEnabled = true
            timerTest?.invalidate()
            timerTest = nil
            bShootVideo = true
            enableDisableRecordButton(enable: false)
            showAlert(title: "text_success".localized(),
                    message: "text_video_record".localized(),
                    type: .message,
                    actionTitles: ["text_ok".localized()],
                    style: [.default],
                    actions: [nil])
        }
    }

    func showImage(imageFilePath: String, bVideo: Bool) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        // pass data to view controller
        controller.imageFilePath = imageFilePath
        controller.bUrl = false
        controller.bShow = false
        controller.bVideo = bVideo
        present(controller, animated: true)
    }

    func changePhotoVideo() {
        if (bPhoto) {
            bPhoto = false
            btPhotoVideo.setImage(UIImage(systemName: "camera.fill"), for: .normal)
            btTakePhoto.visibility = .invisible
            btRecordVideo.visibility = .visible
            enableDisableRecordButton(enable: true)
            photoImage1.visibility = .invisible
            if (filePhoto1 != "") {config.deleteImage(fileManager: fileManager, pathFileFrom: filePhoto1)}
            bPhoto1 = false
            filePhoto1 = ""
            photoImage1.image = nil
            photoImage2.visibility = .invisible
            if (filePhoto2 != "") {config.deleteImage(fileManager: fileManager, pathFileFrom: filePhoto2)}
            bPhoto2 = false
            filePhoto2 = ""
            photoImage2.image = nil
            photoImage3.visibility = .invisible
            if (filePhoto3 != "") {config.deleteImage(fileManager: fileManager, pathFileFrom: filePhoto3)}
            bPhoto3 = false
            filePhoto3 = ""
            photoImage3.image = nil
            videoImage.visibility = .visible
        } else {
            bPhoto = true
            btPhotoVideo.setImage(UIImage(systemName: "video.fill"), for: .normal)
            btRecordVideo.visibility = .invisible
            if (fileVideo != "") {config.deleteImage(fileManager: fileManager, pathFileFrom: fileVideo)}
            btTakePhoto.visibility = .visible
            videoImage.visibility = .invisible
            bShootVideo = false
            videoImage.image = nil
            fileVideo = ""
            enableDisablePhotoButton(enable: true)
            photoImage1.visibility = .visible
            photoImage2.visibility = .visible
            photoImage3.visibility = .visible
        }
    }
}

extension PhotoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
        } else {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
            fileVideo = outputFileURL.absoluteString
            config.getThumbnailImageFromVideoUrl(url: outputFileURL) { (thumbImage) in
                guard let resImage = thumbImage else { return }
                self.videoImage.image = resImage
            }
        }
    }

    func enableDisableRecordButton(enable: Bool) {
        var backgroundConfig = UIButton.Configuration.plain()
        backgroundConfig.background.strokeOutset = -6
        backgroundConfig.background.strokeWidth = 5
        backgroundConfig.background.strokeColor = .colorWhite
        if enable {
            btRecordVideo.isEnabled = true
            backgroundConfig.background.backgroundColor = .colorRed
        } else {
            btRecordVideo.isEnabled = false
            backgroundConfig.background.backgroundColor = .colorDarkGray
        }
        btRecordVideo.configuration = backgroundConfig
    }

    func enableDisablePhotoButton(enable: Bool) {
        var backgroundConfig = UIButton.Configuration.plain()
        backgroundConfig.background.strokeOutset = -6
        backgroundConfig.background.strokeWidth = 5
        backgroundConfig.background.strokeColor = .colorBlack
        backgroundConfig.cornerStyle = .capsule
        if enable {
            btTakePhoto.isEnabled = true
            backgroundConfig.background.backgroundColor = .colorWhite
        } else {
            btTakePhoto.isEnabled = false
            backgroundConfig.background.backgroundColor = UIColor.colorDarkGray
        }
        btTakePhoto.configuration = backgroundConfig
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
            enableDisablePhotoButton(enable: true)
            Config.deletePhoto = 3
        }
        showImage(imageFilePath: urlString, bVideo: false)
    }
}
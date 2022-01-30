//
//  PhotoViewController.swift
//  qzela
//
//  Created by Edson Rocha on 19/12/21.
//

import UIKit
import AVFoundation

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

    var bPhoto = true
    var tpFlash = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.showPhoto))
        photoImage1.layer.borderWidth = 2
        photoImage1.layer.borderColor = UIColor.colorWhite.cgColor
        photoImage1.alpha = 0.75
        photoImage1.isUserInteractionEnabled = true
        photoImage1.addGestureRecognizer(tap1)

        photoImage2.layer.borderWidth = 2
        photoImage2.layer.borderColor = UIColor.colorWhite.cgColor
        photoImage2.alpha = 0.75
        photoImage2.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.showPhoto))
        photoImage2.addGestureRecognizer(tap2)

        photoImage3.layer.borderWidth = 2
        photoImage3.layer.borderColor = UIColor.colorWhite.cgColor
        photoImage3.alpha = 0.75
        photoImage3.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.showPhoto))
        photoImage3.addGestureRecognizer(tap3)

        btRecordVideo.visibility = .invisible
        btSave.setTitle("text_save".localized(), for: .normal)
        btContinue.setTitle("text_continue".localized(), for: .normal)


        view.layer.insertSublayer(previewLayer, at: 0)
        checkCameraPermissions()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        previewLayer.frame = view.bounds
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
                btSave.isEnabled = true
                btContinue.isEnabled = true
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
            print("btTakePhoto")
            let photoSettings = AVCapturePhotoSettings()
            if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]

                output.capturePhoto(with: photoSettings, delegate: self)
            }
        case "btSave":
            print("btSave")
        case "btContinue":
            print("btContinue")
       default:
            break
        }
    }

    private func checkCameraPermissions() {
        print(" ****** AVCaptureDevice Status: \(AVCaptureDevice.authorizationStatus(for: .video))")
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .denied:
            return
        case .restricted:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        @unknown default :
            break
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

            }
        }

    }
    @objc func showPhoto (_ sender: UITapGestureRecognizer) {
        print("SHOW PHOTO: \(String(describing: sender.view?.restorationIdentifier))")
    }


}

extension PhotoViewController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: data)
        session?.stopRunning()

        let  imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
}

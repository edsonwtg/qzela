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
    @IBOutlet weak var btSave: UIButton!
    @IBOutlet weak var btContinue: UIButton!
    
    
    
    // Capture Session
    var session: AVCaptureSession?

    // Photo Output
    let output = AVCapturePhotoOutput()
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()

    @IBAction func btBacktoTabBar(_ sender: Any) {
        tabBarController?.selectedIndex = 2
        dismiss(animated: true, completion: nil)
   }

    @IBAction func btTakePhoto(_ sender: Any) {
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]

            output.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImage1.layer.borderWidth = 2
        photoImage1.layer.borderColor = UIColor.colorWhite.cgColor
        photoImage1.alpha = 0.35
        photoImage2.layer.borderWidth = 2
        photoImage2.layer.borderColor = UIColor.colorWhite.cgColor
        photoImage2.alpha = 0.35
        photoImage3.layer.borderWidth = 2
        photoImage3.layer.borderColor = UIColor.colorWhite.cgColor
        photoImage3.alpha = 0.35



        view.layer.insertSublayer(previewLayer, at: 0)
        checkCameraPermissions()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        previewLayer.frame = view.bounds
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

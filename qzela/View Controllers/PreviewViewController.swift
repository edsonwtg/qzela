//
//  PreviewViewController.swift
//  qzela
//
//  Created by Edson Rocha on 20/11/21.
//

import UIKit
import AVKit

class PreviewViewController: UIViewController {

    // var to receive data from PhotoViewController
    var imageFilePath: String?
    var imagesFilesPath: [String]?
    var bUrl: Bool?
    var bShow: Bool?
    var bVideo: Bool?
    var bSaved = false
    var config = Config()
    var videoController = AVPlayerViewController()
    var player = AVPlayer()

    var imageShowNumber = 0

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var btDelete: UIButton!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
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

        if (imagesFilesPath?.count == 0 || bVideo == nil || bShow == nil || bUrl == nil) {
            dismiss(animated: true, completion: nil)
        }
        if (bShow!) {
            btDelete.visibility = .invisible
        }

        if (imagesFilesPath!.count == 1) {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            view.addGestureRecognizer(tap)
            leftImage.visibility = .invisible
            rightImage.visibility = .invisible
        } else {
            let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeImage))
            rightSwipeGesture.direction = .right
            view.addGestureRecognizer(rightSwipeGesture)
            let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeImage))
            leftSwipeGesture.direction = .left
            view.addGestureRecognizer(leftSwipeGesture)

            let rightTapGetsure = UITapGestureRecognizer(target: self, action: #selector(changeImage))
            rightImage.isUserInteractionEnabled = true
            rightImage.addGestureRecognizer(rightTapGetsure)

            let leftTapGetsure = UITapGestureRecognizer(target: self, action: #selector(self.changeImage))
            leftImage.isUserInteractionEnabled = true
            leftImage.addGestureRecognizer(leftTapGetsure)
        }

        if (bVideo!) {
            playVideo(videoFilePath: imagesFilesPath![imageShowNumber])
        } else {
            getAndShowImage(imageFilePath: imagesFilesPath![imageShowNumber])
        }
    }

    @objc func changeImage(_ sender: UITapGestureRecognizer) {

        if (sender.view?.restorationIdentifier == "rightImage") {
            if ((imagesFilesPath!.count-1) == imageShowNumber) {
                imageShowNumber = 0
                getAndShowImage(imageFilePath: imagesFilesPath![imageShowNumber])
            } else {
                imageShowNumber += 1
                getAndShowImage(imageFilePath: imagesFilesPath![imageShowNumber])
            }
        } else {
            if (imageShowNumber == 0) {
                imageShowNumber = (imagesFilesPath!.count-1)
                getAndShowImage(imageFilePath: imagesFilesPath![imageShowNumber],direction: "left")
            } else {
                imageShowNumber -= 1
                getAndShowImage(imageFilePath: imagesFilesPath![imageShowNumber],direction: "left")
            }
        }
    }

    @objc func swipeImage(gesture: UISwipeGestureRecognizer) {

        if (gesture.direction == .left) {
            if ((imagesFilesPath!.count-1) == imageShowNumber) {
                imageShowNumber = 0
                getAndShowImage(imageFilePath: imagesFilesPath![imageShowNumber],direction: "right")
            } else {
                imageShowNumber += 1
                getAndShowImage(imageFilePath: imagesFilesPath![imageShowNumber],direction: "right")
            }
        } else {
            if (imageShowNumber == 0) {
                imageShowNumber = (imagesFilesPath!.count-1)
                getAndShowImage(imageFilePath: imagesFilesPath![imageShowNumber],direction: "left")
            } else {
                imageShowNumber -= 1
                getAndShowImage(imageFilePath: imagesFilesPath![imageShowNumber],direction: "left")
            }
        }
    }

    func getAndShowImage(imageFilePath: String, direction: String = "right") {
        progressView.visibility = .invisible
        if (bUrl!) {
            var url: URL
            if (bSaved) {
                url = URL(fileURLWithPath: (imageFilePath))
            } else {
                url = URL(string: (imageFilePath))!
            }
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            if (direction == "left") {
                                UIView.transition(with: self!.imageView, duration: 1.0, options: .transitionFlipFromLeft, animations: {
                                    self!.imageView.image = image
                                }, completion: nil)
                            } else {
                                UIView.transition(with: self!.imageView, duration: 1.0, options: .transitionFlipFromRight, animations: {
                                    self!.imageView.image = image
                                }, completion: nil)
                            }
                        }
                    }
                }
            }
        } else {
            imageView.image = UIImage(contentsOfFile: (imagesFilesPath?.first)!)
        }

    }

    func playVideo(videoFilePath: String) {

        progressView.progress = 0.0
        if videoFilePath.contains("QZela_SAV") {
            player = AVPlayer(url: URL(fileURLWithPath: videoFilePath))
        } else {
            player = AVPlayer(url: URL(string: videoFilePath)!)
        }
        videoController.player = player
        videoController.showsPlaybackControls = false
        // print(player.currentTime().value)
        videoController.view.frame = videoView.bounds
        videoController.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoView.layer.addSublayer(videoController.view.layer)
        player.play()
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 2), queue: DispatchQueue.main) {[weak self] (progressTime) in
            if let duration = self?.player.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                let seconds = CMTimeGetSeconds(progressTime)
                self!.progressView.progress = Float(seconds)/Float(durationSeconds)
            }
        }
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        Config.deletePhoto = 0
        dismiss(animated: true, completion: nil)
    }

}

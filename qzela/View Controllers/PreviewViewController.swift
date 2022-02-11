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
    var urlImage: String?
    var config = Config()
    var videoController = AVPlayerViewController()
    var player = AVPlayer()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
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

        if urlImage == nil {
            dismiss(animated: true, completion: nil)
        }
        if (Config.deletePhoto < 4) {
            progressView.visibility = .invisible
            imageView.image = UIImage(contentsOfFile: urlImage!)
        } else {
            playVideo(videoFilePath: urlImage!)
        }
    }

    func playVideo(videoFilePath: String) {

        progressView.progress = 0.0
        player = AVPlayer(url: URL(string: videoFilePath)!)
        videoController.player = player
        videoController.showsPlaybackControls = false
        print(player.currentTime().value)
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
}

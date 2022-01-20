//
//  MyCollectionViewCell.swift
//  qzela
//
//  Created by Edson Rocha on 23/12/21.
//

import UIKit
import AVKit

class
IncidentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: IncidentCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideStatusLbl: UILabel!
    var image: UIImage!

    func setup(_ slide: IncidentImageSlide) {
        slideStatusLbl.text = slide.status

        slideStatusLbl.textColor = .colorWhite
        slideStatusLbl.font = UIFont.boldSystemFont(ofSize: 12.0)

        if slide.status == Config.SLIDE_OPEN {
            slideStatusLbl.text = "text_open".localized()
            slideStatusLbl.backgroundColor = .qzelaOrange
        }
        if slide.status == Config.SLIDE_REGISTERED {
            slideStatusLbl.text = "text_registered".localized()
            slideStatusLbl.backgroundColor = .colorBlue
        }
        if slide.status == Config.SLIDE_RESOLVED {
            slideStatusLbl.text = "text_resolved".localized()
            slideStatusLbl.backgroundColor = .colorGreen
        }

//        slideImageView.image = slide.image

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()

        let url = URL(string: slide.mediaURL)
        if (slide.tpImage == Config.TYPE_IMAGE_VIDEO) {
            getThumbnailImageFromVideoUrl(url: url!) { (thumbImage) in
                self.image = thumbImage
                dispatchGroup.leave()
            }
        } else {
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                self.image = UIImage(data: data!)!
                dispatchGroup.leave()
            }.resume()
        }

        dispatchGroup.notify(queue: .main) {

            self.slideImageView.image = self.image!
        }



    }

    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping (_ image: UIImage?)->Void) {
        DispatchQueue.global().async { //1
            let assetUrl = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: assetUrl) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
}

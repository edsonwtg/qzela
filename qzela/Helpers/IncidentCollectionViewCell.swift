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
    @IBOutlet weak var typeImageView: UIImageView!

    var image: UIImage!
    var typeImage: UIImage!
    let config = Config()

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

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()

        let url = URL(string: slide.mediaURL)
        if (slide.tpImage == Config.TYPE_IMAGE_VIDEO) {
            config.getThumbnailImageFromVideoUrl(url: url!) { (thumbImage) in
                guard let resImage = thumbImage else { return }
                self.image = resImage
                self.typeImage = UIImage(systemName: "play.circle")
                dispatchGroup.leave()
            }
        } else {
            URLSession.shared.dataTask(with: url!) { (data, response, error) in

                print( error as Any )
//                print(response as Any)
                guard let resImage = data else {
                    return }
                self.image = UIImage(data: resImage)
                self.typeImage = UIImage(systemName: "camera.circle")
                dispatchGroup.leave()
            }.resume()
        }

        dispatchGroup.notify(queue: .main) {
            self.slideImageView.image = self.image!
            self.typeImageView.image = self.typeImage
            self.config.stopLoadingData()
        }



    }
}

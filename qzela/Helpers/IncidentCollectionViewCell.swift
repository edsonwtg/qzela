//
//  MyCollectionViewCell.swift
//  qzela
//
//  Created by Edson Rocha on 23/12/21.
//

import UIKit

class
IncidentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: IncidentCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideStatusLbl: UILabel!
    
    func setup(_ slide: IncidentImageSlide) {
        slideImageView.image = slide.image
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
    }
    
}

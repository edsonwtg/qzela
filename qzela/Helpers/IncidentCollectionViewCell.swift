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
    
    func setup(_ slide: IncidentSlide) {
        slideImageView.image = slide.image
        slideStatusLbl.text = slide.status
//        slideImageView.layer.cornerRadius=50.0
        if slide.status == "Open" {
            slideStatusLbl.backgroundColor = .orange
        }
        if slide.status == "Registered" {
            slideStatusLbl.backgroundColor = .blue
        }
        if slide.status == "Resolved" {
            slideStatusLbl.backgroundColor = .green
        }
    }
    
}

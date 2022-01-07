//
//  OccurrenceCollectionViewCell.swift
//  qzela
//
//  Created by Edson Rocha on 07/01/22.
//

import UIKit

class OccurrenceCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OccurrenceCollectionViewCell.self)

    @IBOutlet weak var tagLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tagLabel.textColor = .white
        tagLabel.backgroundColor = .qzelaDarkBlue
        tagLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        self.layer.borderColor = UIColor.qzelaDarkBlue.cgColor
        self.layer.borderWidth = 1
        self.cornerRadius = tagLabel.frame.size.height / 2.0
        self.backgroundColor = .qzelaDarkBlue
    }
}

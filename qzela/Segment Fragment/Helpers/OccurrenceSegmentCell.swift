//
//  OccurrenceSegmentCell.swift
//  qzela
//
//  Created by Edson Rocha on 07/01/22.
//

import UIKit

class OccurrenceSegmentCell: UICollectionViewCell {
    
    static let identifier = String(describing: OccurrenceSegmentCell.self)

    var occurrenceId: String!
    @IBOutlet weak var occurrenceLabel: UILabel!

    func setOccurrences(_ data: OccurrencesData) {
        occurrenceLabel.text = data.occurrenceName
        occurrenceId = data.occurrenceId

        occurrenceLabel.textColor = .white
        occurrenceLabel.backgroundColor = .qzelaDarkBlue
        occurrenceLabel.font = UIFont.boldSystemFont(ofSize: 12.0)

        self.layer.borderColor = UIColor.qzelaDarkBlue.cgColor
        self.layer.borderWidth = 1
        self.cornerRadius = occurrenceLabel.frame.size.height / 2.0
        self.backgroundColor = .qzelaDarkBlue
    }
}

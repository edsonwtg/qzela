 //
//  SegmentsCell.swift
//  qzela
//
//  Created by Edson Rocha on 17/02/22.
//

import UIKit

class SegmentCell: UICollectionViewCell {
    
    static let identifier = String(describing: SegmentCell.self)

    var segmentId: Int!

    @IBOutlet weak var segmentImage: UIImageView!
    @IBOutlet weak var segmentLabel: UILabel!

    func setSegments(_ data: SegmentData) {
        segmentId = data.segmentId
        segmentImage.image = UIImage(named: data.segmentImage)
        segmentLabel.text = data.segmentName
    }
}


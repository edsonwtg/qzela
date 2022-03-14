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
        segmentLabel.text = data.segmentName
        getFirebaseSegmentImage(segmentId: data.segmentId)
    }

    func getFirebaseSegmentImage(segmentId: Int) {
        let dispatchGroup = DispatchGroup()
        var image: UIImage!
        dispatchGroup.enter()
        // Get Segment Marker Icon by FIREBASE on Google Cloud
        let imagesRef = Config.FIREBASE_ICONS_STORAGE.child(Config.SEGMENTS_ICONS_PATH + (String(segmentId)) + ".png")
        // Download in memory with size 160 bytes a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imagesRef.getData(maxSize: Config.MAXBYTES) { markerIcon, error in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                // Segment Icon
                image =  UIImage(data: markerIcon!)
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            // display images on the image view
            self.segmentImage.image = image
        }
    }
}


//
//  IncidentTableViewCell.swift
//  qzela
//
//  Created by Edson Rocha on 30/03/22.
//

import UIKit

class IncidentTableViewCell: UITableViewCell {

    let config = Config()

    @IBOutlet weak var segmentLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!

    func setIncidents(section: Int, _ data: IncidentData) {

        if (data.ActionName == Config.STATUS_SAVED) {
            segmentLabel.text = "Image(s) saved on:"
            actionLabel.visibility = .invisible
        } else {
            actionLabel.visibility = .visible
            segmentLabel.text = data.SegmentName
            if data.ActionName == Config.STATUS_OPEN {
                actionLabel.text = "text_open".localized()
                actionLabel.backgroundColor = .qzelaOrange
            }
            if data.ActionName == Config.STATUS_REGISTERED {
                actionLabel.text = "text_registered".localized()
                actionLabel.backgroundColor = .colorBlue
            }
            if data.ActionName == Config.STATUS_RESOLVED {
                actionLabel.text = "text_resolved".localized()
                actionLabel.backgroundColor = .colorGreen
            }
            actionLabel.textColor = .colorWhite
            actionLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        }
        dateLabel.text = data.IncidentDate

        if (data.typeImage == Config.TYPE_IMAGE_PHOTO) {
            ImageView.image = getImages(status: data.ActionName, urlString: data.IncidentImage)
        } else {
            ImageView.image = UIImage(systemName: "play.rectangle.fill")
            ImageView.layer.borderWidth = 2
            ImageView.layer.borderColor = UIColor.colorGray.cgColor
            ImageView.backgroundColor = UIColor.qzelaOrange
            ImageView.tintColor = UIColor.colorWhite
        }
    }

    func getImages(status: String, urlString: String) -> UIImage {
        var url = NSURL()
        if (status == Config.STATUS_SAVED) {
            url = NSURL(fileURLWithPath: urlString)
        } else {
            url = NSURL(string: urlString)!
        }
        let data = NSData(contentsOf: (url as URL))
        return UIImage(data: data! as Data)!
    }
}

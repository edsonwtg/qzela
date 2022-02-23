//
//  LocationViewController.swift
//  qzela
//
//  Created by Edson Rocha on 23/02/22.
//

import UIKit

class LocationViewController: UIViewController {

    // var to receive data from SegmentViewController
    var segmentId: Int!
    var occurrencesItem: [String] = []

    let fileManager = FileManager.default

    @IBAction func btBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("SegmentId: \(segmentId!)")
        print("OccurrencesIds: \(occurrencesItem)")
        Config.saveIncidentPosition = 0
        if (Config.SAVED_INCIDENT) {
            let incidentImages = Config.saveIncidents[Config.saveIncidentPosition]
            print("Saved Latitude: \(incidentImages.latitude)")
            print("Saved Longitude: \(incidentImages.latitude)")
            print("Saved Image type: \(incidentImages.imageType)")
            for imageSave in incidentImages.savedImages {
                print("Saved Image: \(Config.PATH_SAVED_FILES+"/"+imageSave.fileImage)")
            }
        } else {
            print("Coordinates Latitude: \(Config.savCoordinate.latitude)")
            print("Coordinates Longitude: \(Config.savCoordinate.latitude)")
            print("Image Type: \(Config.IMAGE_CAPTURED)")
            do {
                let items = try fileManager.contentsOfDirectory(atPath: Config.PATH_TEMP_FILES)
                for item in items {
                    print("Found \(Config.PATH_TEMP_FILES + "/" + item)")
                }
            } catch {
                print("Error File Path \(Config.PATH_TEMP_FILES)")
            }
        }
    }
}

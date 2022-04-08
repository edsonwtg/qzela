//
// Created by Edson Rocha on 21/02/22.
//

import UIKit

struct IncidentsSection {
    let name : String
    var items: [IncidentData]
}

struct IncidentData {
    let IncidentId: String
    let SegmentName: String
    let ActionName: String
    let IncidentDate: String
    let IncidentImage: [String]
    let typeImage: String

}


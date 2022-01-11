//
//  DialogIncidentViewController.swift
//  qzela
//
//  Created by Edson Rocha on 20/12/21.
//

import UIKit

class DialogIncidentViewController: UIViewController {

    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblSegment: UILabel!
    @IBOutlet weak var lblOpenDate: UILabel!
    @IBOutlet weak var stackViewForwarded: UIStackView!
    @IBOutlet weak var lblForwardedDate: UILabel!
    @IBOutlet weak var lblResolvedDate: UILabel!
    @IBOutlet weak var imageForwarded: UIImageView!
    @IBOutlet weak var imageResolved: UIImageView!
    @IBOutlet weak var pbStepIncident: UIProgressView!
    
    @IBOutlet weak var occurrenceCollectionView: UICollectionView!
    
    @IBOutlet weak var stackViewProtocol: UIStackView!
    @IBOutlet weak var lblHeadProtocol: UILabel!
    @IBOutlet weak var lblProtocol: EdgeInsetLabel!
    @IBOutlet weak var lblHeadAddress: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblHeadComments: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var btFeedback: UIButton!
    @IBOutlet weak var stackViewButtons: UIStackView!
    @IBOutlet weak var btLike: UIButton!
    @IBOutlet weak var btDisLike: UIButton!
    @IBOutlet weak var btSolver: UIButton!
    
    var slides: [IncidentImageSlide] =  []
    var selected = [String]()
    var OccurenceTag: [String] = []

    // var to receive data from MapTabbarController
    var incidentId: String?
    
    // Block rotate iPhone
    override var shouldAutorotate: Bool {
        false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackViewForwarded.visibility = .invisible
        stackViewProtocol.visibility = .invisible
        btFeedback.visibility = .invisible
        
        btLike.configuration?.baseForegroundColor = UIColor.qzelaDarkBlue
        btLike.configuration?.background.strokeColor = UIColor.qzelaDarkBlue

        btDisLike.configuration?.baseForegroundColor = UIColor.colorRed
        btDisLike.configuration?.background.strokeColor = UIColor.colorRed

        btSolver.configuration?.baseForegroundColor = UIColor.colorGreen
        btSolver.configuration?.background.strokeColor = UIColor.colorGreen

//        btDisLike.isEnabled = false
//        btDisLike.configuration?.background.strokeColor = UIColor.lightGray
        
        imageResolved.tintColor = UIColor.systemGray3
        pbStepIncident.setProgress(0.0, animated: true)

        if incidentId != nil {
            print("Incident ID: \(incidentId!)")
        }
        
        slides = [
            IncidentImageSlide(image: UIImage(named: "img_open_0-1")!, status: "Open"),
            IncidentImageSlide(image: UIImage(named: "img_open_1-1")!, status: "Open"),
            IncidentImageSlide(image: UIImage(named: "img_open_2")!, status: "Resolved"),
            IncidentImageSlide(image: UIImage(named: "img_open_0")!, status: "Registered"),
            IncidentImageSlide(image: UIImage(named: "map")!, status: "Open")
        ]
        
        OccurenceTag = [
            "America",
            "Bangladesh Bangladesh",
            "China",
            "Denmark",
            "Egypt",
            "Finland Finland",
            "Germany 123",
            "Holand",
            "Italy",
            "Japan"
            ]
        
        pageControl.numberOfPages = slides.count

    }

    @IBAction func btnClick(_ sender: UIButton) {

        switch sender.restorationIdentifier {
        case "btClose":
            print("btClose")
            dismiss(animated: true, completion: nil)
        case "btLike":
            print("btLike")
        case "btDisLike":
            print("btDislike")
        case "btSolver":
            print("btSolver")
        case "btFeedback":
            print("btFeedback")
        default:
            print("Default")
        }
    }
    
}
    
extension DialogIncidentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.sliderCollectionView {
            return slides.count
        } else {
            return OccurenceTag[section].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.sliderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IncidentCollectionViewCell.identifier, for: indexPath) as! IncidentCollectionViewCell
            
            cell.setup(slides[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OccurrenceCollectionViewCell.identifier, for: indexPath) as! OccurrenceCollectionViewCell
            
            cell.tagLabel.text = OccurenceTag[indexPath.row]

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.sliderCollectionView {
            print(indexPath.row)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
       let index = scrollView.contentOffset.x / witdh
       let roundedIndex = round(index)
       self.pageControl.currentPage = Int(roundedIndex)
   }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
}

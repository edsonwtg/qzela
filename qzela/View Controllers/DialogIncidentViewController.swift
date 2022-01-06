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
    @IBOutlet weak var lblOpenDate: EdgeInsetLabel!
    @IBOutlet weak var lblForwardedDate: EdgeInsetLabel!
    @IBOutlet weak var lblResolvedDate: EdgeInsetLabel!
    @IBOutlet weak var imageForwarded: UIImageView!
    @IBOutlet weak var imageResolved: UIImageView!
    @IBOutlet weak var pbStepIncident: UIProgressView!
    
    var slides: [IncidentSlide] =  []

    // var to receive data from MapTabbarController
    var incidentId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        lblForwardedDate.isHidden = true
        imageForwarded.isHidden = true
        imageResolved.tintColor = UIColor.systemGray3
        pbStepIncident.setProgress(0.0, animated: true)

        if incidentId != nil {
            print("Incident ID: \(incidentId!)")
        }
        
        slides = [
            IncidentSlide(image: UIImage(named: "img_open_0-1")!, status: "Open"),
            IncidentSlide(image: UIImage(named: "img_open_1-1")!, status: "Open"),
            IncidentSlide(image: UIImage(named: "img_open_2")!, status: "Resolved"),
            IncidentSlide(image: UIImage(named: "img_open_0")!, status: "Registered"),
            IncidentSlide(image: UIImage(named: "map")!, status: "Open")
        ]
        pageControl.numberOfPages = slides.count

    }

    @IBAction func btClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
    
extension DialogIncidentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IncidentCollectionViewCell.identifier, for: indexPath) as! IncidentCollectionViewCell
        
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
       let index = scrollView.contentOffset.x / witdh
       let roundedIndex = round(index)
       self.pageControl.currentPage = Int(roundedIndex)
   }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
}

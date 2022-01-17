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
    var occurrenceTag: [String] = []

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
        lblHeadAddress.text = "text_location".localized()
        lblHeadComments.text = "text_comments".localized()
        btSolver.setTitle("text_solver".localized(), for: .normal)

        // Close
//        incidentId = "60af7a23c972406df17bb914"
        // Registrada
//        incidentId = "61550de6d5d5405478b24827"
        if incidentId != nil {
            print("Incident ID: \(incidentId!)")
        }

        print("******** GetIncidentById - START **********")

        Apollo.shared.apollo.fetch(query: GetIncidentByIdQuery(id: incidentId!)) { [unowned self] result in
            switch result {
            case .success(let graphQLResult):
//                print("Success! Result: \(graphQLResult)")
                if let result = graphQLResult.data?.getIncidentById {
                    var indexPaths: [IndexPath] = []
                    var mediasUrls : [String] = []

                    for medias in result.mediaUrls! {
                        mediasUrls.append(medias)
                    }
                    downloadImagesUrl(mediasUrl: mediasUrls, incidentStatus: result.stIncident)
//                    indexPaths = [IndexPath(item: slides.count - 1, section: 0)]
//                    sliderCollectionView.performBatchUpdates({ () -> Void in
//                        sliderCollectionView.insertItems(at: indexPaths)
//                    }, completion: nil)
                    lblSegment.text = result.segments[0].dcSegment
                    for occurrences in result.segments {
                        occurrenceTag.append(occurrences.dcOccurrence)
                    }
                    indexPaths = [IndexPath(item: occurrenceTag.count - 1, section: 0)]
                    occurrenceCollectionView.performBatchUpdates({ () -> Void in
                        occurrenceCollectionView.insertItems(at: indexPaths)
                    }, completion: nil)

                    lblOpenDate.text = "text_open".localized()+"\n"+result.dtOpen.formatted(date: .numeric, time: .omitted)
                    lblAddress.text = "\(result.dcAddress), \(result.nrAddress ?? "") - \(result.dcNeighborhood)"
                    lblComments.text = result.txComment

                    switch (result.stIncident) {
                    case 1:
                        lblProtocol.text = result._id
                        pbStepIncident.setProgress(1, animated: true)
                        imageResolved.tintColor = UIColor.qzelaOrange
                        lblResolvedDate.text = "text_resolved".localized()+"\n"+result.dtClose!.formatted(date: .numeric, time: .omitted)
                        break;
                    case 3:
                        lblProtocol.text = result._id
                        pbStepIncident.setProgress(0.5, animated: true)
                        lblForwardedDate.text = "text_forwarded".localized()+"\n"+result.updatedAt.formatted(date: .numeric, time: .omitted)
                        stackViewForwarded.visibility = .visible
                        break;
                    case 4:
                        lblProtocol.text = result._id
                        pbStepIncident.setProgress(1, animated: true)
                        imageResolved.tintColor = UIColor.qzelaOrange
                        imageResolved.tintColor = UIColor.qzelaOrange
                        lblResolvedDate.text = "text_resolved".localized()+"\n"+result.dtClose!.formatted(date: .numeric, time: .omitted)
                        lblForwardedDate.text = "text_forwarded".localized()+"\n"+result.updatedAt.formatted(date: .numeric, time: .omitted)
                        stackViewForwarded.visibility = .visible
                        break;
                    case 7:
                        lblProtocol.text = result._id
                        pbStepIncident.setProgress(1, animated: true)
                        imageResolved.tintColor = UIColor.qzelaOrange
                        lblResolvedDate.text = "text_resolved".localized()+"\n"+result.dtOpen.formatted(date: .numeric, time: .omitted)
                        break;
                    default:
                        lblProtocol.text = result._id
                        pbStepIncident.setProgress(0, animated: true)
                    }

                    print("_id \(result._id)")
                    print("cdSegment \(result.cdSegment)")
                    print("dcAddress \(result.dcAddress)")

                    print("******** GetViewport - END **********")
                } else {
                    print("******** Stop Loading **********")
                }
            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        }
        print("******** GetIncidentById - END **********")

        pageControl.numberOfPages = slides.count

    }

    @IBAction func btnClick(_ sender: UIButton) {

        switch sender.restorationIdentifier {
        case "btClose":
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

    func downloadImagesUrl(mediasUrl: [String], incidentStatus: Int) {
        let dispatchGroup = DispatchGroup()

        for imageURL in mediasUrl {

            if (imageURL.contains(Config.IMAGE_MAP)) {
                continue
            }

            dispatchGroup.enter()
            let url = URL(string: imageURL)
            URLSession.shared.dataTask(with: url!) {  (data, response, error) in

                if (imageURL.contains(Config.IMAGE_OPEN)) {
                    if (incidentStatus == Config.INCIDENT_STATUS_REGISTERED) {
                        self.slides.append(IncidentImageSlide(image: UIImage(data: data!)!, status: Config.SLIDE_REGISTERED))
                    } else {
                        self.slides.append(IncidentImageSlide(image: UIImage(data: data!)!, status: Config.SLIDE_OPEN))
                    }
                } else {
                    if (incidentStatus == Config.INCIDENT_STATUS_REGISTERED) {
                        self.slides.append(IncidentImageSlide(image: UIImage(data: data!)!, status: Config.SLIDE_REGISTERED))
                    } else {
                        self.slides.append(IncidentImageSlide(image: UIImage(data: data!)!, status: Config.SLIDE_RESOLVED))
                    }
                }
                // save image data somewhere
                dispatchGroup.leave()
            }.resume()
        }

        dispatchGroup.notify(queue: .main) {

            self.pageControl.numberOfPages = self.slides.count
            let indexPaths: [IndexPath] = [IndexPath(item: self.slides.count - 1, section: 0)]
            self.sliderCollectionView.performBatchUpdates({ () -> Void in
                self.sliderCollectionView.insertItems(at: indexPaths)
            }, completion: nil)
        }
    }
    
}
    
extension DialogIncidentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.sliderCollectionView {
            return slides.count
        } else {
            return occurrenceTag.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.sliderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IncidentCollectionViewCell.identifier, for: indexPath) as! IncidentCollectionViewCell
            
            cell.setup(slides[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OccurrenceCollectionViewCell.identifier, for: indexPath) as! OccurrenceCollectionViewCell
            
            cell.tagLabel.text = occurrenceTag[indexPath.row]

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

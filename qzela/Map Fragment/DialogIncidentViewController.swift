//
//  DialogIncidentViewController.swift
//  qzela
//
//  Created by Edson Rocha on 20/12/21.
//

import UIKit
import AVKit

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
    @IBOutlet weak var lblProtocol: UILabel!
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

//    let newVideoView = AVPlayerViewController()

    let config = Config()

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

        config.startLoadingData(view: view, color: .qzelaDarkBlue)

        // Close
//        incidentId = "60af7a23c972406df17bb914"
        // Registrada
//        incidentId = "61550de6d5d5405478b24827"
//        if incidentId != nil {
//            print("Incident ID: \(incidentId!)")
//        }
//        incidentId = "5e20f78900bc760835481f76"
        if (incidentId == "615c9648eac9e627dc101325") {
            // Video
            incidentId = "6154e3c5d5d5405478b24820"
        }
        // print("******** GetIncidentById - START **********")


        Apollo.shared.apollo.fetch(query: GetIncidentByIdQuery(id: incidentId!)) { [unowned self] result in
            switch result {
            case .success(let graphQLResult):
//                print("Success! Result: \(graphQLResult)")
                if let result = graphQLResult.data?.getIncidentById {
                    var indexPaths: [IndexPath] = []

                    for medias in result.mediaUrls! {
                        if (medias.contains(Config.IMAGE_MAP)) { continue}
                        if (medias.contains(Config.IMAGE_OPEN)) {
                            if (result.stIncident == Config.INCIDENT_STATUS_REGISTERED) {
                                slides.append(IncidentImageSlide(status: Config.SLIDE_REGISTERED, tpImage: result.tpImage, mediaURL: medias))
                            } else {
                                slides.append(IncidentImageSlide(status: Config.SLIDE_OPEN, tpImage: result.tpImage, mediaURL: medias))
                            }
                        } else {
                            if (result.stIncident == Config.INCIDENT_STATUS_REGISTERED) {
                                slides.append(IncidentImageSlide(status: Config.SLIDE_REGISTERED, tpImage: result.tpImage, mediaURL: medias))
                            } else {
                                slides.append(IncidentImageSlide(status: Config.SLIDE_RESOLVED, tpImage: result.tpImage, mediaURL: medias))
                            }
                        }
                    }
                    pageControl.numberOfPages = slides.count
                    indexPaths = [IndexPath(item: slides.count - 1, section: 0)]
                    sliderCollectionView.performBatchUpdates({ () -> Void in
                        sliderCollectionView.insertItems(at: indexPaths)
                    }, completion: nil)

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
                    
                    // print("_id \(result._id)")
                    // print("cdSegment \(result.cdSegment)")
                    // print("dcAddress \(result.dcAddress)")

                    // print("******** GetViewport - END **********")
                } else if let errors = graphQLResult.errors{
                    print("******** ERROR Loading DATA**********")
                    print(errors)
                    config.stopLoadingData()
                    dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                config.stopLoadingData()
                print("Failure! Error: \(error)")
                dismiss(animated: true, completion: nil)
            }
        }
        
        // print("******** GetIncidentById - END **********")
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
            break
        }
    }

    func showImage(imageFilePath: String, bVideo: Bool) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        // pass data to view controller
        controller.imageFilePath = imageFilePath
        controller.bUrl = true
        controller.bShow = true
        controller.bVideo = bVideo
        present(controller, animated: true)
    }


//    func showPhoto (photoFilePath: String) {
//        let url = URL(string: photoFilePath)
//        URLSession.shared.dataTask(with: url!) { (data, response, error) in
//            DispatchQueue.main.async {
//                let newImageView = UIImageView(image: UIImage(data: data!)!)
//                newImageView.frame = UIScreen.main.bounds
//                newImageView.backgroundColor = UIColor.colorBlack
//                newImageView.contentMode = UIView.ContentMode.scaleAspectFit
//                newImageView.isUserInteractionEnabled = true
//                let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
//                newImageView.addGestureRecognizer(tap)
//                self.view.addSubview(newImageView)
//                self.navigationController?.isNavigationBarHidden = true
//                self.tabBarController?.tabBar.isHidden = true
//            }
//        }.resume()
//    }

//    func playVideo (videoFilePath: String) {
//
//        let player = AVPlayer(url: URL(string: videoFilePath)!)
//
//        NotificationCenter.default.addObserver(self,
//                selector: #selector(DialogIncidentViewController.didStartplaying(notification:)),
//                name: .AVPlayerItemNewAccessLogEntry,
//                object: player.currentItem)
//
//        newVideoView.player = player
//        newVideoView.showsPlaybackControls = false
//        newVideoView.view.frame = UIScreen.main.bounds
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
//        newVideoView.view.addGestureRecognizer(tap)
//        addChild(newVideoView)
//        view.addSubview(newVideoView.view)
//        config.startLoadingData(view: view, color: .qzelaDarkBlue)
//        newVideoView.player?.play()
//        navigationController?.isNavigationBarHidden = true
//        tabBarController?.tabBar.isHidden = true
//    }

//    @objc func didStartplaying(notification : NSNotification)
//    {
//        if let _ = notification.object as? AVPlayerItem {
//            config.stopLoadingData()
//        }
//    }

//    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
//        navigationController?.isNavigationBarHidden = false
//        tabBarController?.tabBar.isHidden = false
//        sender.view?.removeFromSuperview()
//    }
}
    
extension DialogIncidentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == sliderCollectionView {
            return slides.count
        } else {
            return occurrenceTag.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == sliderCollectionView {
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
        if collectionView == sliderCollectionView {
            // print(indexPath.row)

            if (slides[indexPath.row].tpImage == Config.TYPE_IMAGE_VIDEO) {
//                playVideo(videoFilePath: slides[indexPath.row].mediaURL)
                showImage(imageFilePath: slides[indexPath.row].mediaURL, bVideo: true)
            } else {
//                showPhoto(photoFilePath: slides[indexPath.row].mediaURL )
                showImage(imageFilePath: slides[indexPath.row].mediaURL, bVideo: false)
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
       let index = scrollView.contentOffset.x / witdh
       let roundedIndex = round(index)
       pageControl.currentPage = Int(roundedIndex)
   }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
}

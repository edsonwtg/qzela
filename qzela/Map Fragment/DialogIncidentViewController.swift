//
//  DialogIncidentViewController.swift
//  qzela
//
//  Created by Edson Rocha on 20/12/21.
//

import UIKit
import AVKit

class DialogIncidentViewController: UIViewController {

    var slides: [IncidentImageSlide] =  []
    var occurrenceTag: [String] = []

    let config = Config()
    let gpsLocation = qzela.GPSLocation()
    let networkListener = NetworkListener()

    // var to receive data from MapTabbarController
    var incidentId: String?
    var imageFiles: [String] = []
    var imageType: String!

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
    @IBOutlet weak var btSolver: UIButton!

    // Block rotate iPhone
    override var shouldAutorotate: Bool {
        false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        stackViewForwarded.visibility = .invisible
        stackViewProtocol.visibility = .invisible

        btLike.configuration?.baseForegroundColor = UIColor.qzelaDarkBlue
        btLike.configuration?.background.strokeColor = UIColor.qzelaDarkBlue

        btSolver.configuration?.baseForegroundColor = UIColor.colorGreen
        btSolver.configuration?.background.strokeColor = UIColor.colorGreen

        btLike.visibility = .invisible
        btSolver.visibility = .invisible
        btFeedback.visibility = .invisible

        imageResolved.tintColor = UIColor.systemGray3
        pbStepIncident.setProgress(0.0, animated: true)
        lblHeadAddress.text = "text_location".localized()
        lblHeadComments.text = "text_comments".localized()
        btSolver.setTitle("text_resolve".localized(), for: .normal)

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

        getIncident()

    }

    @IBAction func btnClick(_ sender: UIButton) {

        switch sender.restorationIdentifier {
        case "btClose":
            dismiss(animated: true, completion: nil)
        case "btLike":
            print("btLike")
        case "btSolver":
            print("btSolver")
            if (Config.SAVED_INCIDENT) {
                let send = SendIncident()
                let incidentImages = Config.saveIncidents[Config.saveIncidentPosition]
                imageType = incidentImages.imageType
                for imageSave in incidentImages.savedImages {
                    imageFiles.append(Config.PATH_SAVED_FILES + "/" + imageSave.fileImage)
                }
                send.sendCloseIncident(view: self,
                        incidentId: incidentId!,
                        citizenId: Config.SAV_CD_USUARIO,
                        imageFiles: imageFiles,
                        imageType: imageType
                ) { [self] result in
                    // Data send to SPI
                    if (result) {
                        // Delete files saved.
                        qzela.Config.saveQtdIncidents -= 1
                        for imageSave in Config.saveIncidents[Config.saveIncidentPosition].savedImages {
                            let fileManager = FileManager.default
                            let fileDelete = Config.PATH_SAVED_FILES + "/" + imageSave.fileImage
                            self.config.deleteImage(fileManager: fileManager, pathFileFrom: fileDelete)
                        }
                        // Save user defaults
                        Config.saveIncidents.remove(at: Config.saveIncidentPosition)
                        let data = try! JSONEncoder().encode(Config.saveIncidents)
                        Config.userDefaults.set(data, forKey: "incidentSaved")
                        Config.userDefaults.set(Config.saveQtdIncidents, forKey: "qtdIncidentSaved")
                        Config.saveIncidentPosition = -1
                        Config.SAVED_INCIDENT = false
                        Config.backIncidentSend = true
                        Config.backSavedDashboard = true
//                        let tabBarController = self.view.window?.windowScene?.keyWindow?.rootViewController as! UITabBarController
//                        tabBarController.selectedIndex = Config.MENU_ITEM_DASHBOARD
//                        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                        self.tabBarController!.selectedIndex = Config.MENU_ITEM_DASHBOARD
                    } else {
                        self.showAlert(title: "text_service_out".localized(),
                                message: "text_service_unavailable".localized(),
                                type: .attention,
                                actionTitles: ["text_got_it".localized()],
                                style: [.default],
                                actions: [nil]
                        )
                    }
                }
            } else {
                // check Internet
                if (!networkListener.isNetworkAvailable()) {
                    showAlert(title: "text_no_internet".localized(),
                            message: "text_internet_off".localized(),
                            type: .attention,
                            actionTitles: ["text_got_it".localized()],
                            style: [.default],
                            actions: [nil]
                    )
                } else {
                    // check GPS
                    if (gpsLocation.isGpsEnable()) {
                        // check camera permission
                        if (config.checkCameraPermissions()) {
                            Config.savCoordinate = gpsLocation.getCoordinate()
                            Config.CLOSE_INCIDENT = true
                            Config.SAV_CLOSE_INCIDENT_ID = incidentId!
                            // Go to Photo View Controller
                            let controller = storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
                            controller.modalPresentationStyle = .fullScreen
                            controller.modalTransitionStyle = .crossDissolve
                            present(controller, animated: true)
                        } else {
                            let actionHandler: (UIAlertAction) -> Void = { (action) in
                                //Redirect to Settings app
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            }
                            showAlert(title: "text_no_camera_permission".localized(),
                                    message: "text_camera_never_permission".localized(),
                                    type: .error,
                                    actionTitles: ["text_settings".localized(), "text_cancel".localized()],
                                    style: [.default, .cancel],
                                    actions: [actionHandler, nil]
                            )
                        }
                    } else {
                        let actionHandler: (UIAlertAction) -> Void = { (action) in
                            //Redirect to Settings app
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                        showAlert(title: "text_no_gps_permission".localized(),
                                message: "text_gps_never_permission".localized(),
                                type: .error,
                                actionTitles: ["text_settings".localized(), "text_cancel".localized()],
                                style: [.default, .cancel],
                                actions: [actionHandler, nil]
                        )
                    }
                }
            }
        case "btFeedback":
            print("btFeedback")
        default:
            break
        }
    }

    func getIncident() {

        ApolloIOS.shared.apollo.fetch(query: GetIncidentByIdQuery(id: incidentId!), cachePolicy: .fetchIgnoringCacheData) { [unowned self] result in
            switch result {
            case .success(let graphQLResult):
//                print("Success! Result: \(graphQLResult)")
                if let result = graphQLResult.data?.getIncidentById {
                    var indexPaths: [IndexPath] = []
                    if (Config.SAVED_INCIDENT) {
                        btSolver.visibility = .visible
                    }else {
                        // For Close incident
                        Config.SAV_CLOSE_TP_IMAGE = result.tpImage
                        // *******
                        switch result.stIncident {
                        case 0,2:
                            if (result._idOpenCitizen != Config.SAV_CD_USUARIO) {
                                btLike.visibility = .visible
                            }
                            btSolver.visibility = .visible
                            break
                        case 1,4:
                            if !(result.closureConfirms.contains(Config.SAV_CD_USUARIO)) {
                                btFeedback.visibility = .visible
                            }
                        default: break
                        }
                    }
                    for medias in result.mediaUrls! {
                        if (medias.contains(Config.IMAGE_MAP)) { continue}
                        if (Config.ARRAY_INCIDENT_ALL_STATUS_OPEN.contains(result.stIncident)) {
                            getDirectory(filePath: medias)
                        }
                        if (medias.contains(Config.IMAGE_OPEN)) {
                            if (result.stIncident == Config.INCIDENT_STATUS_REGISTERED) {
                                slides.append(IncidentImageSlide(status: Config.STATUS_REGISTERED, tpImage: result.tpImage, mediaURL: medias))
                            } else {
                                slides.append(IncidentImageSlide(status: Config.STATUS_OPEN, tpImage: result.tpImage, mediaURL: medias))
                            }
                        } else {
                            if (result.stIncident == Config.INCIDENT_STATUS_REGISTERED) {
                                slides.append(IncidentImageSlide(status: Config.STATUS_REGISTERED, tpImage: result.tpImage, mediaURL: medias))
                            } else {
                                slides.append(IncidentImageSlide(status: Config.STATUS_RESOLVED, tpImage: result.tpImage, mediaURL: medias))
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
                    if (errors.first?.message == "1 - You must supply a valid token to access this resource!") {
                        print("******** LOGIN AGAIN **********")
                        let login  = Login()
                        login.getLogin(
                                email: Config.SAV_DC_EMAIL,
                                password: Config.SAV_DC_SENHA,
                                notificationId: Config.SAV_NOTIFICATION_ID
                        ){ [self] result in
                            if !(login.getMessage() == "Login Ok") {
                                self.showAlert(title: "text_warning".localized(),
                                        message: login.getMessage().localized(),
                                        type: .attention,
                                        actionTitles: ["text_got_it".localized()],
                                        style: [.default],
                                        actions: [nil]
                                )
                                return
                            } else {
                                Config.SAV_ACCESS_TOKEN = login.getAccessToken()
                                Config.SAV_CD_USUARIO = login.getUserId()
                                Config.userDefaults.set(Config.SAV_ACCESS_TOKEN, forKey: "accessToken")
                                Config.userDefaults.set(Config.SAV_CD_USUARIO, forKey: "cdUser")
                                getIncident()
                            }
                        }
                    }
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

    func getDirectory(filePath: String) {

        // Caminhos dos arquivos de images na Google Storage
        // "https://firebasestorage.googleapis.com/v0/b/qz-user-data/o/videos/prd/2020/6/5/open/2020-06-05T14:30:31.970Z-8/video.mp4?alt=media&token=b81d29e8-fb70-49ee-8545-c7df80f6cd68"
        // "https://firebasestorage.googleapis.com/v0/b/westars-qzela.appspot.com/o/videos/prd/2020/9/1/2020-09-01T10:32:26.105Z-4/video_open.mp4?alt=media&token=e3c56d77-e8dc-4e68-a160-999e409ce879"
        // "https://firebasestorage.googleapis.com:443/v0/b/qz-user-data/o/images/stg/2022/04/06/2022-04-06T13:09:20/vid_open_0.jpg?alt=media&token=5cb1b296-99f8-4746-b25d-b90516672a7a"
        // "https://firebasestorage.googleapis.com:443/v0/b/qz-user-data/o/images/stg/2022/04/11/2022-04-11T17:03:15/img_open_0.jpg?alt=media&token=e84ebdff-a405-415c-ae3a-5ffb30035f92"
        // "https://storage.googleapis.com/qz-user-data/legacy/5d4dd2fc8101561e3bf47168/open_img_1.jpg"
        // "https://firebasestorage.googleapis.com/v0/b/qz-user-data/o/images/prd/2020/8/7/open/2020-08-07T14:33:08.966Z-3/img_0?alt=media&token=325db349-2a7b-4d2c-afaf-2cbacf753450"
        // "https://storage.googleapis.com/qz-user-data/legacy/5f04a970497deb2df56b4ef1/open_img_0.jpg"

        let urlDecode = filePath.removingPercentEncoding!
        print(urlDecode)
        var startIndex: String.Index!
        var subStrEnd: String!
        if (urlDecode.contains(Config.FIREBASE_INCIDENTS_BUCKET)) {
            Config.SAV_CLOSE_BUCKET = Config.FIREBASE_INCIDENTS_BUCKET
        } else {
            Config.SAV_CLOSE_BUCKET = Config.FIREBASE_INCIDENTS_BUCKET_LEGACY
        }
        startIndex = urlDecode.range(of: Config.SAV_CLOSE_BUCKET+"/")?.lowerBound
        if (urlDecode.contains("/video.")) {
            subStrEnd = "/video."
        } else if (urlDecode.contains("/video_")) {
            subStrEnd = "/video_"
        } else if (urlDecode.contains("/vid_open")) {
            subStrEnd = "/vid_open"
        } else if (urlDecode.contains("/img_open")) {
            subStrEnd = "/img_open"
        } else if (urlDecode.contains("/open_img")) {
            subStrEnd = "/open_img"
        } else if (urlDecode.contains("/img_0")) {
            subStrEnd = "/img_0"
        } else {
            print("ERROR: Not find subStrEnd : \(urlDecode)")
            return
        }
        let endIndex = urlDecode.range(of: subStrEnd)?.lowerBound
        Config.SAV_CLOSE_IMAGE_DIRECTORY = String(urlDecode[startIndex!..<endIndex!])
        print("urlDecode: ", String(urlDecode[startIndex!..<endIndex!]))
        if (Config.SAV_CLOSE_IMAGE_DIRECTORY.contains("/o/")) {
            Config.SAV_CLOSE_IMAGE_DIRECTORY = Config.SAV_CLOSE_IMAGE_DIRECTORY.replacingOccurrences(of: Config.SAV_CLOSE_BUCKET+"/o/", with: "")
        } else {
            Config.SAV_CLOSE_IMAGE_DIRECTORY = Config.SAV_CLOSE_IMAGE_DIRECTORY.replacingOccurrences(of: Config.SAV_CLOSE_BUCKET+"/", with: "")
        }
        print("Bucket: ", Config.SAV_CLOSE_BUCKET)
        print("Directory: ", Config.SAV_CLOSE_IMAGE_DIRECTORY)

    }

    func showImage(imageFilePath: [String], bVideo: Bool, imageNumber: Int) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        // pass data to view controller
        controller.imagesFilesPath = imageFilePath
        controller.bUrl = true
        controller.bShow = true
        controller.bVideo = bVideo
        controller.imageShowNumber = imageNumber
        present(controller, animated: true)
    }
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
            var imagesFilePath: [String] = []
            for i in 0..<slides.count {
                imagesFilePath.append(slides[i].mediaURL)
            }

            if (slides[indexPath.row].tpImage == Config.TYPE_IMAGE_VIDEO) {
//                playVideo(videoFilePath: slides[indexPath.row].mediaURL)
                showImage(imageFilePath: imagesFilePath, bVideo: true, imageNumber: (indexPath.row))
            } else {
//                showPhoto(photoFilePath: slides[indexPath.row].mediaURL )
                showImage(imageFilePath: imagesFilePath, bVideo: false, imageNumber: (indexPath.row))
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

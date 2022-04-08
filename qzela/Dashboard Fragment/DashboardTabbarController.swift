//
//  DashboardTabbarController.swift
//  qzela
//
//  Created by Edson Rocha on 28/03/22.
//

import UIKit
import MapKit

class DashboardTabbarController: UIViewController {

    var incidentData = [IncidentData]()
    var incidentSection = [IncidentsSection]()
    var mediasUrl = Array<String>()

    let config = Config()
    let networkListener = NetworkListener()

    @IBOutlet weak var openStackView: UIStackView!
    @IBOutlet weak var closeStackView: UIStackView!
    @IBOutlet weak var interStackView: UIStackView!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var interLabel: UILabel!
    @IBOutlet weak var openPointsLabel: UILabel!
    @IBOutlet weak var closePointsLabel: UILabel!
    @IBOutlet weak var interPointsLabel: UILabel!

    @IBOutlet weak var qzelasStackView: UIStackView!
    @IBOutlet weak var eventsStackView: UIStackView!
    @IBOutlet weak var totQzelasLabel: UILabel!
    @IBOutlet weak var totEventsLabel: UILabel!
    @IBOutlet weak var totQzelasPointsLabel: UILabel!
    @IBOutlet weak var totEventsPointsLabel: UILabel!

    @IBOutlet weak var lastActionsLabel: UILabel!
    
    @IBOutlet weak var actionOpenIcon: UIImageView!
    @IBOutlet weak var actionOpenLabel: UILabel!
    @IBOutlet weak var actionOpenLine: UIView!
    
    @IBOutlet weak var actionResolvedIcon: UIImageView!
    @IBOutlet weak var actionResolvedLabel: UILabel!
    @IBOutlet weak var actionResolvedLine: UIView!

    @IBOutlet weak var actionConfirmIcon: UIImageView!
    @IBOutlet weak var actionConfirmLabel: UILabel!
    @IBOutlet weak var actionConfirmLine: UIView!
    
    @IBOutlet weak var incidentTableView: UITableView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // print("***** DashboardTabbarController viewDidAppear *****")
        if (Config.backIncidentDashboard) {
            Config.backIncidentDashboard = false
            getCitizen()
        }
        if (Config.backSavedDashboard) {
            Config.backSavedDashboard = false
            getSavedIncidentes()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        incidentTableView.delegate = self
        incidentTableView.dataSource = self

        openStackView.layer.borderWidth = 2
        openStackView.layer.cornerRadius = 12
        openStackView.layer.borderColor = UIColor.lightGray.cgColor
        openStackView.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        openStackView.isLayoutMarginsRelativeArrangement = true
        openLabel.text = "text_openings".localized()
        actionOpenLine.backgroundColor = UIColor.qzelaOrange
        closeStackView.layer.borderWidth = 2
        closeStackView.layer.cornerRadius = 12
        closeStackView.layer.borderColor = UIColor.lightGray.cgColor
        closeStackView.layer.borderColor = UIColor.lightGray.cgColor
        closeStackView.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        closeStackView.isLayoutMarginsRelativeArrangement = true
        closeLabel.text = "text_closures".localized()
        actionResolvedLine.backgroundColor = UIColor.qzelaOrange

        interStackView.layer.borderWidth = 2
        interStackView.layer.cornerRadius = 12
        interStackView.layer.borderColor = UIColor.lightGray.cgColor
        interStackView.layer.borderColor = UIColor.lightGray.cgColor
        interStackView.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        interStackView.isLayoutMarginsRelativeArrangement = true
        interLabel.text = "text_interactions".localized()
        actionConfirmLine.backgroundColor = UIColor.qzelaOrange

        qzelasStackView.layer.borderWidth = 2
        qzelasStackView.layer.cornerRadius = 12
        qzelasStackView.layer.borderColor = UIColor.lightGray.cgColor
        qzelasStackView.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        qzelasStackView.isLayoutMarginsRelativeArrangement = true
        totQzelasLabel.text = "text_tot_qzelas".localized()

        eventsStackView.layer.borderWidth = 2
        eventsStackView.layer.cornerRadius = 12
        eventsStackView.layer.borderColor = UIColor.lightGray.cgColor
        eventsStackView.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        eventsStackView.isLayoutMarginsRelativeArrangement = true
        totEventsLabel.text = "text_tot_events".localized()

        lastActionsLabel.text = "text_last_actions".localized()

        actionOpenLabel.text = "text_openings".localized()
        actionOpenLabel.visibility = .visible
        actionOpenLine.visibility = .visible

        actionResolvedLabel.text = "text_resolved".localized()
        actionResolvedLabel.visibility = .invisible
        actionResolvedLine.visibility = .invisible
        actionConfirmLabel.text = "text_confirmed".localized()
        actionConfirmLabel.visibility = .invisible
        actionConfirmLine.visibility = .invisible

        let tapActionOpen = UITapGestureRecognizer(target: self, action: #selector(tapGestureImage))
        actionOpenIcon.isUserInteractionEnabled = true
        actionOpenIcon.addGestureRecognizer(tapActionOpen)

        let tapActionResolved = UITapGestureRecognizer(target: self, action: #selector(tapGestureImage))
        actionResolvedIcon.isUserInteractionEnabled = true
        actionResolvedIcon.addGestureRecognizer(tapActionResolved)

        let tapActionConfirm = UITapGestureRecognizer(target: self, action: #selector(tapGestureImage))
        actionConfirmIcon.isUserInteractionEnabled = true
        actionConfirmIcon.addGestureRecognizer(tapActionConfirm)

        getSavedIncidentes()
        getCitizen()
    }

    @objc func tapGestureImage (_ sender: UITapGestureRecognizer) {

        guard let section = incidentSection.firstIndex(where: {$0.name == "My Incidents"}) else {
            return
        }
        incidentSection.remove(at: section)
        incidentTableView.deleteSections(IndexSet(integer: section), with: .automatic)
        switch sender.view?.restorationIdentifier {
        case "actionOpenIcon":
            actionOpenLabel.visibility = .visible
            actionOpenLine.visibility = .visible
            actionResolvedLabel.visibility = .invisible
            actionResolvedLine.visibility = .invisible
            actionConfirmLabel.visibility = .invisible
            actionConfirmLine.visibility = .invisible
            getIncidents(incidentType: IncidentType.open)
        case "actionResolvedIcon":
            actionOpenLabel.visibility = .invisible
            actionOpenLine.visibility = .invisible
            actionResolvedLabel.visibility = .visible
            actionResolvedLine.visibility = .visible
            actionConfirmLabel.visibility = .invisible
            actionConfirmLine.visibility = .invisible
            getIncidents(incidentType: IncidentType.closeregistered)
        case "actionConfirmIcon":
            actionOpenLabel.visibility = .invisible
            actionOpenLine.visibility = .invisible
            actionResolvedLabel.visibility = .invisible
            actionResolvedLine.visibility = .invisible
            actionConfirmLabel.visibility = .visible
            actionConfirmLine.visibility = .visible
            getIncidents(incidentType: IncidentType.interaction)
        default:
            break
        }
    }

    func getCitizen() {
        if (!networkListener.isNetworkAvailable()) {
            // print("******** NO INTERNET CONNECTION *********")
            let actionHandler: (UIAlertAction) -> Void = { (action) in

            }
            showAlert(title: "text_no_internet".localized(),
                    message: "text_internet_off".localized(),
                    type: .attention,
                    actionTitles: ["text_got_it".localized()],
                    style: [.default],
                    actions: [actionHandler])
        }
        config.startLoadingData(view: view, color: .qzelaDarkBlue,centerPosition: -200)
        print("****** GETCITIZEN *******")
        ApolloIOS.shared.apollo.fetch(query: GetCitizenByIdQuery(id: Config.SAV_CD_USUARIO), cachePolicy: .fetchIgnoringCacheData) { [unowned self] result in
            switch result {
            case .success(let graphQLResult):
                print("Success! Result: \(graphQLResult)")
                if let result = graphQLResult.data?.getCitizenById {
                    openPointsLabel.text = String(result.qtOpen)
                    closePointsLabel.text = String(result.qtClose)
                    interPointsLabel.text = String(result.qtInteraction)
                    totQzelasPointsLabel.text = String(result.qtQZelas)
                    let subscribedEvents = result.subscribedEvents
                    var totEvents = 0
                    if (subscribedEvents?.count ?? 0 > 0) {
                        for events in subscribedEvents! {
                            totEvents += events!.totalQtEarnedEvents
                        }
                    }
                    totEventsPointsLabel.text = String(totEvents)
                    config.stopLoadingData()
                    actionOpenLabel.visibility = .visible
                    actionOpenLine.visibility = .visible
                    actionResolvedLabel.visibility = .invisible
                    actionResolvedLine.visibility = .invisible
                    actionConfirmLabel.visibility = .invisible
                    actionConfirmLine.visibility = .invisible
                    getIncidents(incidentType: IncidentType.open)
                    // print("******** GetCitizen - END **********")
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
                                showAlert(title: "text_warning".localized(),
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
                                getCitizen()
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

    func getSavedIncidentes() {
        print("****** GETSAVEDINCIDENTS *******")
        var section: Int!
        if (incidentTableView.numberOfSections > 0) {
            section = incidentSection.firstIndex(where: { $0.name == "Saved Incidents" })
            if (section != nil) {
                incidentSection.remove(at: section)
            }
        }
        if (Config.saveQtdIncidents > 0) {
            incidentData.removeAll()
            for incident in Config.saveIncidents {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: Config.CURRENT_LANGUAGE)
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                mediasUrl.removeAll()
                for medias in incident.savedImages {
                    mediasUrl.append(Config.PATH_SAVED_FILES+"/"+medias.fileImage)
                }
                incidentData.append(IncidentData(
                        IncidentId: String(incident.id),
                        SegmentName: "",
                        ActionName: Config.STATUS_SAVED,
                        IncidentDate: dateFormatter.string(from: incident.dateTime),
                        IncidentImage: mediasUrl,
                        typeImage: incident.imageType
                ))
            }
            incidentSection.insert(IncidentsSection(name: "Saved Incidents", items: incidentData), at: 0)
            if (section != nil) {
                incidentTableView.reloadSections(IndexSet(integer: section), with: .automatic)
            } else {
                incidentTableView.reloadData()
            }
        }
        print("****** END GETSAVEDINCIDENTS *******")
    }

    func getIncidents(incidentType: IncidentType) {
        print("****** GETCINCIDENTS *******")
        config.startLoadingData(view: view, color: .qzelaDarkBlue,centerPosition: -200)
        var section: Int!
        if (incidentTableView.numberOfSections > 0) {
            section = incidentSection.firstIndex(where: { $0.name == "My Incidents" })
            if (section != nil) {
                incidentSection.remove(at: section)
            }
        }
        incidentData.removeAll()
        ApolloIOS.shared.apollo.fetch(query: GetIncidentByCitizenDashboardQuery(
                citizenId: Config.SAV_CD_USUARIO,
                tpIncident: incidentType), cachePolicy: .fetchIgnoringCacheData) { [unowned self] result in
            switch result {
            case .success(let graphQLResult):
                print("Success! Result: \(graphQLResult)")
                if let result = graphQLResult.data?.getIncidentsByCitizenId.data {
                    for incident in result {
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: Config.CURRENT_LANGUAGE)
                        dateFormatter.dateStyle = .short
                        mediasUrl.removeAll()
                        for medias in incident.mediaUrls! {
                            if (medias.contains(Config.IMAGE_MAP)) { continue}
                            mediasUrl.append(medias)
                        }
                        var action: String!
                        switch (incident.stIncident) {
                        case 0, 2:
                            action = "text_open".localized()
                            break;
                        case 1, 4:
                            action = "text_resolved".localized()
                            break;
                        case 5, 6:
                            action = "text_interaction".localized()
                           break;
                        case 7:
                            action = "text_registered".localized()
                            break;
                        default:
                            break
                        }
                        let imageType: String!
                        if (mediasUrl.first!.contains("img_")) {
                            imageType = Config.TYPE_IMAGE_PHOTO
                        } else {
                            imageType = Config.TYPE_IMAGE_VIDEO
                        }
                        incidentData.append(IncidentData(
                                IncidentId: incident._id,
                                SegmentName: incident.segments[0].dcSegment,
                                ActionName: action,
                                IncidentDate: dateFormatter.string(from: incident.dtDate!),
                                IncidentImage: mediasUrl,
                                typeImage: imageType
                        ))
                    }
                    incidentSection.append(IncidentsSection(name: "My Incidents", items: incidentData))
                    if (section != nil) {
                        incidentTableView.reloadSections(IndexSet(integer: section), with: .automatic)
                    } else {
                        incidentTableView.reloadData()
                    }
                    config.stopLoadingData()
                    // print("******** GetCitizen - END **********")
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
                                showAlert(title: "text_warning".localized(),
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
                                getCitizen()
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
        print("****** END GETCINCIDENTS *******")
    }
}

extension DashboardTabbarController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        incidentSection.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        incidentSection[section].items.count
   }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if (incidentSection[section].name == "My Incidents") {
            if (actionOpenLabel.visibility == .visible) {
                return "text_my_incidents".localized() + " " + "text_openings".localized()
            } else if (actionResolvedLabel.visibility == .visible) {
                return "text_my_incidents".localized() + " " + "text_resolved".localized()
            } else {
                return "text_my_incidents".localized() + " " + "text_confirmed".localized()
            }
        } else {
            return "text_saved_incidents".localized()
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.qzelaDarkBlue
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.colorWhite
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = incidentTableView.dequeueReusableCell(withIdentifier: "IncidentCell") as! IncidentTableViewCell

        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.colorGray.cgColor
        cell.layer.cornerRadius = 15
        cell.separatorInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        DispatchQueue.main.async {
            cell.setIncidents(section: indexPath.section, self.incidentSection[indexPath.section].items[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let solverAction = UIContextualAction(style: .normal, title: "text_solver".localized(), handler: { (action, view, success) in
            print("Solver")
            if (!self.networkListener.isNetworkAvailable()) {
                // print("******** NO INTERNET CONNECTION *********")
                let actionHandler: (UIAlertAction) -> Void = { (action) in }
                self.showAlert(title: "text_no_internet".localized(),
                        message: "text_internet_off".localized(),
                        type: .attention,
                        actionTitles: ["text_got_it".localized()],
                        style: [.default],
                        actions: [actionHandler])
            } else {
                let actionHandler: (UIAlertAction) -> Void = { (action) in
                    Config.SAVED_INCIDENT = true
                    Config.saveIncidentPosition = indexPath.row
                    Config.savCoordinate = CLLocationCoordinate2D(
                            latitude: Config.saveIncidents[indexPath.row].latitude,
                            longitude: Config.saveIncidents[indexPath.row].longitude)
                    // Go to Map View Controller
                    self.tabBarController!.selectedIndex = Config.MENU_ITEM_MAP
                }
                self.showAlert(title: "text_solver_incident".localized(),
                        message: "text_solver_saved".localized(),
                        type: .attention,
                        actionTitles: ["text_cancel".localized(), "text_continue".localized()],
                        style: [.cancel, .destructive],
                        actions: [nil, actionHandler]
                )
            }
            success(true)
        })
        solverAction.image = UIImage(systemName: "checkmark.circle.trianglebadge.exclamationmark")
        solverAction.backgroundColor = UIColor.colorGreen

        let newAction = UIContextualAction(style: .destructive, title: "text_new".localized(), handler: { (action, view, success) in
            print("New")
            if (!self.networkListener.isNetworkAvailable()) {
                // print("******** NO INTERNET CONNECTION *********")
                let actionHandler: (UIAlertAction) -> Void = { (action) in }
                self.showAlert(title: "text_no_internet".localized(),
                        message: "text_internet_off".localized(),
                        type: .attention,
                        actionTitles: ["text_got_it".localized()],
                        style: [.default],
                        actions: [actionHandler])
            } else {
                let actionHandler: (UIAlertAction) -> Void = { (action) in
                    Config.SAVED_INCIDENT = true
                    Config.saveIncidentPosition = indexPath.row
                    // Go to Segment View Controller
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "SegmentViewController") as! SegmentViewController
                    controller.modalPresentationStyle = .fullScreen
                    controller.modalTransitionStyle = .crossDissolve
                    self.present(controller, animated: true)
                }
                self.showAlert(title: "text_new_incident".localized(),
                        message: "text_new_saved".localized(),
                        type: .attention,
                        actionTitles: ["text_cancel".localized(), "text_continue".localized()],
                        style: [.cancel, .destructive],
                        actions: [nil, actionHandler]
                )
            }
            success(true)
        })
//        newAction.image = UIImage(systemName: "square.and.arrow.up.trianglebadge.exclamationmark")
        newAction.image = UIImage(systemName: "square.and.arrow.up.trianglebadge.exclamationmark")
        newAction.backgroundColor = UIColor.qzelaOrange

        let viewAction = UIContextualAction(style: .normal, title: "text_view".localized(), handler: { (action, view, success) in
            print("View")
            var bSaved = false
            if (self.incidentSection[indexPath.section].items[indexPath.row].ActionName == "Saved") {
                bSaved = true
            }
            if (self.incidentSection[indexPath.section].items[indexPath.row].typeImage == Config.TYPE_IMAGE_VIDEO) {
                self.showImage(imageFilePath: self.incidentSection[indexPath.section].items[indexPath.row].IncidentImage, bVideo: true, bSaved: bSaved)
            } else {
                self.showImage(imageFilePath: self.incidentSection[indexPath.section].items[indexPath.row].IncidentImage, bVideo: false, bSaved: bSaved)
            }
            success(true)
        })
        viewAction.image = UIImage(systemName: "eye")
        viewAction.backgroundColor = UIColor.qzelaDarkBlue

        let deleteAction = UIContextualAction(style: .normal, title: "text_delete".localized(), handler: { (action, view, success) in
            print("Delete")

            let okActionCancel: (UIAlertAction) -> Void = { (action) in
                success(true)
            }
            let okActionHandler: (UIAlertAction) -> Void = {(action) in
                // Delete files saved.
                qzela.Config.saveQtdIncidents -= 1
                for imageSave in Config.saveIncidents[indexPath.row].savedImages {
                    let fileManager = FileManager.default
                    let fileDelete = Config.PATH_SAVED_FILES+"/"+imageSave.fileImage
                    self.config.deleteImage(fileManager: fileManager, pathFileFrom: fileDelete)
                }
                // Save user defaults
                Config.saveIncidents.remove(at: indexPath.row)
                let data = try! JSONEncoder().encode(Config.saveIncidents)
                Config.userDefaults.set(data, forKey: "incidentSaved")
                Config.userDefaults.set(Config.saveQtdIncidents, forKey: "qtdIncidentSaved")
                // Remove cell
                self.incidentSection[indexPath.section].items.remove(at: indexPath.row)
                self.incidentTableView.deleteRows(at: [indexPath], with: .automatic)
                if (self.incidentSection[indexPath.section].items.count == 0) {
                    self.incidentSection.remove(at: indexPath.section)
                    self.incidentTableView.reloadData()
//            } else {
//                self.incidentTableView.reloadSections(IndexSet(integer: indexPath.section as Int), with: .automatic)
                }
            }
            self.showAlert(
                    title: "text_attention".localized(),
                    message: "text_delete_incident".localized(),
                    type: .attention,
                    actionTitles: ["text_cancel".localized(), "text_confirm".localized()],
                    style: [.cancel, .destructive],
                    actions: [okActionCancel, okActionHandler]
            )
        })
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = UIColor.colorRed

        var configuration = UISwipeActionsConfiguration()
        if (incidentSection[indexPath.section].items[indexPath.row].ActionName == Config.STATUS_SAVED) {
            configuration = UISwipeActionsConfiguration(actions: [deleteAction, viewAction, newAction, solverAction])
        } else {
            configuration = UISwipeActionsConfiguration(actions: [viewAction])
        }
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    func showImage(imageFilePath: [String], bVideo: Bool, bSaved: Bool) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        // pass data to view controller
        controller.imagesFilesPath = imageFilePath
        controller.bUrl = true
        controller.bShow = true
        controller.bVideo = bVideo
        controller.bSaved = bSaved
        present(controller, animated: true)
    }

}

//
//  DashboardTabbarController.swift
//  qzela
//
//  Created by Edson Rocha on 28/03/22.
//

import UIKit

class DashboardTabbarController: UIViewController {

    var incidentData = [IncidentData]()
    var incidentSection = [IncidentsSection]()

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
        closeStackView.layer.borderWidth = 2
        closeStackView.layer.cornerRadius = 12
        closeStackView.layer.borderColor = UIColor.lightGray.cgColor
        closeStackView.layer.borderColor = UIColor.lightGray.cgColor
        closeStackView.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        closeStackView.isLayoutMarginsRelativeArrangement = true
        closeLabel.text = "text_closures".localized()

        interStackView.layer.borderWidth = 2
        interStackView.layer.cornerRadius = 12
        interStackView.layer.borderColor = UIColor.lightGray.cgColor
        interStackView.layer.borderColor = UIColor.lightGray.cgColor
        interStackView.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        interStackView.isLayoutMarginsRelativeArrangement = true
        interLabel.text = "text_interactions".localized()

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
    }

    @objc func tapGestureImage (_ sender: UITapGestureRecognizer) {

        switch sender.view?.restorationIdentifier {
        case "actionOpenIcon":
            actionOpenLabel.visibility = .visible
            actionOpenLine.visibility = .visible
            actionResolvedLabel.visibility = .invisible
            actionResolvedLine.visibility = .invisible
            actionConfirmLabel.visibility = .invisible
            actionConfirmLine.visibility = .invisible
        case "actionResolvedIcon":
            actionOpenLabel.visibility = .invisible
            actionOpenLine.visibility = .invisible
            actionResolvedLabel.visibility = .visible
            actionResolvedLine.visibility = .visible
            actionConfirmLabel.visibility = .invisible
            actionConfirmLine.visibility = .invisible
        case "actionConfirmIcon":
            actionOpenLabel.visibility = .invisible
            actionOpenLine.visibility = .invisible
            actionResolvedLabel.visibility = .invisible
            actionResolvedLine.visibility = .invisible
            actionConfirmLabel.visibility = .visible
            actionConfirmLine.visibility = .visible
        default:
            break
        }
    }

    func getSavedIncidentes() {
        incidentSection.removeAll()
        incidentData.removeAll()
        incidentData.append(IncidentData(
                IncidentId: "Saved 1",
                SegmentName: "#EuCuidoDoMeuQuadrado",
                ActionName: Config.STATUS_OPEN,
                IncidentDate: "3/30/22 10:22",
                IncidentImage: "https://storage.googleapis.com/qz-user-data/images/stg/2021/10/8/20211008110135-0300/img_open_0.jpg",
                typeImage: Config.TYPE_IMAGE_PHOTO
        ))
        incidentData.append(IncidentData(
                IncidentId: "Saved 2",
                SegmentName: "Árvore",
                ActionName: Config.STATUS_RESOLVED,
                IncidentDate: "12/5/21 23:00",
                IncidentImage: "https://storage.googleapis.com/qz-user-data/images/stg/2021/10/8/20211008110135-0300/img_open_0.jpg",
                typeImage: Config.TYPE_IMAGE_PHOTO
        ))
        incidentSection.append(IncidentsSection(name: "Saved Incidents", items: incidentData))
        getIncidents()
    }

    func getIncidents() {

        incidentData.removeAll()
        incidentData.append(IncidentData(
                IncidentId: "Incident 1",
                SegmentName: "Rede de Telecomunicações",
                ActionName: Config.STATUS_REGISTERED,
                IncidentDate: "12/30/21",
                IncidentImage: "https://storage.googleapis.com/qz-user-data/images/stg/2021/10/8/20211008110135-0300/img_open_0.jpg",
                typeImage: Config.TYPE_IMAGE_PHOTO
        ))
        incidentData.append(IncidentData(
                IncidentId: "Incident 2",
                SegmentName: "Estradas",
                ActionName: Config.STATUS_OPEN,
                IncidentDate: "12/30/21",
                IncidentImage: "https://storage.googleapis.com/qz-user-data/images/stg/2021/10/8/20211008110135-0300/img_open_0.jpg",
                typeImage: Config.TYPE_IMAGE_PHOTO
        ))
        incidentData.append(IncidentData(
                IncidentId: "Incident 3",
                SegmentName: "Animais",
                ActionName: Config.STATUS_RESOLVED,
                IncidentDate: "12/30/21",
                IncidentImage: "https://storage.googleapis.com/qz-user-data/images/stg/2021/10/8/20211008110135-0300/img_open_0.jpg",
                typeImage: Config.TYPE_IMAGE_PHOTO
        ))
        incidentSection.append(IncidentsSection(name: "My Incidents", items: incidentData))
        incidentTableView.reloadData()
    }

    func gotoNewRootViewController(viewController: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: viewController)
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }
    func gotoViewControllerWithBack(viewController: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: viewController)
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.modalTransitionStyle = .flipHorizontal
        self.present(nextViewController, animated:true)
    }
}

extension DashboardTabbarController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return incidentSection.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incidentSection[section].items.count ?? 0
   }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.incidentSection[section].name
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.qzelaDarkBlue
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.colorWhite
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = incidentTableView.dequeueReusableCell(withIdentifier: "IncidentCell") as! IncidentTableViewCell

        cell.setIncidents(section: indexPath.section, incidentSection[indexPath.section].items[indexPath.row])
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.colorGray.cgColor
        cell.layer.cornerRadius = 15
        cell.separatorInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let solverAction = UIContextualAction(style: .normal, title: "text_solver".localized(), handler: { (action, view, success) in
            print(self.incidentData[indexPath.row].SegmentName)
        })
        solverAction.image = UIImage(systemName: "checkmark.circle.trianglebadge.exclamationmark")
        solverAction.backgroundColor = UIColor.colorGreen

        let newAction = UIContextualAction(style: .destructive, title: "text_new".localized(), handler: { (action, view, success) in
            print("New")
        })
//        newAction.image = UIImage(systemName: "square.and.arrow.up.trianglebadge.exclamationmark")
        newAction.image = UIImage(systemName: "square.and.arrow.up.trianglebadge.exclamationmark")
        newAction.backgroundColor = UIColor.qzelaOrange

        let viewAction = UIContextualAction(style: .normal, title: "text_view".localized(), handler: { (action, view, success) in
            print("View: \(self.incidentData[indexPath.row].IncidentId)")
            self.incidentTableView.reloadRows(at: [indexPath], with: .automatic)
        })
        viewAction.image = UIImage(systemName: "eye")
        viewAction.backgroundColor = UIColor.qzelaDarkBlue

        let deleteAction = UIContextualAction(style: .normal, title: "text_delete".localized(), handler: { (action, view, success) in
            print("Delete")
            self.incidentData.remove(at: indexPath.row)
            self.incidentTableView.deleteRows(at: [indexPath], with: .automatic)
        })
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = UIColor.colorRed

        var configuration = UISwipeActionsConfiguration()
        if (indexPath.section == 0) {
            configuration = UISwipeActionsConfiguration(actions: [deleteAction, viewAction, newAction, solverAction])
        } else {
            configuration = UISwipeActionsConfiguration(actions: [viewAction])
        }
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

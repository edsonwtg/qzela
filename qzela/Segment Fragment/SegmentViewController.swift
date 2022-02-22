//
//  SegmentViewController.swift
//  qzela
//
//  Created by Edson Rocha on 16/02/22.
//

import UIKit
import Apollo

class SegmentViewController: UIViewController {

    var segmentSelect: IndexPath!
    var segmentScrollSelect: Int = -1
    var segmentScroll: Int = 0
    var occurrenceSelect: IndexPath!
    var occurrenceScrollSelect: Int = -1
    var occurrenceScroll: Int = 0
    var segmentsItens: [SegmentData] = []
    var occurrenceItens: [OccurrencesData] = []

    var networkListener = NetworkListener()
    var config = Config()

    @IBOutlet weak var searchSegment: UITextField!
    @IBOutlet weak var segmentCollectionView: UICollectionView!
    @IBOutlet weak var occurrenceSegmentCollectionView: UICollectionView!
    @IBOutlet weak var commentaryTextField: UITextField!
    @IBOutlet weak var btContinue: UIButton!

    @IBAction func btBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchSegment.layer.borderWidth = 2
        searchSegment.layer.cornerRadius = 12

        let iconImageView = UIImageView()
        let iconImage = UIImage(systemName: "magnifyingglass")!
        iconImageView.tintColor = .colorBlack
        iconImageView.image = iconImage
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: 30, height: iconImage.size.height)
        iconImageView.frame = CGRect(x: 5, y: 0, width: iconImage.size.width, height: iconImage.size.height)
        contentView.addSubview(iconImageView)
        searchSegment.leftView = contentView
        searchSegment.leftViewMode = .always
        searchSegment.isEnabled = false

        commentaryTextField.layer.borderWidth = 2
        commentaryTextField.layer.cornerRadius = 12
        commentaryTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: commentaryTextField.frame.height))
        commentaryTextField.leftViewMode = .always

        segmentCollectionView.allowsMultipleSelection = false
        occurrenceSegmentCollectionView.allowsMultipleSelection = true

        btContinue.isEnabled = false

        setSegmentsCollection()
    }

    @IBAction func btContinue(_ sender: Any) {

        // print("btContinue")
        if (!networkListener.isNetworkAvailable()) {
            // print("******** NO INTERNET CONNECTION *********")
        }
        // Go to Location View Controller
//        let controller = storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
//        controller.modalPresentationStyle = .fullScreen
//        controller.modalTransitionStyle = .crossDissolve
//        present(controller, animated: true)
    }

    func setSegmentsCollection () {

        // print("******** GetSegment - START **********")
        Apollo.shared.apollo.fetch(query: GetSegmentsQuery(), cachePolicy: .fetchIgnoringCacheData) { [unowned self] result in
            switch result {
            case .success(let graphQLResult):
//                print("Success! Result: \(graphQLResult)")
                if let result = graphQLResult.data?.getSegments{
                    for segments in result {
                        segmentsItens.append(SegmentData(
                                segmentId: segments.cdSegment,
                                segmentName: segments.dcSegment,
                                segmentImage: "42")
                        )
                    }
                    let indexPaths = [IndexPath(item: segmentsItens.count - 1, section: 0)]
                    segmentCollectionView.performBatchUpdates({ () -> Void in
                        segmentCollectionView.insertItems(at: indexPaths)
                    }, completion: nil)

                    // print("******** GetSegment - END **********")
                } else {
                    // print("******** Stop Loading **********")
                }
            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        }
        // print("******** GetSegment - END **********")

//        segmentsItens.append(SegmentData(segmentId: 1, segmentName: "#EuCuidoDoMeuQuadrado", segmentImage: "42"))
//        segmentsItens.append(SegmentData(segmentId: 2, segmentName: "Calçadas e Canteiros", segmentImage: "42"))
//        segmentsItens.append(SegmentData(segmentId: 3, segmentName: "Animais Domésticos", segmentImage: "42"))
//        segmentsItens.append(SegmentData(segmentId: 4, segmentName: "Bicicletário", segmentImage: "42"))
//
//        let indexPaths = [IndexPath(item: segmentsItens.count - 1, section: 0)]
//        segmentCollectionView.performBatchUpdates({ () -> Void in
//            segmentCollectionView.insertItems(at: indexPaths)
//        }, completion: nil)

    }

    func setOccurrencesCollection (occurrenceId: Int) {

        // check Internet
        if (!networkListener.isNetworkAvailable()) {
            // print("******** NO INTERNET CONNECTION *********")
            showAlert(title: "text_no_internet".localized(),
                    message: "text_internet_off".localized(),
                    type: .attention,
                    actionTitles: ["text_got_it".localized()],
                    style: [.default],
                    actions: [nil])
            return
        }
        occurrenceItens.removeAll()

        // print("******** GetOccurrences - START **********")

        Apollo.shared.apollo.fetch(query: GetOccurrencesQuery(segId: occurrenceId), cachePolicy: .fetchIgnoringCacheData) { [unowned self] result in
            switch result {
            case .success(let graphQLResult):
//                print("Success! Result: \(graphQLResult)")
                if let result = graphQLResult.data?.getOccurrencesBySegmentCode {
                    for resOccurrences in result {
                        occurrenceItens.append(OccurrencesData(occurrenceId: resOccurrences._id,
                                occurrenceName: resOccurrences.dcOccurrence))
                    }
                    let indexPaths = [IndexPath(item: occurrenceItens.count - 1, section: 0)]
                    occurrenceSegmentCollectionView.performBatchUpdates({ () -> Void in
                        occurrenceSegmentCollectionView.insertItems(at: indexPaths)
                    }, completion: nil)

                    // print("******** getOccurrences - END **********")
                } else {
                    // print("******** Stop Loading **********")
                }
            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        }
        // print("******** getOccurrences - END **********")

//        if occurrenceId == 1 {
//            occurrenceItens.append(OccurrencesData(occurrenceId: "1", occurrenceName: "Empresa Atuando Sem Registro no Conselho Profissional (CREA)"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "2", occurrenceName: "Falta de Gás (Emergência)"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "3", occurrenceName: "Serviço Sem Padrão de Qualidade"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "4", occurrenceName: "Galhos Caídos em Cima do Cabo"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "5", occurrenceName: "Abandonada"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "6", occurrenceName: "Ligação Domiciliar de Esgoto entupida ou com retorno"))
//        } else if occurrenceId == 2 {
//            occurrenceItens.append(OccurrencesData(occurrenceId: "7", occurrenceName: "Ligação Domiciliar de Água com Vazamento"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "9", occurrenceName: "Árvore ou Galho com Risco de Queda"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "10", occurrenceName: "Árvore Infectada"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "11", occurrenceName: "Árvore Impedindo Circulação"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "12", occurrenceName: "Árvore Com Raiz Exposta"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "13", occurrenceName: "Árvore Precisa de Poda"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "14", occurrenceName: "Obstrução por Cabo de Telecomunicação"))
//        } else if occurrenceId == 3 {
//            occurrenceItens.append(OccurrencesData(occurrenceId: "15", occurrenceName: "Buraco Raso"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "16", occurrenceName: "Barco Abandonado com Foco de Dengue"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "17", occurrenceName: "Tráfego de Moto"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "18", occurrenceName: "Cabo em Curto"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "19", occurrenceName: "Morto"))
//        } else if occurrenceId == 4 {
//            occurrenceItens.append(OccurrencesData(occurrenceId: "20", occurrenceName: "Causando Perigo"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "21", occurrenceName: "Cobertura Com Entulho"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "22", occurrenceName: "Luz Acesa de Dia"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "23", occurrenceName: "Playground Mal Conservado"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "24", occurrenceName: "Sem Piso Tátil"))
//            occurrenceItens.append(OccurrencesData(occurrenceId: "25", occurrenceName: "Risco Ao Pedestre"))
//        }
//
//        let indexPaths = [IndexPath(item: occurrenceItens.count - 1, section: 0)]
//        occurrenceSegmentCollectionView.performBatchUpdates({ () -> Void in
//            occurrenceSegmentCollectionView.insertItems(at: indexPaths)
//        }, completion: nil)

    }

}

extension SegmentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == segmentCollectionView {
            return segmentsItens.count
        } else {
            return occurrenceItens.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == segmentCollectionView {
            let cell = segmentCollectionView.dequeueReusableCell(withReuseIdentifier: SegmentCell.identifier, for: indexPath) as! SegmentCell
            cell.setSegments(segmentsItens[indexPath.row])
            return cell
        } else {
            let cell = occurrenceSegmentCollectionView.dequeueReusableCell(withReuseIdentifier: OccurrenceSegmentCell.identifier, for: indexPath) as! OccurrenceSegmentCell
            cell.setOccurrences(occurrenceItens[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == segmentCollectionView {
            if (segmentSelect != indexPath) {
                let cell = segmentCollectionView.cellForItem(at: indexPath) as? SegmentCell
                cell?.segmentImage.alpha = 0.5
                cell?.alpha = 0.5
                segmentSelect = indexPath
                segmentScrollSelect = segmentScroll
                btContinue.isEnabled = false
                setOccurrencesCollection(occurrenceId: (cell?.segmentId)!)
            }
        } else {
            let cell = occurrenceSegmentCollectionView.cellForItem(at: indexPath) as? OccurrenceSegmentCell
            cell?.occurrenceLabel.backgroundColor = .qzelaOrange
            cell?.backgroundColor = .qzelaOrange
            occurrenceSelect = indexPath
            occurrenceScrollSelect = occurrenceScroll
            if (collectionView.indexPathsForSelectedItems!.count > 0) {
                self.btContinue.isEnabled = true
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        if collectionView == segmentCollectionView {
            collectionView.deselectItem(at: indexPath, animated:true)
            if let cell = collectionView.cellForItem(at: indexPath) as? SegmentCell {
                cell.segmentImage.alpha = 1
                cell.alpha = 1
            }
        } else {
            collectionView.deselectItem(at: indexPath, animated:true)
            if let cell = collectionView.cellForItem(at: indexPath)  as? OccurrenceSegmentCell {
                cell.occurrenceLabel.backgroundColor = .qzelaDarkBlue
                cell.backgroundColor = .qzelaDarkBlue
            }
            if (collectionView.indexPathsForSelectedItems!.count == 0) {
                self.btContinue.isEnabled = false
            }
        }
    }

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let witdh = scrollView.frame.width - (scrollView.contentInset.left * 2)
//        let index = scrollView.contentOffset.x / witdh
//        let roundedIndex = round(index)
//        if (scrollView == segmentCollectionView) {
//            if (Int(roundedIndex) != segmentScroll) {
//                segmentScroll = Int(roundedIndex)
//                if (segmentSelect != nil) {
//                    if let cell = segmentCollectionView.cellForItem(at: segmentSelect) as? SegmentCell {
//                        cell.segmentImage.alpha = 1
//                        cell.alpha = 1
//                    }
//                    if segmentScroll == segmentScrollSelect {
//                        let selectItens = segmentCollectionView.indexPathsForSelectedItems!
//                        if (selectItens.count > 0) {
//                            let cell = segmentCollectionView.cellForItem(at: selectItens[0]) as? SegmentCell
//                            cell?.segmentImage.alpha = 0.5
//                            cell?.alpha = 0.5
//                        }
//                    }
//                }
//                print(Int(roundedIndex))
//            }
//        }
//    }
}

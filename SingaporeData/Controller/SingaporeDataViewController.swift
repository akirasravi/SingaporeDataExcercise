//
//  ViewController.swift
//  SingaporeData
//
//  Created by Ravi Chandra Sekhar SARIKA on 09/09/19.
//  Copyright © 2019 Ravi Chandra Sekhar SARIKA. All rights reserved.
//

import UIKit

protocol SingaporeDataViewControllerDelegate: class {
    func reloadData()
    func showAlert(title: String, message: String)
}

class SingaporeDataViewController: UIViewController {
    
    @IBOutlet weak var singaporeDataTableView: UITableView!
    var reuseTableIdentifier = "singaporeDataCell"
    var reuseTableExpandedCellIdentifier = "singaporeDataExpandedCell"
    var viewModel: SingaporeDataViewModelProtocol = SingaporeDataViewModel()
    init(viewModel: SingaporeDataViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(){
        self.init(viewModel: SingaporeDataViewModel())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.getSingaporeDataFromnService()
        self.singaporeDataTableView.dataSource = self
        self.singaporeDataTableView.delegate = self
        self.singaporeDataTableView.tableFooterView = UIView()
        self.singaporeDataTableView.bounces = false
        
    }

}


extension SingaporeDataViewController: SingaporeDataViewControllerDelegate {
    func reloadData(){
        DispatchQueue.main.async {
            self.singaporeDataTableView.reloadData()
        }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                    
                }}))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension SingaporeDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.processedSingaporeData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let singaporeDataCell = tableView.dequeueReusableCell(withIdentifier: reuseTableIdentifier) as? SingaporeDataTableViewCell {
            singaporeDataCell.configure(yearString: "Year", consumptionText: "Consumption", isClickble: false)
            singaporeDataCell.selectionStyle = .none
            return singaporeDataCell
        }else{
            return UITableViewCell()
        }

    }
    
    @objc func imgTap(tapGesture: UITapGestureRecognizer) {
        let imgView = tapGesture.view as! UIImageView
        let dataRow = viewModel.processedSingaporeData[imgView.tag]
        viewModel.getYearDataAndShow(dataRow: dataRow)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataRow = viewModel.processedSingaporeData[indexPath.row]
        if dataRow.isExpandable {
            if let singaporeDataCell = tableView.dequeueReusableCell(withIdentifier: reuseTableIdentifier, for: indexPath) as? SingaporeDataTableViewCell {
               
                let tapGesture = UITapGestureRecognizer (target: self, action: #selector(imgTap))
                singaporeDataCell.clickableImage?.addGestureRecognizer(tapGesture)
                singaporeDataCell.clickableImage?.isUserInteractionEnabled = true
                singaporeDataCell.clickableImage?.tag = indexPath.row
                
                let isDecreaseInVolumeData = viewModel.checkIfYearDemonstratesDecreaseInVolumeData(yearData: dataRow.quarterlyData)
                
                singaporeDataCell.configure(yearString: dataRow.header, consumptionText: dataRow.consumption, isClickble: isDecreaseInVolumeData)
                singaporeDataCell.selectionStyle = .none
                return singaporeDataCell
            }else{
                return UITableViewCell()
            }
        } else {
            if let singaporeDataCellExpanded = tableView.dequeueReusableCell(withIdentifier: reuseTableExpandedCellIdentifier, for: indexPath) as? SingaporeDataExpandedCell {
                singaporeDataCellExpanded.configure(yearString: dataRow.header, consumptionText: dataRow.consumption)
                singaporeDataCellExpanded.selectionStyle = .none
                return singaporeDataCellExpanded
            }else{
                return UITableViewCell()
            }
        }

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         viewModel.expandCollapseRow(index: indexPath.row)
    }
    
}

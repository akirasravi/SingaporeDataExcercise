//
//  ViewController.swift
//  SingaporeData
//
//  Created by Ravi Chandra Sekhar SARIKA on 09/09/19.
//  Copyright © 2019 Ravi Chandra Sekhar SARIKA. All rights reserved.
//

import UIKit

// protocol to perform UI operations from view Model
protocol SingaporeDataViewControllerDelegate: class {
    
    func reloadData()
    func showAlert(title: String, message: String)
    func insertRows(index: Int, count: Int)
    func deleteRows(index: Int, count: Int)
    func beginUpdates()
    func endUpdates()
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
    
    @objc func imgTap(tapGesture: UITapGestureRecognizer) { //clickable Image click
        
        let imgView = tapGesture.view as! UIImageView
        let index = viewModel.checkAndGiveNewIdexOfImage(index: imgView.tag)
        let dataRow = viewModel.processedSingaporeData[index]
        viewModel.getYearDataAndShow(dataRow: dataRow)
    }

}


extension SingaporeDataViewController: SingaporeDataViewControllerDelegate {
    @objc func beginUpdates() {
        DispatchQueue.main.async {
            self.singaporeDataTableView.beginUpdates()
        }
    }
    
   @objc func endUpdates() {
        DispatchQueue.main.async {
            self.singaporeDataTableView.endUpdates()
        }
    }
    
    
   @objc func insertRows(index: Int, count: Int) {
        DispatchQueue.main.async {
           // self.singaporeDataTableView.beginUpdates()
            for i in 1..<count+1 {
                self.singaporeDataTableView.insertRows(at:[IndexPath(row: index+i, section: 0)] , with: .automatic)
            }
            //self.singaporeDataTableView.endUpdates()
            
        }
    }
    
    @objc func deleteRows(index: Int, count: Int){
        DispatchQueue.main.async {
           // self.singaporeDataTableView.beginUpdates()
            for i in 1..<count+1 {
                self.singaporeDataTableView.deleteRows(at:[IndexPath(row: index+i, section: 0)] , with: .automatic)
            }
           // self.singaporeDataTableView.endUpdates()
        }
    }
    
    @objc func reloadData(){
        DispatchQueue.main.async {
            self.singaporeDataTableView.reloadData()
        }
    }
    
    @objc func showAlert(title: String, message: String) {
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataRow = viewModel.processedSingaporeData[indexPath.row]
        if dataRow.isExpandable {
            if let singaporeDataCell = tableView.dequeueReusableCell(withIdentifier: reuseTableIdentifier) as? SingaporeDataTableViewCell {
               
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
            if let singaporeDataCellExpanded = tableView.dequeueReusableCell(withIdentifier: reuseTableExpandedCellIdentifier) as? SingaporeDataExpandedCell {
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
        DispatchQueue.main.async {
            self.viewModel.expandCollapseRow(index: indexPath.row)
        }
    }
    
}

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
}

class SingaporeDataViewController: UIViewController {
    
    @IBOutlet weak var singaporeDataTableView: UITableView!
    var reuseTableIdentifier = "singaporeDataCell"

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
        
        viewModel.getSingaporeDataFromnService()
        viewModel.delegate = self
        self.singaporeDataTableView.dataSource = self
        self.singaporeDataTableView.delegate = self
        self.singaporeDataTableView.tableFooterView = UIView()
    }


}


extension SingaporeDataViewController: SingaporeDataViewControllerDelegate {
    func reloadData(){
        DispatchQueue.main.async {
            self.singaporeDataTableView.reloadData()
        }
    }
}

extension SingaporeDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.processedSingaporeData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let singaporeDataCell = tableView.dequeueReusableCell(withIdentifier: reuseTableIdentifier) as? SingaporeDataTableViewCell {
            singaporeDataCell.configure(yearString: "Year", consumptionText: "Consumption")
            singaporeDataCell.selectionStyle = .none
            return singaporeDataCell
        }else{
            return UITableViewCell()
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let singaporeDataCell = tableView.dequeueReusableCell(withIdentifier: reuseTableIdentifier, for: indexPath) as? SingaporeDataTableViewCell {
            let dataRow = viewModel.processedSingaporeData[indexPath.row]
            singaporeDataCell.configure(yearString: dataRow.key, consumptionText: viewModel.getTotalConsumption(array: dataRow.value))
            singaporeDataCell.selectionStyle = .none
            return singaporeDataCell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
}

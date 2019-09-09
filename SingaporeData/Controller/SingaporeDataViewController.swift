//
//  ViewController.swift
//  SingaporeData
//
//  Created by Ravi Chandra Sekhar SARIKA on 09/09/19.
//  Copyright © 2019 Ravi Chandra Sekhar SARIKA. All rights reserved.
//

import UIKit

protocol SingaporeDataViewControllerDelegate: class {
    
}

class SingaporeDataViewController: UIViewController {
    var viewModel: SingaporeDataViewModelProtocol
    init(viewModel: SingaporeDataViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    init(){
        self.viewModel = SingaporeDataViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}


extension SingaporeDataViewController: SingaporeDataViewControllerDelegate {
    
}

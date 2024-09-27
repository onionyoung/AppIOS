//
//  ViewController.swift
//  App
//
//  Created by mac on 2024/9/26.
//

import UIKit

class ViewController: UIViewController {

    var dataUserViewModel = DataUserViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataUserViewModel.getData()
    }


}


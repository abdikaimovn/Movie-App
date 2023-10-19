//
//  BaseViewController.swift
//  Movies
//
//  Created by Нурдаулет on 04.07.2023.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(hex: "#191919")
        view.backgroundColor = UIColor(hex: "#242A32")
    } 
}

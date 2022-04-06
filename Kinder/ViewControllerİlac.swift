//
//  ViewControllerİlac.swift
//  Kinder
//
//  Created by Furkan halidi on 22.12.2021.
//

import UIKit

class ViewControllerI_lac: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func checkBoxTapped (sender: UIButton){
        
        if sender.isSelected {
            sender.isSelected = false
        }else{
            sender.isSelected = true 
        }
    }

}

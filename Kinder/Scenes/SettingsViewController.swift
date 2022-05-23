//
//  SettingsViewController.swift
//  Kinder
//
//  Created by Emircan Aydın on 24.05.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOut(_ sender: Any) {
        UserDefaultsManager().saveValue(key: "accessToken", value: "")
        self.navigationController?.popToRootViewController(animated: false)
    }
}

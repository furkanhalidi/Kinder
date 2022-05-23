//
//  DashboardViewController.swift
//  Kinder
//
//  Created by 508853 on 14.05.2022.
//

import UIKit
import DefaultNetworkOperationPackage

class DashboardViewController: ViewController {

    @IBOutlet weak var nameSurname: UILabel!
    @IBOutlet weak var userClass: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfo()
    }
    
    func getUserInfo() {
        do {
            var urlRequest = try ApiServiceProvider<String>(method: .get, baseUrl: "https://spring-kindergarden.herokuapp.com/user/currentUser").returnUrlRequest()
            let token = UserDefaultsManager().getValue(key: "accessToken") as! String
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: apiCallHandler)
        } catch _ { }
    }

    private lazy var apiCallHandler: CurrentUserBlock = { [weak self] result in
        switch result {
        case .success(let response):
            DispatchQueue.main.async {
                self?.nameSurname.text = "\(response.firstName) \(response.lastName)"
            }
            UserDefaultsManager().saveValue(key: "schoolNumber", value: response.schoolNumber)
        case .failure(let error):
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "Login")
                self?.navigationController?.setNavigationBarHidden(true, animated: false)
                self?.navigationController?.popToViewController(viewController, animated: true)
            }
        }
    }
}

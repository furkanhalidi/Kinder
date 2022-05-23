//
//  ProfileViewController.swift
//  Kinder
//
//  Created by Emircan Aydın on 24.05.2022.
//

import UIKit
import DefaultNetworkOperationPackage

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameSurname: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var schoolNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentUser()
    }
    
    func getCurrentUser() {
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
                self?.phone.text = "\(response.phone)"
                self?.email.text = "\(response.email)"
                self?.schoolNumber.text = "\(response.schoolNumber)"
            }
        case .failure(let error):
            print("GET CURRENT USER FAILURE")
            self?.dismiss(animated: true)
        }
    }}

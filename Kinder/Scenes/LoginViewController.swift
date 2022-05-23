//
//  LoginViewController.swift
//  Kinder
//
//  Created by 508853 on 10.05.2022.
//

import UIKit
import DefaultNetworkOperationPackage

class LoginViewController: ViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews() {
        prepareButton()
    }
    
    private func prepareButton() {
        loginButton.layer.cornerRadius = 6
        loginButton.backgroundColor = UIColor(named: "kinderRed")
    }
    
    private func login() {
        guard let username = usernameTextField.text, username != "" else {
            showErrorAlertButton(message: "Lütfen username giriniz!")
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            showErrorAlertButton(message: "Lütfen parolanızı giriniz!")
            return
        }
        
        do {
            let authUsername = "kindergarten-client"
            let authPassword = "kindergarten-secret"
            let loginString = NSString(format: "%@:%@", authUsername, authPassword)
            let loginData = loginString.data(using: String.Encoding.utf8.rawValue)
            let base64LoginString = loginData!.base64EncodedString(options: [])

            var urlRequest = try ApiServiceProvider<String>(method: .post, baseUrl: "https://spring-kindergarden.herokuapp.com/oauth/token?grant_type=password&username=\(username)&password=\(password)").returnUrlRequest()
            urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: apiCallHandler)
        } catch _ { }
    }
    
    private lazy var apiCallHandler: LoginResultBlock = { [weak self] result in
        switch result {
        case .success(let response):
            UserDefaultsManager().saveValue(key: "accessToken", value: response.accessToken)
            DispatchQueue.main.async {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "tabBar")
                self?.navigationController?.setNavigationBarHidden(true, animated: false)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        case .failure(let error):
            print("\(error)")
        }
    }
    
    private func showErrorAlertButton(message: String) {
        let alert = UIAlertController(title: "HATA!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        self.login()
    }
}

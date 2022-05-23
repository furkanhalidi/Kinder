//
//  BodyTempatureViewController.swift
//  Kinder
//
//  Created by 508853 on 22.05.2022.
//

import UIKit
import DefaultNetworkOperationPackage

class BodyTempatureViewController: UIViewController {

    @IBOutlet weak var tempatureTextField: UITextField!
    private var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getBodyTempature()
    }
    
    func getBodyTempature() {
        do {
            guard let schoolNumber = UserDefaultsManager().getValue(key: "schoolNumber") as? String else { return }
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            var urlRequest = try ApiServiceProvider<String>(method: .get, baseUrl: "https://spring-kindergarden.herokuapp.com/bodyTempature/list?schoolNumber=\(schoolNumber)").returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: apiCallHandler)
        } catch _ { }
    }
    
    func updateBodyTempature() {
        do {
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            guard let bdId = self.id else { return }
            
            guard let tempature = self.tempatureTextField.text?.floatValue else { return }

            
            var urlRequest = try ApiServiceProvider<String>(method: .put, baseUrl: "https://spring-kindergarden.herokuapp.com/bodyTempature/update?id=\(bdId)&bodyTemperature=\(tempature)").returnUrlRequest()
            
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: self.reusableCallHandler)
        } catch _ { }
    }
    
    private lazy var apiCallHandler: (Result<[BodyTempature], ErrorResponse>) -> Void = { [weak self] result in
        switch result {
        case .success(let tempatures):
            self?.setTempature(with: tempatures[0])
        case .failure(let error):
            print("error")
        }
    }
    
    private lazy var reusableCallHandler: (Result<String, ErrorResponse>) -> Void = { [weak self] result in
        self?.getBodyTempature()
    }
    
    func setTempature(with tempature: BodyTempature) {
        DispatchQueue.main.async {
            self.tempatureTextField.text = "\(tempature.bodyTemperature)"
            self.id = tempature.id
            
            self.tempatureTextField.layer.borderWidth = 1
            
            if tempature.isEmergency {
                self.tempatureTextField.layer.borderColor = UIColor.red.cgColor
            } else {
                self.tempatureTextField.layer.borderColor = UIColor.black.cgColor
            }
        }
    }

    @IBAction func update(_ sender: Any) {
        updateBodyTempature()
    }
}

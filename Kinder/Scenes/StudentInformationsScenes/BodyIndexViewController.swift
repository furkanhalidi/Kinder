//
//  BodyIndexViewController.swift
//  Kinder
//
//  Created by 508853 on 22.05.2022.
//

import UIKit
import DefaultNetworkOperationPackage
import XCTest

class BodyIndexViewController: UIViewController {

    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var updateLabel: UIButton!
    
    private var id: String?
    private var studentId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getBodyIndex()
    }

    func getBodyIndex() {
        do {
            guard let schoolNumber = UserDefaultsManager().getValue(key: "schoolNumber") as? String else { return }
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            var urlRequest = try ApiServiceProvider<String>(method: .get, baseUrl: "https://spring-kindergarden.herokuapp.com/bodyIndex/list?schoolNumber=\(schoolNumber)").returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: apiCallHandler)
        } catch _ { }
    }
    
    func updateBodyIndex() {
        do {
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            guard let bdId = self.id else { return }

            guard let size = sizeTextField.text else { return}
            guard let weight = weightTextField.text else { return }
            
            let bodyIndex = PutBodyIndex(size: size, weight: weight)
            
            var urlRequest = try ApiServiceProvider<PutBodyIndex>(method: .put, baseUrl: "https://spring-kindergarden.herokuapp.com/bodyIndex/update?id=\(bdId)", data: bodyIndex).returnUrlRequest()
            
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: self.reusableCallHandler)
        } catch _ { }
    }
    
    private lazy var apiCallHandler: (Result<[BodyIndex], ErrorResponse>) -> Void = { [weak self] result in
        switch result {
        case .failure(let error):
            print(error)
        case .success(let bodyIndex):
            self?.setBodyIndexToTextField(with: bodyIndex[0])
        }
    }
    
    private lazy var reusableCallHandler: (Result<String, ErrorResponse>) -> Void = { [weak self] result in
        self?.getBodyIndex()
    }
    
    func setBodyIndexToTextField(with bodyIndex: BodyIndex) {
        self.id = bodyIndex.id
        self.studentId = bodyIndex.studentId
        DispatchQueue.main.async {
            self.weightTextField.text = "\(bodyIndex.weight)"
            self.sizeTextField.text = "\(bodyIndex.size)"
        }
    }
    
    @IBAction func updateBodyIndex(_ sender: Any) {
        self.updateBodyIndex()
    }
}

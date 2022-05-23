//
//  ViewControllerYemek.swift
//  Kinder
//
//  Created by Furkan halidi on 22.12.2021.
//

import UIKit
import DefaultNetworkOperationPackage

class MealViewController: UIViewController {
    
    @IBOutlet weak var morningLabel: UILabel!
    @IBOutlet weak var lunchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMeals()
    }
    
    private func getMeals() {
        do {
            guard let schoolNumber = UserDefaultsManager().getValue(key: "schoolNumber") as? String else { return }
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            var urlRequest = try ApiServiceProvider<String>(method: .get, baseUrl: "https://spring-kindergarden.herokuapp.com/meal/list?schoolNumber=\(schoolNumber)").returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: apiCallHandler)
        } catch _ { }
    }
    
    private lazy var apiCallHandler: (Result<[Meal],ErrorResponse>) -> Void = { [weak self] result in
        switch result {
        case .success(let meals):
            self?.setMeals(with: meals)
        case .failure(let error):
            print(error)
        }
    }
    
    private func setMeals(with meals: [Meal]) {
        if meals.count == 0 { return }
        
        for meal in meals {
            if meal.mealStatus == "BREAKFAST" {
                DispatchQueue.main.async {
                    self.morningLabel.text = "Sabah: \(meal.mealName)"
                }
            }
            
            if meal.mealStatus == "LUNCH" {
                DispatchQueue.main.async {
                    self.lunchLabel.text = "Öğlen: \(meal.mealName)"
                }
            }
        }
    }
}

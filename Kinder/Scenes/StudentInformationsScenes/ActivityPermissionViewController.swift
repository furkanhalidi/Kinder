//
//  ActivityPermissionViewController.swift
//  Kinder
//
//  Created by 508853 on 22.05.2022.
//

import UIKit
import DefaultNetworkOperationPackage

class ActivityPermissionViewController: UIViewController {

    @IBOutlet weak var activityTableView: UITableView!
    
    private var activities: [ActivityPermission] = []
    private var selectedActivity: ActivityPermission?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        getActivites()
    }
    
    func prepareTableView() {
        activityTableView.separatorColor = .clear
        activityTableView.register(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: ActivityCell.identifier)
        activityTableView.delegate = self
        activityTableView.dataSource = self
    }
    
    private lazy var apiCallHandler: (Result<[ActivityPermission], ErrorResponse>) -> Void = { [weak self] result in
        switch result {
        case .success(let permissions):
            DispatchQueue.main.async {
                self?.activities = permissions
                self?.activityTableView.reloadData()
            }
        case .failure(let error):
            print("error")
        }
    }
    
    private lazy var reusableCallHandler: (Result<String, ErrorResponse>) -> Void = { [weak self] result in
        self?.getActivites()
    }
    
    private lazy var permissionListener: (String) -> Void = { [weak self] activityId in
        self?.updateActivity(with: activityId)
    }
    
    @IBAction func addActivity(_ sender: Any) {
        let alertView = UIAlertController(title: "Aktivite Ekle", message: nil, preferredStyle: .alert)
        alertView.addTextField { textField in
            textField.placeholder = "Aktivite İsmi"
        }
        
        alertView.addAction(UIAlertAction(title: "Ekle", style: .default, handler: { [weak alertView] _ in
            guard let textFields = alertView?.textFields else { return }
            guard let activityName = textFields[0].text else { return }
            if activityName == "" { return }
            self.addActivity(with: activityName)
        }))
        
        alertView.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func deleteActivity(_ sender: Any) {
        deleteActivity()
    }
}

extension ActivityPermissionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActivityCell.identifier, for: indexPath) as? ActivityCell else { return UITableViewCell() }
        let activity = activities[indexPath.row]
        
        cell.activityName.text = activity.description
        cell.date.text = activity.date
        cell.id = activity.id
        cell.isPermission = activity.isPermission
        cell.setListener(with: permissionListener)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedActivity = activities[indexPath.row]
    }
}

extension ActivityPermissionViewController {
    func getActivites() {
        do {
            guard let schoolNumber = UserDefaultsManager().getValue(key: "schoolNumber") as? String else { return }
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            
            var urlRequest = try ApiServiceProvider<String>(method: .get, baseUrl: "https://spring-kindergarden.herokuapp.com/activityPermission/list?schoolNumber=\(schoolNumber)").returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: apiCallHandler)
        } catch _ { }
    }
    
    func updateActivity(with id: String) {
        do {
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            var urlRequest = try ApiServiceProvider<String>(method: .put, baseUrl: "https://spring-kindergarden.herokuapp.com/activityPermission/update?id=\(id)&studentId=12&isPermission=true&date=23.05.20222").returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: self.reusableCallHandler)
        } catch _ { }
    }
    
    func addActivity(with activityName: String) {
        do {
            guard let schoolNumber = UserDefaultsManager().getValue(key: "schoolNumber") as? String else { return }
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            var urlRequest = try ApiServiceProvider<AddActivity>(method: .post, baseUrl: "https://spring-kindergarden.herokuapp.com/activityPermission/save?schoolNumber=\(schoolNumber)", data: AddActivity(description: activityName)).returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: self.reusableCallHandler)
        } catch _ { }
    }
    
    func deleteActivity() {
        guard let selectedActivity = selectedActivity else {
            return
        }
        
        do {
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            var urlRequest = try ApiServiceProvider<String>(method: .post, baseUrl: "https://spring-kindergarden.herokuapp.com/activityPermission/delete?id=\(selectedActivity.id)").returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: reusableCallHandler)
        } catch _ { }
    }
}

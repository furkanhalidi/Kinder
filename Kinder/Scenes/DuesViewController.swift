//
//  DuesViewController.swift
//  Kinder
//
//  Created by 508853 on 21.05.2022.
//

import UIKit
import DefaultNetworkOperationPackage

class DuesViewController: UIViewController {

    @IBOutlet weak var duesTableView: UITableView!
    private var duesList: [Dues] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDues()
        prepareTableView()
    }
    
    func prepareTableView() {
        duesTableView.register(UINib(nibName: "DuesCell", bundle: nil), forCellReuseIdentifier: DuesCell.identifier)
        duesTableView.delegate = self
        duesTableView.dataSource = self
    }
    
    @IBAction func addDues(_ sender: Any) {
        let alertView = UIAlertController(title: "Ödeme Ekle", message: "", preferredStyle: .alert)
        alertView.addTextField { textField in
            textField.placeholder = "Tutar"
        }
        
        alertView.addAction(UIAlertAction(title: "Ekle", style: .default) { [weak alertView] _ in
            guard let textFields = alertView?.textFields else { return }
            guard let value = textFields[0].text else { return }
            
            if value == "" {
                 return
            }
            
            self.addDues(with: value)
        })
        
        alertView.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil))
        
        present(alertView, animated: true, completion: nil)
    }
    
    func openAlertView(index: Int) {
        let alertController = UIAlertController(title: "Ödendi olarak işaretlemek istiyor musunuz ?", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Evet", style: .default) { _ in
            self.setPaidDue(index: index)
        }
        
        let cancelAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func getDues() {
        do {
            guard let schoolNumber = UserDefaultsManager().getValue(key: "schoolNumber") as? String else { return }
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            var urlRequest = try ApiServiceProvider<String>(method: .get, baseUrl: "https://spring-kindergarden.herokuapp.com/dues/list?schoolNumber=\(schoolNumber)").returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: apiCallHandler)
        } catch _ { }
    }
    
    func addDues(with value: String) {
        do {
            let date = Date().string(format: "dd-MM-yyyy")
            let dues = Dues(id: nil, date: date, paymentDate: date, value: value.floatValue, isPaid: false)
            guard let schoolNumber = UserDefaultsManager().getValue(key: "schoolNumber") as? String else { return }
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            var urlRequest = try ApiServiceProvider<Dues>(method: .post, baseUrl: "https://spring-kindergarden.herokuapp.com/dues/save?schoolNumber=\(schoolNumber)", data: dues).returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: addDuesCallHandler)
        } catch _ { }
    }
    
    func setPaidDue(index: Int) {
        do {
            guard let duesId = duesList[index].id else { return }
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            var urlRequest = try ApiServiceProvider<Dues>(method: .put, baseUrl: "https://spring-kindergarden.herokuapp.com/dues/update?duesId=\(duesId)").returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: addDuesCallHandler)
        } catch _ { }
    }
    
    private lazy var apiCallHandler: DuesListBlock = { [weak self] result in
        switch result {
        case .success(let respose):
            self?.duesList = respose
            DispatchQueue.main.async {
                self?.duesTableView.reloadData()
            }
        case .failure(let error):
            print(error)
        }
    }
    
    private lazy var addDuesCallHandler: (Result<String?, ErrorResponse>) -> Void = { [weak self] result in
        self?.getDues()
    }
}

extension DuesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DuesCell.identifier, for: indexPath) as? DuesCell else { return UITableViewCell() }
        cell.duesDate?.text = duesList[indexPath.row].date
        cell.value?.text = "\(duesList[indexPath.row].value)"
        
        if duesList[indexPath.row].isPaid {
            cell.paymentLabel.text = "Ödendi"
            cell.paymentLabel.backgroundColor = .green
        } else {
            cell.paymentLabel.text = "Ödenmedi"
            cell.paymentLabel.backgroundColor = .red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if duesList[indexPath.row].isPaid {
            return
        }
        
        openAlertView(index: indexPath.row)
    }
}

//
//  MedicineViewController.swift
//  Kinder
//
//  Created by Furkan halidi on 22.12.2021.
//

import UIKit
import DefaultNetworkOperationPackage

class MedicineViewController: UIViewController {
    
    @IBOutlet weak var medicineTableView: UITableView!
    private var medicineList: [Medicine] = []
    private var selectedMedicine: Medicine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMedicines()
        prepareTableView()
    }
    
    func prepareTableView() {
        medicineTableView.register(UINib(nibName: "MedicineCell", bundle: nil), forCellReuseIdentifier: MedicineCell.identifier)
        medicineTableView.delegate = self
        medicineTableView.dataSource = self
    }
    
    @IBAction func deleteMedicine(_ sender: Any) {
        deleteMedicine()
    }
    
    private lazy var apiCallHandler: MedicineListBlock = { [weak self] result in
        switch result {
        case .success(let respone):
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self?.medicineList = respone
                self?.medicineTableView.reloadData()
            }
            
        case .failure(let error):
            print("error")
        }
    }
    
    private lazy var reusableCallHandler: (Result<String, ErrorResponse>) -> Void = { [weak self] result in
        self?.getMedicines()
    }
    
    private lazy var setUsedListener: (String) -> Void = { [weak self] medicineId in
        self?.updateMedicine(medicineId: medicineId)
    }
}

extension MedicineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MedicineCell.identifier, for: indexPath) as? MedicineCell else { return UITableViewCell() }
        let medicine = medicineList[indexPath.row]
        
        cell.medicineName?.text = medicine.medicineName
        cell.date?.text = medicine.date.date
        cell.hour?.text = medicine.date.hour
        cell.id = medicine.id
        cell.isUsed = medicine.isUsed
        cell.setListener(with: setUsedListener)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedMedicine = medicineList[indexPath.row]
    }
}

extension MedicineViewController {
    func getMedicines() {
        do {
            guard let schoolNumber = UserDefaultsManager().getValue(key: "schoolNumber") as? String else { return }
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            var urlRequest = try ApiServiceProvider<String>(method: .get, baseUrl: "https://spring-kindergarden.herokuapp.com/medicine/list?schoolNumber=\(schoolNumber)").returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: apiCallHandler)
        } catch _ { }
    }
    
    func addMedicine(medicineName: String) {
        do {
            guard let schoolNumber = UserDefaultsManager().getValue(key: "schoolNumber") as? String else { return }
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            var urlRequest = try ApiServiceProvider<PostMedicine>(method: .post, baseUrl: "https://spring-kindergarden.herokuapp.com/medicine/save?schoolNumber=\(schoolNumber)", data: PostMedicine(medicineName: medicineName, isUsed: false, description: "")).returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: self.reusableCallHandler)
        } catch _ { }
    }
    
    func updateMedicine(medicineId: String) {
        do {
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            var urlRequest = try ApiServiceProvider<String>(method: .put, baseUrl: "https://spring-kindergarden.herokuapp.com/medicine/update?medicineId=\(medicineId)&isUsed=true").returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: self.reusableCallHandler)
        } catch _ { }
    }
    
    func deleteMedicine() {
        guard let selectedMedicine = selectedMedicine else {
            return
        }
        
        do {
            guard let token = UserDefaultsManager().getValue(key: "accessToken") as? String else { return }
            var urlRequest = try ApiServiceProvider<String>(method: .post, baseUrl: "https://spring-kindergarden.herokuapp.com/medicine/delete?medicineId=\(selectedMedicine.id)").returnUrlRequest()
            urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
            APIManager.shared.executeRequest(urlRequest: urlRequest, completion: reusableCallHandler)
        } catch _ { }
    }
    
    @IBAction func addMedicine(_ sender: Any) {
        let alertView = UIAlertController(title: "İlaç Ekle", message: nil, preferredStyle: .alert)
        alertView.addTextField { textField in
            textField.placeholder = "İlaç İsmi"
        }
        
        alertView.addAction(UIAlertAction(title: "Ekle", style: .default, handler: { [weak alertView] _ in
            guard let textFields = alertView?.textFields else { return }
            guard let medicineName = textFields[0].text else { return }
            if medicineName == "" { return }
            
            self.addMedicine(medicineName: medicineName)
        }))
        
        alertView.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
}

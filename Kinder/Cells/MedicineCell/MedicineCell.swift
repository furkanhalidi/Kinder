//
//  MedicineCell.swift
//  Kinder
//
//  Created by 508853 on 21.05.2022.
//

import UIKit

class MedicineCell: UITableViewCell {
    
    @IBOutlet weak var medicineName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var id: String!
    var setUsedListener: ((String) -> Void)?
    var isUsed: Bool = false {
        didSet {
            if isUsed {
                setUsed(button)
            } else {
                setUnused(button)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func buttonSelected(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
        }
        setUsedListener?(id)
    }
    
    func setUsed(_ sender: UIButton) {
        sender.isSelected = true
    }
    
    func setUnused(_ sender: UIButton) {
        sender.isSelected = false
    }
    
    func setListener(with completion: @escaping (String) -> Void) {
        self.setUsedListener = completion
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

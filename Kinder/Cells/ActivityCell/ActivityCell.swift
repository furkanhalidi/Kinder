//
//  ActivityCell.swift
//  Kinder
//
//  Created by 508853 on 23.05.2022.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var id: String!
    var setPermissionListener: ((String) ->Void)?
    
    var isPermission: Bool = false {
        didSet {
            if isPermission {
                setUsed(button)
            } else {
                setUnused(button)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonSelected(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
        }
        setPermissionListener?(id)
    }
    
    func setUsed(_ sender: UIButton) {
        sender.isSelected = true
    }
    
    func setUnused(_ sender: UIButton) {
        sender.isSelected = false
    }
    
    func setListener(with completion: @escaping (String) -> Void) {
        self.setPermissionListener = completion
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

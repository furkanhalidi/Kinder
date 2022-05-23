//
//  DuesCell.swift
//  Kinder
//
//  Created by 508853 on 21.05.2022.
//

import UIKit

class DuesCell: UITableViewCell {

    @IBOutlet weak var duesDate: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Justin Lowry on 1/14/22.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if let phoneNumber = phoneNumberLabel.text, phoneNumber.isEmpty {
            phoneNumberLabel.isHidden = true
        }
    }
}

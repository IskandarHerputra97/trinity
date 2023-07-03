//
//  ContactCollectionViewCell.swift
//  TrinityWizard
//
//  Created by Iskandar Herputra Wahidiyat on 03/07/23.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderWidth = 1.0
        contactNameLabel.text = "Test Contact"
    }

}

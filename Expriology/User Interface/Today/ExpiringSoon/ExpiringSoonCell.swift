//
//  ExpiringSoonCell.swift
//  Expriology
//
//  Created by Harish Yerra on 11/2/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import UIKit

class ExpiringSoonCell: UICollectionViewCell {
    static let reuseIdentifier = "expiringSoonCell"
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Do any setup after awaking from nib.
        foodLabel.textColor = .white
        expirationLabel.textColor = .white
    }
}

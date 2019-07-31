//
//  OfferTableViewCell.swift
//  Checkout51
//
//  Created by Patel, Valay on 2019-07-31.
//  Copyright © 2019 FirstAim. All rights reserved.
//

import UIKit

class OfferTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var offerName: UILabel!
    @IBOutlet weak var offerImage: UIImageView!
    
    @IBOutlet weak var offerValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

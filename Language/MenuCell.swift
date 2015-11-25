//
//  MenuCell.swift
//  Language
//
//  Created by Daniel Li on 11/7/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

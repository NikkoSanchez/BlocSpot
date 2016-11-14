//
//  CategoryTableViewCell.swift
//  com.NikkoSanchez.BlocSpot
//
//  Created by Nikko on 11/13/16.
//  Copyright © 2016 Nikko. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

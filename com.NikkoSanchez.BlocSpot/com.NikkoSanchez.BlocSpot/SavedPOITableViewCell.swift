//
//  SavedPOITableViewCell.swift
//  com.NikkoSanchez.BlocSpot
//
//  Created by Nikko on 11/18/16.
//  Copyright © 2016 Nikko. All rights reserved.
//

import UIKit

protocol SavedPOITableViewControllerDelegate: class {
    func handleAddCategoryButton(index: IndexPath?)
}

class SavedPOITableViewCell: UITableViewCell {
    
    var indexPath: IndexPath?
    weak var savedPOITVCDelegate : SavedPOITableViewControllerDelegate?
    @IBOutlet weak var categoryColor: UIView!
    @IBOutlet weak var categoryButtonOutlet: UIButton!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addCategoryButtonPressed() {
        savedPOITVCDelegate?.handleAddCategoryButton(index: self.indexPath)
    }
    
}

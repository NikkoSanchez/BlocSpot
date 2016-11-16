//
//  CategoryTableViewCell.swift
//  com.NikkoSanchez.BlocSpot
//
//  Created by Nikko on 11/13/16.
//  Copyright © 2016 Nikko. All rights reserved.
//

import UIKit

protocol CategoryTableViewCellDelegate: class {
    func pass(indexPath: IndexPath, text: String)
}

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryText: UITextField!
    var indexPath: IndexPath?
    weak var categoryTVCDelegate : CategoryTableViewCellDelegate? //PopoverTableViewController
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryText.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CategoryTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let indexPath = indexPath, let textFieldText = textField.text else { return true }
        categoryTVCDelegate?.pass(indexPath: indexPath, text: textFieldText)
        return true
    }
}

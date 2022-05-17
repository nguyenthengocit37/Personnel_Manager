//
//  DepartmentTableViewCell.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/16/22.
//

import UIKit

class DepartmentTableViewCell: UITableViewCell {
    //Mark : Properties
    @IBOutlet weak var txtDeparmentName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected stat
    }

}

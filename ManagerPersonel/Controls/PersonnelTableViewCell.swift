//
//  PersonnelTableViewCell.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/14/22.
//

import UIKit

class PersonnelTableViewCell: UITableViewCell {
    //MARK: Properties
    
    @IBOutlet weak var tfName: UILabel!
    @IBOutlet weak var tfPosition: UILabel!
    @IBOutlet weak var tfDepartment: UILabel!
    @IBOutlet weak var tfProject: UILabel!
    @IBOutlet weak var imgAvt: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

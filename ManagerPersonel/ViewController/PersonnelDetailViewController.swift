//
//  PersonnelDetailViewController.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/14/22.
//

import UIKit
import DropDown

class PersonnelDetailViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var tfName: UILabel!
    
    @IBOutlet weak var segGender: UISegmentedControl!
    @IBOutlet weak var tfProject: UITextField!
    @IBOutlet weak var tfChucVu: UITextField!
    @IBOutlet weak var uvListDeparment: UIView!
    @IBOutlet weak var tfDepartment: UITextField!
    
    
    //Create UI choose Deparment
    let dropDown = DropDown()
    
    @IBAction func btnShowDepartment(_ sender: Any) {
        dropDown.show()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // The view to which the drop down will appear on
        dropDown.anchorView = uvListDeparment // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

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
    //Create UI choose
    let ddDepartment = DropDown()
    let ddPosition = DropDown()
    let ddProject = DropDown()
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var segGender: UISegmentedControl!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    //Department
    @IBOutlet weak var uvListDeparment: UIView!
    @IBOutlet weak var lblDepartment: UILabel!
    //Position
    @IBOutlet weak var uvListPosition: UIView!
    @IBOutlet weak var lblPosition: UILabel!
    //Project
    @IBOutlet weak var lblProject: UILabel!
    @IBOutlet weak var uvListProject: UIView!
    
    enum NavigationType{
        case newPersonnel
        case updatePersonnel
    }
    var navigationType:NavigationType = .newPersonnel
    
    var personnel:Personnel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create Dropdown list derpartment
        let arrDeparment = ["Car", "Motorcycle", "Truck"]
        let arrProject = ["Quan Ly Hoc Sinh","Quan Ly Thu Vien"]
        let arrPosition = ["Nhan vien", "Leader", "Truong Phong"]
        dropList(dropDown : ddDepartment,listItem: arrDeparment, lblItem: self.lblDepartment,uiView: uvListDeparment)
        dropList(dropDown : ddProject,listItem: arrProject, lblItem: self.lblProject,uiView: uvListProject)
        dropList(dropDown : ddPosition,listItem: arrPosition, lblItem: self.lblPosition,uiView: uvListPosition)
        
        //Get personnel from PersonnelViewCell
        if let personnel = self.personnel{
            navigationItem.title = personnel.personnelName
            tfName.text = personnel.personnelName
            if(personnel.personnelGender){
                segGender.selectedSegmentIndex = 0
            }else{
                segGender.selectedSegmentIndex = 1
            }
            lblPosition.text = personnel.codePosition
            //...
        }
    }
    //Handle show list
    @IBAction func btnShowDepartment(_ sender: Any) {
        ddDepartment.show()
    }
    @IBAction func btnShowPosition(_ sender: Any) {
        ddPosition.show()
    }
    @IBAction func btnShowProject(_ sender: Any){
        ddProject.show()
    }
    //Handle back screen
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        switch navigationType {
        case .newPersonnel:
            dismiss(animated: true, completion: nil)
        case .updatePersonnel:
            if let navigationController = navigationController{
                navigationController.popViewController(animated: true)
            }
        }
    }
    //Handle changed Gender
    @IBAction func segmentValueChaged(_ sender: UISegmentedControl) {
        let avtMale = UIImage(named:"male")
        let avtFemale = UIImage(named:"female")
        if sender.selectedSegmentIndex == 0 {
            imgAvatar.image = avtMale
        }else{
            imgAvatar.image = avtFemale
        }
    }
    
    
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let btnSender = sender as? UIBarButtonItem{
            if btnSender == btnSave{
                
            }
        }
    }
    
    
    func dropList(dropDown : DropDown,listItem : [String], lblItem : UILabel,uiView : UIView ){
        dropDown.anchorView = uiView
        dropDown.dataSource = listItem
        dropDown.dismissMode = .onTap
        // Action triggered on selection
        dropDown.selectionAction = {(index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            lblItem.text = listItem[index]
        }
        // Will set a custom width instead of the anchor view width
        dropDown.width = 200
    }
}

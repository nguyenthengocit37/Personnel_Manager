//
//  PersonnelDetailViewController.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/14/22.
//

import UIKit
import DropDown
import FirebaseDatabase

class PersonnelDetailViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    //Create UI choose
    let ddDepartment = DropDown()
    let ddPosition = DropDown()
    let ddProject = DropDown()
    var ref: DatabaseReference!
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
    var positions = [Position]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get Url FireBase
        ref = Database.database().reference()
        
        //Delegation of the TextField Object
        tfName.delegate = self
        //Create Dropdown list derpartment
//        let arrDeparment = ["Car", "Motorcycle", "Truck"]
//        let arrProject = ["Quan Ly Hoc Sinh","Quan Ly Thu Vien"]
//        let arrPosition = ["Nhan vien", "Leader", "Truong Phong"]
        getListPosition()
        createDropList()
//        dropList(dropDown : ddDepartment,listItem: arrDeparment, lblItem: self.lblDepartment,uiView: uvListDeparment)
//        dropList(dropDown : ddProject,listItem: arrProject, lblItem: self.lblProject,uiView: uvListProject)
        
//
//   dropList(dropDown : self.ddPosition,listItem:self.createDropList(), lblItem: self.lblPosition,uiView: uvListPosition)
        //Get personnel from PersonnelViewCell
        if let personnel = self.personnel{
            navigationItem.title = personnel.personnelName
            tfName.text = personnel.personnelName
            if(personnel.personnelGender){
                segGender.selectedSegmentIndex = 0
            }else{
                segGender.selectedSegmentIndex = 1
            }
            //...
        }
    }
    //MARK: TextField's Delegate Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            tfName.resignFirstResponder()
            return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = tfName.text
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
                let name = tfName.text ?? ""
                switch navigationType {
                //Create new Position
                case .newPersonnel:
//                    if let id = ref?.child("personnel").childByAutoId().key{
//                            self.ref.child("personnel").child(id).setValue([
//                                "personnelCode": id,
//                                "personnelCode": name,
//                                "countPersonnel" : 0,
//                            ])
//
//                    }
                    break
                //Update Position
                case .updatePersonnel :
                    if let key = personnel?.personnelCode {
//                        position!.namePosition = name
//                        let pos = ["codePosition": position!.codePosition,
//                                   "namePosition": position!.namePosition,
//                                   "countPersonnel": position!.countPersonnel] as [String : Any]
//                        let childUpdate = ["/position/\(key)" : pos]
//                        self.ref.updateChildValues(childUpdate)
                        
                    }
                }
            }
        }
    }
    //Handle Cancel
    @IBAction func handleCancel(_ sender: UIBarButtonItem) {
        switch navigationType {
        case .newPersonnel:
            dismiss(animated: true, completion: nil)
        case .updatePersonnel:
            if let navigationController = navigationController{
                navigationController.popViewController(animated: true)
            }
        }
    }
    //Handle create droplist
    private func createDropList(){
        var positionNames = [String]()
        for item in self.positions {
            positionNames.append(item.namePosition)
            print(item.namePosition)
        }
        dropList(dropDown: self.ddPosition, listItem: positionNames, lblItem: lblPosition, uiView: uvListPosition)
    }
    //Create List Dropdown
    private func dropList(dropDown : DropDown,listItem : [String], lblItem : UILabel,uiView : UIView ){
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
    //Get list Position from Firebase
    private func getListPosition(){
             self.ref.child("position").getData(completion: { error, snapshot in
                 if error != nil{
                   print(error!.localizedDescription)
                   return
                 }
                 for child in snapshot!.children.allObjects as! [DataSnapshot] {
                     if let dict = child.value as? [String : AnyObject]{
                         let code = dict["codePosition"] as? String ?? ""
                         let name = dict["namePosition"] as? String ?? ""
                         let count = dict["countPersonnel"] as? Int ?? 0
                         if let pos = Position(codePosition: code, namePosition: name, countPersonnel: count){
                            self.positions.append(pos)
                         }
                     }else{
                        print("Loi khi lay du lieu")
                     }
                     
                 }
                self.createDropList()
             })
    }
}

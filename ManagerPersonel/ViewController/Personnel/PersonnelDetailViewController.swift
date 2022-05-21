//
//  PersonnelDetailViewController.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/14/22.
//

import UIKit
import DropDown
import FirebaseDatabase
import Toast_Swift

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
    @IBOutlet weak var dpBirthday: UIDatePicker!
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
    var genderPersonnel:Bool = true
    var birthdayPersonnel:String = "1/1/2000"
    //Index item selected in dropdown
    var isSelectedPosition:Int?
    var isSelectedDepartment:Int?
    var isSelectedProject:Int?
    //Create Array
    var positions = [Position]()
    var departments = [Department]()
    var projects = [Project]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get Url FireBase
        ref = Database.database().reference()
        
        //Delegation of the TextField Object
        tfName.delegate = self
        
        //Create Dropdown list Position
        getListPosition()
        //Create Dropdown list Project
        getListProject()
        //Create Dropdown list Department
        getListDepartment()
        //Get personnel from PersonnelViewCell
        if let personnel = self.personnel{
            navigationItem.title = personnel.personnelName
            tfName.text = personnel.personnelName
            if(personnel.personnelGender){
                segGender.selectedSegmentIndex = 0
            }else{
                segGender.selectedSegmentIndex = 1
            }
            dpBirthday.setDate(personnel.personnelBirthday, animated: true)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            birthdayPersonnel = dateFormatter.string(from: self.dpBirthday.date)
            imgAvatar.image = personnel.personnelImage
            //Set position name for position label
            ref.child("position/\(personnel.codePosition)/namePosition").getData(completion: { err,data in
                guard err == nil else{
                    print(err!.localizedDescription)
                    return
                }
                self.lblPosition.text = data?.value as? String ?? "khong co"
            })
            //Set department name for department label
            ref.child("department/\(personnel.codeDepartment)/nameDepartment").getData(completion: { err,data in
                guard err == nil else{
                    print(err!.localizedDescription)
                    return
                }
                self.lblDepartment.text = data?.value as? String ?? ""
            })
            //Set project name for project label
            ref.child("project/\(personnel.codeProject)/nameProject").getData(completion: { err,data in
                guard err == nil else{
                    print(err!.localizedDescription)
                    return
                }
                self.lblProject.text = data?.value as? String ?? ""
            })
            
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
    //Handle back to previous screen
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
                //Handle get name
                var nameImage:String
                if genderPersonnel {
                    nameImage = "male"
                }else{
                    nameImage = "female"
                }
                //Handle get code Position
                let codePosition = positions[isSelectedPosition ?? 0].codePosition
                //Handle get codeDepartment
                let codeDepartment = departments[isSelectedDepartment ?? 0].codeDepartment
                //Handle get codeDepartment
                let codeProject = projects[isSelectedProject ?? 0].codeProject
                switch navigationType {
                //Create new Position
                case .newPersonnel:
                    if let id = ref?.child("personnel").childByAutoId().key{
                            self.ref.child("personnel").child(id).setValue([
                                "personnelCode": id,
                                "personnelName": name,
                                "personnelBirthday" : birthdayPersonnel,
                                "personnelGender" : self.genderPersonnel,
                                "personnelImage":nameImage,
                                "codePosition":codePosition,
                                "codeDepartment":codeDepartment,
                                "codeProject":codeProject,
                            ])
                        personnel = Personnel(personnelCode: id, personnelName: name, personnelBirthday: dpBirthday.date, personnelGender: self.genderPersonnel, codeProject: codeProject, codePosition: codePosition, codeDepartment: codeDepartment, personnelImage: imgAvatar.image)

                    }
                break
                //Update Position
                case .updatePersonnel :
                    if let key = personnel?.personnelCode {
                        personnel!.personnelName = name
                        personnel!.personnelBirthday = dpBirthday.date
                        personnel!.personnelImage = imgAvatar.image
                        personnel!.personnelGender = self.genderPersonnel
                        personnel!.codeProject = codeProject
                        personnel!.codePosition = codePosition
                        personnel!.codeDepartment = codeDepartment
                        let personnel = [
                            "personnelCode":key,
                            "personnelName": name,
                            "personnelBirthday" : birthdayPersonnel,
                            "personnelGender" : self.genderPersonnel,
                            "personnelImage":nameImage,
                            "codePosition":codePosition,
                            "codeDepartment":codeDepartment,
                            "codeProject":codeProject,
                        ] as [String : Any]
                        let childUpdate = ["/personnel/\(key)" : personnel]
                        self.ref.updateChildValues(childUpdate)
                    }
                }
            }
        }
    }
    //Create List Dropdown
    private func dropList(dropDown : DropDown,listItem : [String], lblItem : UILabel,uiView : UIView ){
        dropDown.anchorView = uiView
        dropDown.dataSource = listItem
        dropDown.dismissMode = .onTap
        dropDown.width = 200
        if lblItem === lblProject {
            // Action triggered on selection
            dropDown.selectionAction = {(index: Int, item: String) in
              //print("Selected project item: \(item) at index: \(index)")
                lblItem.text = listItem[index]
                self.isSelectedProject = index
            }
        }else if lblItem === lblDepartment {
            // Action triggered on selection
            dropDown.selectionAction = {(index: Int, item: String) in
              //print("Selected department item: \(item) at index: \(index)")
                lblItem.text = listItem[index]
                self.isSelectedDepartment = index
            }
        }else if lblItem === lblPosition {
            // Action triggered on selection
            dropDown.selectionAction = {(index: Int, item: String) in
              //print("Selected position item: \(item) at index: \(index)")
                lblItem.text = listItem[index]
                self.isSelectedPosition = index
            }
        }
        
        
    }
    //Handle create droplist Position
    private func createDropListPosition(){
        var positionNames = [String]()
        for item in self.positions {
            positionNames.append(item.namePosition)
        }
        //Set label item
        lblPosition.text = positions[0].namePosition
        //Create dropdown
        dropList(dropDown: self.ddPosition, listItem: positionNames, lblItem: lblPosition, uiView: uvListPosition)
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
                self.createDropListPosition()
             })
    }
    //Handle create droplist Departments
    private func createDropListDepartment(){
        var departmentNames = [String]()
        for item in self.departments {
            departmentNames.append(item.nameDepartment)
        }
        //Set label item
        lblDepartment.text = self.departments[0].nameDepartment
        //Create dropdown
        dropList(dropDown: self.ddDepartment, listItem: departmentNames, lblItem: lblDepartment, uiView: uvListDeparment)
    }
    //Get list Department from Firebase
    private func getListDepartment(){
             self.ref.child("department").getData(completion: { error, snapshot in
                 if error != nil{
                   print(error!.localizedDescription)
                   return
                 }
                 for child in snapshot!.children.allObjects as! [DataSnapshot] {
                     if let dict = child.value as? [String : AnyObject]{
                        let code = dict["codeDepartment"] as? String ?? ""
                        let name = dict["nameDepartment"] as? String ?? ""
                        if let dep = Department(codeDepartment: code, nameDepartment: name){
                            self.departments.append(dep)
                        }
                     }else{
                        print("Loi khi lay du lieu")
                     }
                     
                 }
                self.createDropListDepartment()
             })
    }
    //Handle create droplist Projects
    private func createDropListProject(){
        var projectNames = [String]()
        for item in self.projects {
            projectNames.append(item.nameProject)
        }
        //Set label item
        lblProject.text = self.projects[0].nameProject
        //Create dropdown
        dropList(dropDown: self.ddProject, listItem: projectNames, lblItem: lblProject, uiView: uvListProject)
    }
    //Get list Department from Firebase
    private func getListProject(){
             self.ref.child("project").getData(completion: { error, snapshot in
                 if error != nil{
                   print(error!.localizedDescription)
                   return
                 }
                 for child in snapshot!.children.allObjects as! [DataSnapshot] {
                     if let dict = child.value as? [String : AnyObject]{
                        let code = dict["codeProject"] as! String
                        let name = dict["nameProject"] as! String
                        if let prj = Project(codeProject: code, nameProject: name){
                            self.projects.append(prj)
                        }
                     }else{
                        print("Loi khi lay du lieu")
                     }
                     
                 }
                self.createDropListProject()
             })
    }
    @IBAction func HandleChangeBirthday(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        birthdayPersonnel = dateFormatter.string(from: sender.date)
        dpBirthday.date = sender.date
    }
    @IBAction func HandleChangeGender(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                genderPersonnel = true
            case 1:
                genderPersonnel = false
            default:
                break;
            }
    }
}

//
//  DepartmentDetailViewController.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/16/22.
//

import UIKit
import FirebaseDatabase

class DepartmentDetailViewController: UIViewController {
    @IBOutlet weak var tfDepartment: UITextField!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var ref: DatabaseReference!
    
    enum NavigationType{
        case newDepartment
        case updateDeparment
    }
    var navigationType:NavigationType = .newDepartment
    
    var department:Department?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get Url FireBase
        ref = Database.database().reference()
        
        
        //Get the edit department from DepartmentTableView
        if let department = self.department{
            navigationItem.title = department.nameDepartment
            tfDepartment.text = department.nameDepartment
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let btnSender = sender as? UIBarButtonItem{
            if btnSender == btnSave{
                    let name = tfDepartment.text ?? ""
                    switch navigationType {
                    //Create new Department
                    case .newDepartment:
                        if let id = self.ref?.child("department").childByAutoId().key{
                                self.ref.child("department").child(id).setValue([
                                    "codeDepartment": id,
                                    "nameDepartment": name,
                                ])
                               department = Department(codeDepartment: id, nameDepartment: name)
                        }
                    //Update Deparment
                    case .updateDeparment :
                        if let key = department?.codeDepartment {
                            department!.nameDepartment = name
                            let dep = ["codeDepartment":department!.codeDepartment,
                                       "nameDepartment":name] as [String : Any]
                            let childUpdate = ["/department/\(key)" : dep]
                            self.ref.updateChildValues(childUpdate)
                            
                        }
                    }
            }
        }
        
    }
    //Handle Cancel
    @IBAction func handleCancel(_ sender: UIBarButtonItem) {
        switch navigationType {
        case .newDepartment:
            dismiss(animated: true, completion: nil)
        case .updateDeparment:
            if let navigationController = navigationController{
                navigationController.popViewController(animated: true)
            }
        }
    }

}

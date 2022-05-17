//
//  ProjectViewController.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/16/22.
//

import UIKit
import FirebaseDatabase

class ProjectViewController: UIViewController,UITextFieldDelegate {
    //MARK: Properties
    var ref: DatabaseReference!
    @IBOutlet weak var tfProject: UITextField!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    enum NavigationType{
        case newProject
        case updateProject
    }
    var navigationType:NavigationType = .newProject
    
    var project:Project?
    override func viewDidLoad() {
        super.viewDidLoad()

        //Get Url FireBase
        ref = Database.database().reference()

        //Delegation of the TextField Object
        tfProject.delegate = self
        
        //Get the edit position from PositionTableView
        if let project = self.project{
            navigationItem.title = project.nameProject
            tfProject.text = project.nameProject
        }
    }
    
    //MARK: TextField's Delegate Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfProject.resignFirstResponder()
            return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = tfProject.text
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let btnSender = sender as? UIBarButtonItem{
            if btnSender == btnSave{
                let name = tfProject.text ?? ""
                switch navigationType {
                //Create new Project
                case .newProject:
                    if let id = ref.child("project").childByAutoId().key{
                            self.ref.child("project").child(id).setValue([
                                "codeProject": id,
                                "nameProject": name,
                            ])
                            project = Project(codeProject: id, nameProject: name)
                    }
                //Update Project
                case .updateProject :
                    if let key = project?.codeProject {
                        project!.nameProject = name
                        let prj = ["codeProject": project!.codeProject,
                                   "nameProject": project!.nameProject] as [String : Any]
                        let childUpdate = ["/project/\(key)" : prj]
                        self.ref.updateChildValues(childUpdate)
                        
                    }
                }
            }
        }
    }
    
    //Handle Cancel
    @IBAction func handleCancel(_ sender: UIBarButtonItem) {
        switch navigationType {
        case .newProject:
            dismiss(animated: true, completion: nil)
        case .updateProject:
            if let navigationController = navigationController{
                navigationController.popViewController(animated: true)
            }
        }
    }
}

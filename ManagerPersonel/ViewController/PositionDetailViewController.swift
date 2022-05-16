//
//  PositionDetailViewController.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/16/22.
//

import UIKit
import FirebaseDatabase
import Toast_Swift

class PositionDetailViewController: UIViewController {

    @IBOutlet weak var tfPosition: UITextField!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    var ref: DatabaseReference!
    
    enum NavigationType{
        case newPosition
        case updatePosition
    }
    var navigationType:NavigationType = .newPosition
    
    var position:Position?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get Url FireBase
        ref = Database.database().reference()

        //Get the edit position from PositionTableView
        if let position = self.position{
            navigationItem.title = position.namePosition
            tfPosition.text = position.namePosition
        }
        
       
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let btnSender = sender as? UIBarButtonItem{
            if btnSender == btnSave{
                    let name = tfPosition.text ?? ""
                    switch navigationType {
                    //Create new Position
                    case .newPosition:
                        if let id = ref.child("position").childByAutoId().key{
                                self.ref.child("position").child(id).setValue([
                                    "codePosition": id,
                                    "namePosition": name,
                                    "countPersonnel" : 0,
                                ])
                                position = Position(codePosition: id, namePosition: name, countPersonnel: 0)
                        }
                    //Update Position
                    case .updatePosition :
                        if let key = position?.codePosition {
                            position!.namePosition = name
                            let pos = ["codePosition": position!.codePosition,
                                       "namePosition": position!.namePosition,
                                       "countPersonnel": position!.countPersonnel] as [String : Any]
                            let childUpdate = ["/position/\(key)" : pos]
                            self.ref.updateChildValues(childUpdate)
                            
                        }
                    }
            }
        }
    }
    //Handle Cancel
    @IBAction func handleCancel(_ sender: UIBarButtonItem) {
        switch navigationType {
        case .newPosition:
            dismiss(animated: true, completion: nil)
        case .updatePosition:
            if let navigationController = navigationController{
                navigationController.popViewController(animated: true)
            }
        }
    }
}

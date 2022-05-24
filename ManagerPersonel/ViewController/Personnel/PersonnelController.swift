//
//  PesonnelController.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/13/22.
//

import UIKit
import Firebase

class PersonnelController: UITableViewController {
    //MARK: Properties
    var personnels = [Personnel]()
    var ref: DatabaseReference!
    
    enum NavigationType{
        case newPersonnel
        case updatePersonnel
    }
    var navigationType:NavigationType = .newPersonnel
    
    var department : Department?
    var position : Position?
    var project : Project?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get Url FireBase
        ref = Database.database().reference()
        //Get list Data
        getData()
        
        //Add the edit button into the navigation bar
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .systemRed
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return personnels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "personnelTableViewCell", for: indexPath) as? PersonnelTableViewCell{
            //Get current personnel
            let personnel = personnels[indexPath.row]
            
            cell.tfName.text = personnel.personnelName
            getProject(id:personnel.codeProject,label:cell.tfProject)
            getDepartment(id:personnel.codeDepartment,label: cell.tfDepartment)
            getPosition(id:personnel.codePosition,label:  cell.tfPosition)
            cell.imgAvt.image = personnel.personnelImage
            
            return cell
            
        }else{
            fatalError("Khong the tao")
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Delete from data source
            let key = personnels[indexPath.row].personnelCode
            self.ref.child("personnel").child(key).removeValue()
            personnels.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Indentifying new Position or update Position
        if let idenfifier = segue.identifier{
            switch idenfifier {
            case "newPersonnel":
                navigationType = .newPersonnel
                
                if let destinationController = segue.destination as? PersonnelDetailViewController {
                    destinationController.navigationType = .newPersonnel
                        }
            case "updatePersonnel":
                navigationType = .updatePersonnel
                if let selectedIndexPath = tableView.indexPathForSelectedRow{
                    let selectedRow = selectedIndexPath.row
                    let selectedPersonnel = personnels[selectedRow]
                    //Get the destination controller
                    if let destinationController = segue.destination as? PersonnelDetailViewController {
                        destinationController.personnel = selectedPersonnel
                        destinationController.navigationType = .updatePersonnel
                        }
                    }
            default: break
            }
        }
    }
    
    @IBAction func unWindFromPersonnelDetailController(segue:UIStoryboardSegue){
        if let personnelController = segue.source as? PersonnelDetailViewController{

            if let personnel = personnelController.personnel{
                switch navigationType{
                case .updatePersonnel:
                    //Get selected inDexPath
                    if let selectedIndexPath = tableView.indexPathForSelectedRow{
                        //Update personnel
                        personnels[selectedIndexPath.row] = personnel
                        //Reload the selected row in the table view
                        tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                    }
                case .newPersonnel:
                    //Create new personnel
                    personnels.append(personnel)
                    let newIndexPath = IndexPath(row: personnels.count - 1, section: 0)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }

            }
        }
    }
    
    //Get Department for Personnel
    func getDepartment(id:String,label:UILabel){
        self.ref.child("department").child(id).getData(completion: { error, snapshot in
            if error != nil{
              print(error!.localizedDescription)
              return
            }
                if let dict = snapshot!.value as? [String : AnyObject]{
                    let code = dict["codeDepartment"] as? String ?? ""
                    let name = dict["nameDepartment"] as? String ?? ""
                    if let department = Department(codeDepartment: code, nameDepartment: name){
                        self.department = department
                        label.text = name
                    }
                
                
            }
        })
    }
    //Get Project for Personnel
    func getProject(id:String,label:UILabel){
        self.ref.child("project").child(id).getData(completion: { error, snapshot in
            if error != nil{
              print(error!.localizedDescription)
              return
            }
            if let dict = snapshot!.value as? [String:AnyObject]{
                    let code = dict["codeProject"] as? String ?? ""
                    let name = dict["nameProject"] as? String ?? ""
                    if let project = Project(codeProject: code, nameProject: name){
                        self.project = project
                        label.text = name
                    }
                }
        })
    }
    //Get Project for Personnel
    func getPosition(id:String,label:UILabel){
        self.ref.child("position").child(id).getData(completion: { error, snapshot in
            if error != nil{
              print(error!.localizedDescription)
              return
            }
                if let dict = snapshot!.value as? [String : AnyObject]{
                    let code = dict["codePosition"] as? String ?? ""
                    let name = dict["namePosition"] as? String ?? ""
                    let count = dict["countPersonnel"] as? Int ?? 0
                    if let pos = Position(codePosition: code, namePosition: name, countPersonnel: count){
                        self.position = pos
                        label.text = name
                    }
            }
        })
    }
    //Get list Position from Firebase
    func getData() {
             self.ref.child("personnel").getData(completion: { error, snapshot in
                 if error != nil{
                   print(error!.localizedDescription)
                   return
                 }
                 for child in snapshot!.children.allObjects as! [DataSnapshot] {
                     if let dict = child.value as? [String : AnyObject]{
                        let code = dict["personnelCode"] as! String
                        let name = dict["personnelName"] as! String
                        let image = dict["personnelImage"] as? String ?? "male"
                        let gender = dict["personnelGender"] as! Bool
                        let birthDay = dict["personnelBirthday"] as! String
                        let codeProject = dict["codeProject"] as! String
                        let codePosition = dict["codePosition"] as! String
                        let codeDepartment = dict["codeDepartment"] as! String
                        //Get Avatar Image
                        let avt = UIImage(named:image)
                        //Create Date Formatter
                        let dateFormatter = DateFormatter()
                        //Type Formatter
                        dateFormatter.dateFormat = "dd/MM/yyyyy"
                        let date = dateFormatter.date(from: birthDay)!
                        //Create Personnel
                        if let personnel = Personnel(personnelCode:code,personnelName: name,personnelBirthday: date, personnelGender: gender,codeProject: codeProject,codePosition: codePosition,codeDepartment: codeDepartment,personnelImage:avt){
                                self.personnels.append(personnel)
                                self.tableView.reloadData()

                        }
                     }
                     
                 }
             })
    }

}

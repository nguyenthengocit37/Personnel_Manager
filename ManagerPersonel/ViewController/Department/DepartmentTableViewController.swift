//
//  DepartmentTableViewController.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/16/22.
//

import UIKit
import FirebaseDatabase

class DepartmentTableViewController: UITableViewController {
    //Mark:Propeties
    var departments = [Department]()
    var ref: DatabaseReference!
    
    enum NavigationType{
        case newDepartment
        case updateDepartment
    }
    var navigationType:NavigationType = .newDepartment
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get Url FireBase
        ref = Database.database().reference()
        //Get list Data
        getData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
       self.navigationItem.leftBarButtonItem?.tintColor = .systemRed
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return departments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: "departmentTableViewCell", for: indexPath)as? DepartmentTableViewCell{
            let department = departments[indexPath.row]
        cell.txtDeparmentName.text = department.nameDepartment
            return cell
        }else{
            fatalError("Khong the tao cell")
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
            let key = departments[indexPath.row].codeDepartment
            self.ref.child("department").child(key).removeValue()
            departments.remove(at: indexPath.row)
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
            case "newDepartment":
//               print("Add new Department")
                navigationType = .newDepartment
                
                if let destinationController = segue.destination as? DepartmentDetailViewController {
                    destinationController.navigationType = .newDepartment
                        }
            case "updateDepartment":
//                print("update Department")
                navigationType = .updateDepartment
                if let selectedIndexPath = tableView.indexPathForSelectedRow{
                    let selectedRow = selectedIndexPath.row
                    let selectedDepartment = departments[selectedRow]
                    //Get the destination controller
                    if let destinationController = segue.destination as? DepartmentDetailViewController {
                        destinationController.department = selectedDepartment
                        destinationController.navigationType = .updateDeparment
                    }
                }
            default: break
            }
                }
        
    }
     
     @IBAction func unWindFromDepartmentDetailController(segue:UIStoryboardSegue){
         if let departmentController = segue.source as? DepartmentDetailViewController{
            if let department = departmentController.department{
                 switch navigationType{
                 case .updateDepartment:
                    //Get selected inDexPath
                     if let selectedIndexPath = tableView.indexPathForSelectedRow{
                         //Update department
                         departments[selectedIndexPath.row] = department
                         //Reload the selected row in the table view
                         tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                     }
                 case .newDepartment:
                     //new department
                     departments.append(department)
                     let newIndexPath = IndexPath(row: departments.count - 1, section: 0)
                     tableView.insertRows(at: [newIndexPath], with: .automatic)
                 }

             }
         }
     }
    //Get list Department from Firebase
    func getData() {
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
                             self.tableView.reloadData()
                         }
                     }
                     
                 }
             })
    }
}

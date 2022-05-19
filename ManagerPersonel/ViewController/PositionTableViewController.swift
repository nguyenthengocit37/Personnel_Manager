//
//  PositionTableViewController.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/15/22.
//

import UIKit
import FirebaseDatabase

class PositionTableViewController: UITableViewController {
    //Mark:Propeties
    var positions = [Position]()
    var ref: DatabaseReference!
    
    enum NavigationType{
        case newPosition
        case updatePosition
    }
    var navigationType:NavigationType = .newPosition
    
    
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
        return positions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "positionTableViewCell", for: indexPath) as? PositionTableViewCell {
            
            let position = positions[indexPath.row]
            cell.txtPositionName.text = position.namePosition
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
            // Delete the row from the data source
            let key = positions[indexPath.row].codePosition
            self.ref.child("position").child(key).removeValue()
            positions.remove(at: indexPath.row)
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
            case "newPosition":
//               print("Add new Position")
                navigationType = .newPosition
                
                if let destinationController = segue.destination as? PositionDetailViewController {
                    destinationController.navigationType = .newPosition
                        }
            case "updatePosition":
//                print("update Position")
                navigationType = .updatePosition
                if let selectedIndexPath = tableView.indexPathForSelectedRow{
                    let selectedRow = selectedIndexPath.row
                    let selectedPosition = positions[selectedRow]
                    //Get the destination controller
                    if let destinationController = segue.destination as? PositionDetailViewController {
                        destinationController.position = selectedPosition
                        destinationController.navigationType = .updatePosition
                    }
                }
            default: break
            }
        }
    }
    
    @IBAction func unWindFromPositionDetailController(segue:UIStoryboardSegue){
        if let positionController = segue.source as? PositionDetailViewController{

            if let position = positionController.position{
                switch navigationType{
                case .updatePosition:
                    //Get selected inDexPath
                    if let selectedIndexPath = tableView.indexPathForSelectedRow{
                        //Update potision
                        positions[selectedIndexPath.row] = position
                        //Reload the selected row in the table view
                        tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                    }
                case .newPosition:
                    //new position
                    positions.append(position)
                    let newIndexPath = IndexPath(row: positions.count - 1, section: 0)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }

            }
        }
    }
    //Get list Position from Firebase
    func getData(){
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
                            self.tableView.reloadData()
                         }
                     }
                     
                 }
             })
    }
}

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        ref.child("position").getData(completion: { error, snapshot in
            if error != nil{
              print(error!.localizedDescription)
              return
            }
            for child in snapshot!.children.allObjects as! [DataSnapshot] {
                let dict = child.value as? [String : AnyObject] ?? [:]
                print(dict["codePosition"] ?? "")
            }
        })
        if let key = ref.childByAutoId().key{
            if let positon = Position(codePosition: key, namePosition: "Leader", countPersonnel:5){
                self.ref.child("position").child(key).setValue([
                    "codePosition": positon.codePosition,
                    "namePosition": positon.namePosition,
                    "countPersonnel" : positon.countPersonnel
                ])
                
            }
        }
       
        
        
       
        
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return positions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "positionTableViewCell", for: indexPath) as? PositionTableViewCell{
            
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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

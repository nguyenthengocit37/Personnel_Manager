//
//  PesonnelController.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/13/22.
//

import UIKit

class PersonnelController: UITableViewController {
    //MARK: Properties
    var personnels = [Personnel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create Personnel
        let dateNow = Date()
        let avt = UIImage(named:"male")
        if let personnel = Personnel(personnelName: "Nguyen The Ngoc", personnelBirthday: dateNow , personnelGender: true, codeProject: "pj1", codePosition: 1, codeDerpartment: "Kinh doanh", personnelImage: avt){
            personnels.append(personnel)
        }
        
        //Add the edit button into the navigation bar
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = fals

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
            let personnel = personnels[indexPath.row]
            cell.tfName.text = personnel.personnelName
            cell.tfProject.text = personnel.codeProject + ""
            cell.tfPosition.text = String(personnel.codePosition)
            cell.tfDepartment.text = personnel.codeDerpartment + ""
            cell.imgAvt.image = personnel.personnelImage
            
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
            //Delete from data source
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ProjectTableViewController.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/16/22.
//

import UIKit
import FirebaseDatabase

class ProjectTableViewController: UITableViewController {
    //Mark:Propeties
    var projects = [Project]()
    var ref: DatabaseReference!
    
    enum NavigationType{
        case newProject
        case updateProject
    }
    var navigationType:NavigationType = .newProject
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get Url FireBase
        ref = Database.database().reference()
        //Get list Data
        getData()

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
        return projects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "projectTableViewCell", for: indexPath) as? ProjectTableViewCell{
            
            let project = projects[indexPath.row]
            cell.txtProject.text = project.nameProject
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
            let key = projects[indexPath.row].codeProject
            self.ref.child("project").child(key).removeValue()
            projects.remove(at: indexPath.row)
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
        
            //Indentifying new Project or edit Project
            if let idenfifier = segue.identifier{
                switch idenfifier {
                case "newProject":
    //               print("Add new Project")
                    navigationType = .newProject
                    
                    if let destinationController = segue.destination as? ProjectViewController {
                        destinationController.navigationType = .newProject
                            }
                case "updateProject":
    //                print("update Project")
                    navigationType = .updateProject
                    if let selectedIndexPath = tableView.indexPathForSelectedRow{
                        let selectedRow = selectedIndexPath.row
                        let selectedProject = projects[selectedRow]
                        //Get the destination controller
                        if let destinationController = segue.destination as? ProjectViewController {
                            destinationController.project = selectedProject
                            destinationController.navigationType = .updateProject
                        }
                    }
                default: break
                }
                    }
    }
    
    //Handle unWind
    @IBAction func unWindFromProjectDetailController(segue:UIStoryboardSegue){
        if let projectController = segue.source as? ProjectViewController{

            if let project = projectController.project{
                switch navigationType{
                case .updateProject:
                    //Get selected inDexPath
                    if let selectedIndexPath = tableView.indexPathForSelectedRow{
                        //Update project
                        projects[selectedIndexPath.row] = project
                        //Reload the selected row in the table view
                        tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                    }
                case .newProject:
                    //new peroject
                    projects.append(project)
                    let newIndexPath = IndexPath(row: projects.count - 1, section: 0)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }

            }
        }
    }
    //Get list Position from Firebase
    func getData() {
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
                             self.tableView.reloadData()
                         }
                     }
                     
                 }
             })
    }

}

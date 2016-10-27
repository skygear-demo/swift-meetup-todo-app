//
//  TodoTableViewController.swift
//  todolist
//
//  Created by David Ng on 8/9/2016.
//  Copyright © 2016 SkygearIO. All rights reserved.
//

import UIKit
import SKYKit

class TodoTableViewController: UITableViewController {

    let privateDB = SKYContainer.default().privateCloudDatabase
    var objects = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        // Query change update
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: ReceivedNotificationFromSkygaer), object: nil, queue: OperationQueue.main) { (notification) in
            self.updateData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateData() {
        let query = SKYQuery(recordType: "todo", predicate: NSPredicate(format: "done == false"))
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: false)
        query?.sortDescriptors = [sortDescriptor]
        
        privateDB?.performCachedQuery(query) { (results, cached, error) in
            if (error != nil) {
                print("error querying todos: \(error)")
                return
            }
            
            self.objects = results as! [AnyObject]
            self.tableView.reloadData()
        }
    }
    
    func insertNewObject(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Todo item", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            
            // Cloud save
            let title = alertController.textFields![0].text
            let todo = SKYRecord(recordType: "todo")
            todo?.setObject(title!, forKey: "title" as NSCopying!)
            todo?.setObject(SKYSequence(), forKey: "order" as NSCopying!)
            todo?.setObject(false, forKey: "done" as NSCopying!)
            
            self.privateDB?.save(todo, completion: { (record, error) in
                if (error != nil) {
                    print("error saving todo: \(error)")
                    return
                }
                
                self.objects.insert(todo!, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            })
        }))
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todocell", for: indexPath)

        // Simple way to dislpay the title to the todo item
        let object = objects[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = object.object(forKey: "title") as? String

        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let todo = objects[(indexPath as NSIndexPath).row] as! SKYRecord
            todo.setObject(true, forKey: "done" as NSCopying!)
            self.privateDB?.save(todo, completion: { (record, error) in
                if (error != nil) {
                    print("error saving todo: \(error)")
                    return
                }
                
                self.objects.remove(at: (indexPath as NSIndexPath).row) as! SKYRecord
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            })
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {

    }


    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[(indexPath as NSIndexPath).row] as! SKYRecord
                let controller = (segue.destination as! DetailViewController)
                controller.detailItem = object
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
 

}

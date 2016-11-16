//
//  PopoverTableViewController.swift
//  com.NikkoSanchez.BlocSpot
//
//  Created by Nikko on 11/11/16.
//  Copyright © 2016 Nikko. All rights reserved.
//

import UIKit
import CoreData

class PopoverTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    
    var managedObjectContext : NSManagedObjectContext?
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBAction func addColorBarButton(_ sender: UIBarButtonItem) {
        
        let firstCategory = self.fetchedResultsController.fetchedObjects?.first
        
        let context = self.fetchedResultsController.managedObjectContext
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObject(forEntityName: entity.name!, into: context)
        
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        //newManagedObject.setValue(NSDate(), forKey: "timeStamp")
        //newManagedObject.setValue("New Note", forKey: "body")
        
        //make a new blank object for title
        newManagedObject.setValue("Click to rename category", forKey: "title")
        let colorInt = firstCategory?.color ?? 0
        let firstCategoryColorEnum = CategoryColorEnum(rawValue: Int(colorInt))
        
        let currentColor = firstCategoryColorEnum?.colorFor(lastColor: firstCategoryColorEnum!)
        
        newManagedObject.setValue(currentColor, forKey: "color")
        newManagedObject.setValue(Date(), forKey: "timeStamp")
        // Save the context.
        do {
            try context.save()
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
    }
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let sectionInfo = self.fetchedResultsController.sections![section]
        if sectionInfo.numberOfObjects == 5 {
            addButton.isEnabled = false
        } else {
            addButton.isEnabled = true
        }
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryTableViewCell
        
        cell.categoryTVCDelegate = self
        //cell.categoryText.text = "YOOOO TESTING"
        cell.indexPath = indexPath
        let object = self.fetchedResultsController.object(at: indexPath)
        if let categoryColorEnum = CategoryColorEnum(rawValue: indexPath.row) {
                cell.backgroundColor = categoryColorEnum.colorFor(category: categoryColorEnum)
        }
        
        self.configureCell(cell, withObject: object)
        
        return cell
    }
    
    func configureCell(_ cell: CategoryTableViewCell, withObject object: NSManagedObject) {
        cell.categoryText!.text = object.value(forKey: "title") as? String
        
        //cell.backgroundColor
    }
    
    // Override to support conditional editing of the table view.
   /* override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }*/
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.delete(self.fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                abort()
            }
            
        }
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Category> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        self.managedObjectContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Category>()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: true)//false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController<Category>(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Category>? //!//? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(tableView.cellForRow(at: indexPath!)! as! CategoryTableViewCell, withObject: anObject as! NSManagedObject)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.tableView.endUpdates()
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PopoverTableViewController: CategoryTableViewCellDelegate{
    
    func pass(indexPath: IndexPath, text: String) {
        
        let object = self.fetchedResultsController.object(at: indexPath)
        
        let coreDMDelegate: CoreDataManager = .sharedInstance
        self.managedObjectContext = coreDMDelegate.persistentContainer.viewContext
        
        object.setValue(text, forKey: "title")
        
        do {
            try coreDMDelegate.saveContext()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
}

//extension PopoverTableViewController: NSFetchedResultsControllerDelegate {

//}

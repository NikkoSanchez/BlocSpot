//
//  SavedPOITableViewController.swift
//  com.NikkoSanchez.BlocSpot
//
//  Created by Nikko on 11/17/16.
//  Copyright © 2016 Nikko. All rights reserved.
//

import UIKit
import CoreData

class SavedPOITableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var selectedIndexPath: IndexPath?
    var managedObjectContext : NSManagedObjectContext?
    
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
        return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SavedPOITableViewCell
        
        cell.savedPOITVCDelegate = self
        cell.indexPath = indexPath
        
        guard let pin = self.fetchedResultsController.fetchedObjects?[indexPath.row] else { return UITableViewCell() }
        configureCell(cell, withObject: pin)
        return cell
        
    }
    
    func configureCell(_ cell: SavedPOITableViewCell, withObject pin: Pin) {
        
        cell.title.text = pin.title
        let color: UIColor
        
        if let colorInt = pin.category?.color {
            let categoryColorEnum = CategoryColorEnum(rawValue: Int(colorInt))
            color = categoryColorEnum?.colorFor(category: categoryColorEnum!) ?? UIColor.white
        } else {
            color = UIColor.white
        }
        
        cell.categoryColor.backgroundColor = color
    }

    
    var fetchedResultsController: NSFetchedResultsController<Pin> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        self.managedObjectContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Pin>()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entity(forEntityName: "Pin", in: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        //let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: true)//false)
        
        fetchRequest.sortDescriptors = []
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController<Pin>(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
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
    var _fetchedResultsController: NSFetchedResultsController<Pin>? //!//? = nil
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
            guard let pin = anObject as? Pin else { return }
            self.configureCell(tableView.cellForRow(at: indexPath!)! as! SavedPOITableViewCell, withObject: pin)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.tableView.endUpdates()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? UINavigationController, let popoverVC = controller.viewControllers[0] as? PopoverTableViewController else { return }
        guard let selectedIndexPath = self.selectedIndexPath else { return }
        popoverVC.pin = self.fetchedResultsController.fetchedObjects?[selectedIndexPath.row]
    }
    

}

extension SavedPOITableViewController: SavedPOITableViewControllerDelegate {
    func handleAddCategoryButton(index: IndexPath?) {
        self.selectedIndexPath = index
        self.performSegue(withIdentifier: "presentCategoryVC", sender: self)
    }
}

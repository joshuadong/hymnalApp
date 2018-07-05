//
//  RecentsTableViewController.swift
//  trialFive
//
//  Created by Joshua Dong on 3/28/18.
//  Copyright © 2018 Joshua Dong. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

class RecentsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
     //    MARK: - Class Variables
    
    var recentsHymnArray : [String] = []
    var passedNumber : Int?
    
     //    MARK: - Loading
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        arrayTooLarge()
        updateTable()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //update table each time press on recents
        //check array size, update content for table, reload table
        arrayTooLarge()
        updateTable()
        tableView.reloadData()
        
    }
    
    //    MARK: - Update Table
    
    func updateTable() {
        //update context, so new entered values are used
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
        
        do{
            let results = try context.fetch(request)
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
//                    context.delete(result)
                    if let recents = result.value(forKey: "recentHymns") {
                        if let recentHymnNumbers = recents as? Int {
                            let recentHymnNumbersString = "\(recentHymnNumbers)"
                            if recentsHymnArray.contains(recentHymnNumbersString) {
//                                print ("already in there")
                            }
                            else {
                                recentsHymnArray.append(recentHymnNumbersString)
                            }
                            do {
                                try context.save()
                            }
                            catch {
                                print ("error")
                            }
                        }
                    }
                }
            }
        }
        catch {
            print("error")
        }
        
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
        return recentsHymnArray.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recents", for: indexPath)
        
        cell.textLabel?.text = recentsHymnArray[indexPath.row]
        
        return cell
        
    }
    
    
    // MARK: - segues
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set number for passedNumber, and performs segue
        if let indexPath = tableView.indexPathForSelectedRow {
            if let currentCell = tableView.cellForRow(at: indexPath) {
                if let cellText = Int((currentCell.textLabel?.text)!){
                    passedNumber = cellText
                }
            }
            performSegue(withIdentifier: "recentsToTextSegue", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass number for segue to new view controller
        if segue.identifier == "recentsToTextSegue" {
            if let destination = segue.destination as? ViewController {
                let secondController = destination
                if let hymnSent = passedNumber {
                    secondController.hymnNumberSent = hymnSent
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
           
            print (context)
            let currentCell = tableView.cellForRow(at: indexPath)
            passedNumber = Int((currentCell?.textLabel?.text!)!)
            if let predicatesNumber = passedNumber {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
                request.predicate = NSPredicate(format: "recentHymns = %@", NSNumber(value: predicatesNumber))
                request.returnsObjectsAsFaults = false
                do {
                    let results = try context.fetch(request)
                    for result in results as! [NSManagedObject] {
                        context.delete(result)
                        }
                        do {
                            try context.save()
                        }
                        catch {
                            print ("error")
                        }
                }
                catch {
                    print ("error")
                }
            }
            recentsHymnArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    //MARK: - Cap recents array size
    func arrayTooLarge() {
        
        let count = recentsHymnArray.count - 25
//        print ("i" + "\(recentsHymnArray.count)")
        if recentsHymnArray.count > 25 {
            for x in 0...(count - 1) {
                if let predicatesNumber = Int(recentsHymnArray[x]) {
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
                    request.predicate = NSPredicate(format: "recentHymns = %@", NSNumber(value: predicatesNumber))
                    request.returnsObjectsAsFaults = false
                    do {
                        let results = try context.fetch(request)
                        for result in results as! [NSManagedObject] {
                            context.delete(result)
                        }
                        do {
                            try context.save()
                        }
                        catch {
                            print ("error")
                        }
                    }
                    catch {
                        print ("error")
                    }
                    recentsHymnArray.remove(at: x)
                }
            }
//            confirm data removal and count removal code
//            print (recentsHymnArray.count)
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
//            let contextCount = try? context.count(for: request)
//            print (contextCount)
        }
        
    }
    // delete table cells method
    
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

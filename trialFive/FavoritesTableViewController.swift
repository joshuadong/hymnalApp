//
//  FavoritesTableViewController.swift
//  trialFive
//
//  Created by Joshua Dong on 3/22/18.
//  Copyright © 2018 Joshua Dong. All rights reserved.
//

import UIKit
import CoreData


class FavoritesTableViewController: UITableViewController {
    
    //    MARK: - Class Variables
    
    var passedNumber : Int?
    
    //    MARK: - Loading
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        arrayTooLarge()
        updateTable()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //update table each time press on recents
        arrayTooLarge()
        updateTable()
        tableView.reloadData()
        
    }
    
    //    MARK: UpdateTable
    
    func updateTable() {
        //update context, so new entered values are used
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        
        do{
            let results = try context.fetch(request)
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
//                    context.delete(result)
                    if let favorites = result.value(forKey: "favoriteHymns") {
                        //                      context.delete(result)
                        if let favoriteHymnNumbers = favorites as? Int {
                            let favoriteHymnNumbersString = "\(favoriteHymnNumbers)"
                            if Singleton.sharedInstance.favoritesArray.contains(favoriteHymnNumbersString) {
                                //                                print ("already in there")
                            }
                            else {
                                Singleton.sharedInstance.favoritesArray.append(favoriteHymnNumbersString)
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
        return Singleton.sharedInstance.favoritesArray.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath)
        
        cell.textLabel?.text = Singleton.sharedInstance.favoritesArray[indexPath.row]
        
        return cell
        
    }
    
    // MARK: - Segues
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set number for passedNumber, and performs segue
        if let indexPath = tableView.indexPathForSelectedRow {
            if let currentCell = tableView.cellForRow(at: indexPath) {
                if let cellText = Int((currentCell.textLabel?.text)!){
                    passedNumber = cellText
                }
            }
            performSegue(withIdentifier: "favoritesToTextSegue", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass number for segue to new view controller
        if segue.identifier == "favoritesToTextSegue" {
            if let destination = segue.destination as? ViewController {
                let secondController = destination
                if let hymnSent = passedNumber {
                    secondController.hymnNumberSent = hymnSent
                }
            }
        }
        
    }
    
    
    //MARK: - Cap favorites array size
    
    func arrayTooLarge() {
        
        let count = Singleton.sharedInstance.favoritesArray.count - 25
        print ("i" + "\(Singleton.sharedInstance.favoritesArray.count)")
        if Singleton.sharedInstance.favoritesArray.count > 25 {
            for x in 0...(count - 1) {
                if let predicatesNumber = Int(Singleton.sharedInstance.favoritesArray[x]) {
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
                    request.predicate = NSPredicate(format: "favoriteHymns = %@", NSNumber(value: predicatesNumber))
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
                    Singleton.sharedInstance.favoritesArray.remove(at: x)
                }
            }
            //confirm data removal and count removal code Test Code
            //                        print (Singleton.sharedInstance.favoritesArray.count)
            //                        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            //                        let contextCount = try? context.count(for: request)
            //                        print (contextCount)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

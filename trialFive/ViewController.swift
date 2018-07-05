//
//  ViewController.swift
//  trialFive
//
//  Created by Joshua Dong on 3/22/18.
//  Copyright © 2018 Joshua Dong. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
     //    MARK: - Outlets
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
     //    MARK: - Class Variables
    
    var hymnNumberSent = 0
    var currentHymn : Int = 0
    
     //    MARK: - Loading
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Hymn Number: \(hymnNumberSent)"
        
        // Do any additional setup after loading the view, typically from a nib.
        parseJSON(hymnNumber: hymnNumberSent)
        
        //Load favorites array on first load because favorites Array is initially empty, then check if selected
        if Singleton.sharedInstance.favoritesArray.isEmpty {
            loadFavorites()
        }
        isSelected()
        
        //change text size based on users desires
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        
    }
    
    //    MARK: - ParseJson
    
    func parseJSON(hymnNumber : Int) {
        
        if hymnNumberSent != 0 {
            if let path = Bundle.main.path(forResource: "properFormat", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? [String: Any], let hymns = jsonResult["hymns"] as? [[String: Any]] {
                        let arrayNumber = (hymnNumber - 1)
                        if let hymnLyrics = hymns[arrayNumber]["lyrics"] as? String {
                            textView.text = hymnLyrics
                            
                        }
                    }
                }
                catch {
                    print (error.localizedDescription)
                }
            }
        }
        else {
            textView.text = "Invalid Hymn Number"
        }
        
    }
    
    //    MARK: - next and previous button
    
    @IBAction func nextButton(_ sender: Any) {
        
        if hymnNumberSent == 1352 {
            self.nextButton.isEnabled = false
        }
        else {
            hymnNumberSent += 1
            self.title = "Hymn Number: \(hymnNumberSent)"
            parseJSON(hymnNumber: hymnNumberSent)
            
            //insert into coreData, hymn Number
            let newRecent = NSEntityDescription.insertNewObject(forEntityName: "Recents", into: context)
            newRecent.setValue(hymnNumberSent, forKey: "recentHymns")
            isSelected()
        }
        
    }
    
    
    @IBAction func previousButton(_ sender: Any) {
        
        if hymnNumberSent == 1 {
            self.previousButton.isEnabled = false
        }
        else {
            hymnNumberSent -= 1
            self.title = "Hymn Number: \(hymnNumberSent)"
            parseJSON(hymnNumber: hymnNumberSent)
            
            //insert into coreData, hymn Number
            let newRecent = NSEntityDescription.insertNewObject(forEntityName: "Recents", into: context)
            newRecent.setValue(hymnNumberSent, forKey: "recentHymns")
            isSelected()
        }
        
    }
    
    //    MARK: - favorites
    
    @IBAction func favoritesButtonTapped(_ sender: Any) {
        
        if Singleton.sharedInstance.favoritesArray.contains(String(hymnNumberSent)) {
            //turn off selected, remove favorites from context
            favoritesButton.isSelected = false
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            request.predicate = NSPredicate(format: "favoriteHymns = %@", NSNumber(value: hymnNumberSent))
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
            while Singleton.sharedInstance.favoritesArray.contains(String(hymnNumberSent)) {
                if let itemToRemoveIndex = Singleton.sharedInstance.favoritesArray.index(of: String(hymnNumberSent)) {
                    Singleton.sharedInstance.favoritesArray.remove(at: itemToRemoveIndex)
                }
            }
        }
        else {
//            print (hymnNumberSent)
            if hymnNumberSent != 0 {
                Singleton.sharedInstance.favoritesArray.append(String(hymnNumberSent))
                //turn on selected, add to favorites from context
                favoritesButton.isSelected = true
                let newRecent = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context)
                newRecent.setValue(hymnNumberSent, forKey: "favoriteHymns")
            }
        }
        
    }
    
    //MARK: - Load Favorites
    func isSelected() {

        if Singleton.sharedInstance.favoritesArray.contains(String(hymnNumberSent)) {
            favoritesButton.isSelected = true
        }
        else {
            favoritesButton.isSelected = false
        }
        favoritesButton.setImage(#imageLiteral(resourceName: "goldStar"), for: .selected)
        favoritesButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        
    }
    
    func loadFavorites() {
        
        let favoritesUpdate = FavoritesTableViewController()
        favoritesUpdate.updateTable()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


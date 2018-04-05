//
//  EnterNumberViewController.swift
//  trialFive
//
//  Created by Joshua Dong on 3/22/18.
//  Copyright © 2018 Joshua Dong. All rights reserved.
//

import UIKit
import CoreData

class EnterNumberViewController: UIViewController {

    @IBOutlet weak var enterNumber: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorLabel.isHidden = true
        
        enterNumber.text = ""

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController {
            let secondController = destination
            if let hymnSent = Int(enterNumber.text!) {
                secondController.hymnNumberSent = hymnSent
            }
        }
    }
    

    @IBAction func go(_ sender: Any) {
            if enterNumber.text != "" {
                if let enteredNumber = enterNumber.text {
                    if Int(enteredNumber)! > 1352 {
                        let errorMessage = "Number not in Hymnal"
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = errorMessage
                    }
                    else {
                        let newRecent = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
                        if let hymnSent = Int(self.enterNumber.text!) {
                            newRecent.setValue(hymnSent, forKey: "hymnNumberRecents")
                        }
                        
                        performSegue(withIdentifier: "showHymn", sender: nil)
                        
                        self.enterNumber.text = ""
                        self.errorLabel.text = ""
                    }
                }
            }
            else {
                let errorMessage = "Please enter a number"
                self.errorLabel.isHidden = false
                self.errorLabel.text = errorMessage
            }
    }
    
    
    //Resign numberpad as first responder after finished typing in number
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        enterNumber.resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

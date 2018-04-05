//
//  ViewController.swift
//  trialFive
//
//  Created by Joshua Dong on 3/22/18.
//  Copyright © 2018 Joshua Dong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    var hymnNumberSent = 0

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Hymn Number: \(hymnNumberSent)"
        
        // Do any additional setup after loading the view, typically from a nib.
        parseJSON(hymnNumber: hymnNumberSent)
        
    }

    @IBAction func nextButton(_ sender: Any) {
        
            if hymnNumberSent == 1352 {
                self.nextButton.isEnabled = false
            }
            else {
                
                hymnNumberSent += 1
                self.title = "Hymn Number: \(hymnNumberSent)"
                parseJSON(hymnNumber: hymnNumberSent)
                
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
            
        }
    
        
    }
    
    func parseJSON(hymnNumber : Int) {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}


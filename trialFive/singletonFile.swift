//
//  singletonFile.swift
//  trialFive
//
//  Created by Joshua Dong on 4/12/18.
//  Copyright © 2018 Joshua Dong. All rights reserved.
//

import Foundation

class Singleton {
    
    private init() {}
    
    static let sharedInstance = Singleton()
    
    var favoritesArray: [String] = []
    
    
}

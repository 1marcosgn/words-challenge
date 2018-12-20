//
//  DUOChallengeManager.swift
//  DuolingoApp
//
//  This Singleton allows to control the Logistic of the game, has control over the current words
//  available in the Challenge, knows as well once a Challenge is resolved and if a Set of elements
//  selected by the user matches any of the available location for the Current Challenge, it can be
//  used by the Interactor to evaluate user selection.
//
//  Created by Marcos Garcia on 12/14/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import UIKit

public final class DUOChallengeManager: NSObject {
    /// Number of matches in the current challenge
    public var numberOfMatches: Int = 0
    
    /// Total of elements in the word_locations for current challenge
    public var targetsCount: Int = 0
    
    /// Array of words in the current challenge
    public var targetWords:[String]?
    
    /// Locations for the current challenge
    public var challengeLocations: [DUOLocation]?
    
    /// Single instance of DUOChallengeManager
    public static let sharedInstance = DUOChallengeManager()
    
    /// Internal variable to keep track of the user's selection
    internal var selected_location: DUOLocation?
    
    /// Stores the current challenge
    public var theCurrentChallenge: DUOChallenge?
    
    /**
     Initializer to handle word locations coming from sources other than User Interaction, typically from Service Response
     - parameter word_locations: Array of dictionaries that represents the location of the words
     */
    public func challengeLocationMatchesWith(userSelection: DUOLocation) -> Bool {
        self.selected_location = userSelection
        
        var match = false
        
        guard let locations = self.challengeLocations else {
            return false
        }
        
        for location in locations {
            //matches = self.selected_location?.word_locations == location.word_locations
            //if matches { DUOChallengeManager.sharedInstance.numberOfMatches -= 1 }
            
            if self.selected_location?.word_locations == location.word_locations {
                DUOChallengeManager.sharedInstance.numberOfMatches -= 1
                match = true
            }
        }
        
        return match
    }
    
    func allMatchesFound() -> Bool {
        return DUOChallengeManager.sharedInstance.numberOfMatches == 0
    }
}

internal extension DUOChallengeManager {
    /// Resets Manager properties to default values
    func reset() {
        self.targetsCount = 0
        self.targetWords = nil
        self.challengeLocations = nil
        self.selected_location = nil
    }
}


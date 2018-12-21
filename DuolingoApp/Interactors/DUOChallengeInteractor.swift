//
//  DUOChallengeInteractor.swift
//  DuolingoApp
//
//  Use this class to interact between User Interface and Data Models or Services Layer
//  some util functions in this class are related to compare word locations selected by the
//  user against the Challenge Word Locations
//
//  Created by Marcos Garcia on 12/15/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import UIKit

public class DUOChallengeInteractor {
    /// Array of elements selected by the user from the grid
    public var userSelectedElements = [Int]()
    
    /// Property to manage the available challenges
    public var availableChallenges: [DUOChallenge]?
    
    /// Property that indicates the current challenge
    public var currentChallenge: DUOChallenge?

    /// Method that uses the Service Implementer to gather challenges from an external API
    public func requestChallenges(completion: @escaping (Bool) -> ()) {
        let serviceImpl = DUOServicesImplementer.init()
        serviceImpl.findChallenges { (success) in
            
            if success {
                self.makeChallengesWith(serviceImpl.duoChallenges)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    /// Uses the Factory Class to create challenges based on the response
    public func makeChallengesWith(_ content: [[String: Any]]?) {
        let factory = DUOChallengesFactory.shared()
        
        guard let challenges = factory.getChallenges(duoChallenges: content) else {
            return
        }
        
        availableChallenges = challenges
        setCurrentChallenge()
    }
}

/// Extension to handle User Interaction
public extension DUOChallengeInteractor {
    
    /**
     This method handles the logic related to the user's selection, evaluates if matches with the Challenge Grid Location
     - parameter selection: The Location Object with the user selection
     - returns: a bool that indicates if the selection matches
     */
    public func evaluateSelection(_ selection: DUOLocation?) -> Bool{
        var matches = false
        
        guard let manualSelection = selection else {
            return false
        }
        
        let currenChallenge = DUOChallengeManager.sharedInstance.theCurrentChallenge
        
        /// Set up the global manager with the current challenger related properties
        currenChallenge?.setUpChallengeManager()
        
        /// Use the challenge manager to determine if the user selection matches, if matches... then the current challenge is completed
        if DUOChallengeManager.sharedInstance.challengeLocationMatchesWith(userSelection: manualSelection) {
            
            if DUOChallengeManager.sharedInstance.allMatchesFound() {
                updateChallenges()
            }
            
            matches = true
        }
        
        return matches
    }
}

/// Internal extension to handle the available challenges
internal extension DUOChallengeInteractor {
    /// This method updates the available challenges, current challenge and requests more challenges if it's required
    internal func updateChallenges() {
        guard let numberOfChallenges = availableChallenges?.count else {
            return
        }
        
        if numberOfChallenges > 1 {
            availableChallenges?.removeFirst()
            DUOChallengeManager.sharedInstance.theCurrentChallenge = availableChallenges?.first
        } else {
            availableChallenges = [DUOChallenge]()
            DUOChallengeManager.sharedInstance.theCurrentChallenge = nil
        }
        
        /// If challenges are empty, request for more challenges
        if availableChallenges?.count == 0 {
            requestChallenges { (success) in
                if !success { print("Something went wrong fetching more challenges") }
            }
        }
    }
    
    /// Set the current challenge into the DUOChallengeManager
    internal func setCurrentChallenge() {
        DUOChallengeManager.sharedInstance.theCurrentChallenge = availableChallenges?.first
        DUOChallengeManager.sharedInstance.numberOfMatches = availableChallenges?.first?.word_locations?.count ?? 0
    }
}

/// Extension to deal with user selection and parse information into the right format
public extension DUOChallengeInteractor {
    
    /// Initializes the array of selected elements
    public func initializeSelectedElements() {
        userSelectedElements = [Int]()
    }
    
    /**
     Updates the elements in the array with user selection
     - parameter selection: The selected elements
     */
    public func updateSelectedElementsWith(_ selection: Int) {
        userSelectedElements.append(selection)
    }
    
    /**
     Transform user selection into a DUOLocation object
     - parameter gridLocations: Array of elements that contains the grid locations
     - returns: an optional DUOLocation object with the location configured
     */
    public func getDuoLocationFrom(_ gridLocations:[[Int]]) -> DUOLocation? {
        // Remove duplicated elements from 'userSelectedElements'
        let uniqueElements = getUniqueElementsFor(userSelectedElements)
        
        // Get the arrays from 'gridLocations' based on the results in 'userSelectedElements'
        var tmpArrayForLocations = [[Int]]()
        
        for element in uniqueElements {
            let tmpLocation = gridLocations[element]
            tmpArrayForLocations.append(tmpLocation)
        }
        
        return DUOLocation.init(selected_locations: [tmpArrayForLocations])
    }
    
    /**
     Use this method to filter duplicated elements in an Array
     - parameter elements: Original Array of elements
     - returns: an array with unique elements in the same order that was received
     */
    public func getUniqueElementsFor(_ elements: [Int]) -> [Int] {
        return elements.removeDuplicates()
    }
}

/// Extension to remove duplicated elements from a given array (keeps the orden of the elements)
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}


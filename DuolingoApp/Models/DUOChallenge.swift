//
//  DUOChallenge.swift
//  DuolingoApp
//
//  This class is a model where a Challenge is configured with all the required
//  properties, conforms the 'DUOChallengeProtocol' to handle the information coming
//  from a Dictionary
//
//  Created by Marcos Garcia on 12/14/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import UIKit

/// DUOChallenge constants
private struct Constants {
    static let sourceLanguage = "source_language"
    static let word = "word"
    static let characterGrid = "character_grid"
    static let wordLocations = "word_locations"
    static let targetLanguage = "target_language"
}

public class DUOChallenge: DUOChallengeProtocol {
    /// Stores the dictionary with challenge information
    let challengeInfo: [String: Any]
    
    public var source_language: String = ""
    public var word: String = ""
    public var character_grid: [[String]] = [[String]]()
    public var word_locations: [DUOLocation]? = [DUOLocation.init(word_locations: [[String : String]]())]
    public var target_language: String = ""
    
    /// Initializer for DUOChallenge class, receives a parsed dictionary with the elements of the challenge
    public init(challenge: [String: Any]) {
        challengeInfo = challenge
        setUpChallengeProperties()
    }
}

/// Extension to set up Challenge Manager based on current challenge elements
public extension DUOChallenge {
    /// Method to set up properties of the ChallengeManager with current challenge information
    public func setUpChallengeManager() {
        let manager = DUOChallengeManager.sharedInstance
        manager.targetsCount = word_locations?.count ?? 0
        manager.targetWords = [word]
        manager.challengeLocations = word_locations
    }
}

/// Extension to initialize Challenge properties
internal extension DUOChallenge {
    /// Method to update properties of the challenge with the information from the dictionary
    internal func setUpChallengeProperties() {
        source_language = getSourceLanguage()
        word = getWord()
        character_grid = getCharacterGrid()
        word_locations = getWordLocations()
        target_language = getTargetLanguage()
    }
    
    /// Returns 'sourceLanguage' value
    internal func getSourceLanguage() -> String {
        guard let sourceLanguage = challengeInfo[Constants.sourceLanguage] as? String else {
            return ""
        }
        return sourceLanguage
    }
    
    /// Returns 'word' value
    internal func getWord() -> String {
        guard let word = challengeInfo[Constants.word] as? String else {
            return ""
        }
        return word
    }
    
    /// Returns 'character_grid' value
    internal func getCharacterGrid() -> [[String]] {
        guard let character_grid = challengeInfo[Constants.characterGrid] as? [[String]] else {
            return [[String]]()
        }
        return character_grid
    }
    
    /// Returns 'locations' value
    internal func getWordLocations() -> [DUOLocation]? {
        
        var arrayLocations = [DUOLocation]()
        
        guard let locations = challengeInfo[Constants.wordLocations] as? [String : Any] else {
            return nil
        }

        for location in locations {
            guard let locationFromArray = [location.key :location.value] as? Dictionary<String, String> else {
                return nil
            }
            
            let duoLocation = DUOLocation.init(word_locations: [locationFromArray])
            arrayLocations.append(duoLocation)
        }
        
        return arrayLocations
    }
    
    /// Returns 'target_language' value
    internal func getTargetLanguage() -> String {
        guard let target_language = challengeInfo[Constants.targetLanguage] as? String else {
            return ""
        }
        return target_language
    }
}


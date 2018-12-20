//
//  DUOChallengeViewModel.swift
//  DuolingoApp
//
//  This class does the configuration of the grid of words
//
//  Created by Marcos Garcia on 12/16/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import UIKit

public class DUOChallengeViewModel: NSObject {
    /// Current challenge
    public var challenge: DUOChallenge?
    
    /// get the array of elements
    public var arrayOfWords = [[String]]()
    
    /// get the array of positions
    public var arrayOfLocations: [[Int]]?

    /// get the array of sections
    public var arrayOfSections:[[String]]?
    
    /// get the array of each location
    public var arrayOfLocationSections:[[[Int]]]?
    
    /// Model Initializer
    public init(challenge: DUOChallenge) {
        super.init()
        self.challenge = challenge
        self.arrayOfWords = challenge.character_grid
        self.arrayOfLocations = [[Int]]()
        self.setUpSections()
        self.setUpLocationSections()
    }
}

internal extension DUOChallengeViewModel {
    /**
     Gets an array of words formatted
     - returns: a final array of words
     */
    func getArrayOfWordsFromatted() -> [String] {
        var finalArray = [String]()
        for row in self.arrayOfWords {
            for word in row {
                finalArray.append(word)
            }
        }
        return finalArray
    }
    
    /**
     Add the location for each element of the array with the format:
     [ [0, 0], [0, 1], [0, 2], [0, 3], [0, 4] ...
     */
    func setUpArrayOfLocations() {
        var locations = [[Int]]()
        for (indexWord, row) in self.arrayOfWords.enumerated() {
            for (indexRow, _) in row.enumerated() {
                //locations.append([indexWord, indexRow])
                locations.append([indexRow, indexWord])
            }
        }
        self.arrayOfLocations = locations
    }
    
    /**
     Determines the number of sections in the 'arrayOfWords'
     - returns: number of sections
     */
    func getNumberOfSections() -> Int{
        return self.arrayOfWords.count
    }
    
    /**
     Configures the array of sections with the next format:
        [ ["z", "n", "w", "f", "m", "\\u00e9"],
        ["d", "\\u00f3", "q", "w", "n", "e"].. ]
     */
    func setUpSections() {
        self.arrayOfSections = self.arrayOfWords
    }
    
    /**
     Configures the 'arrayOfLocationSections' with the next format:
        [ [[0,1], [0,2], [0,3], [0,4], [0,5], [0,6]],
          [[1,1], [1,2], [1,3], [1,4], [1,5], [1,6]].. ]
     */
    func setUpLocationSections() {
        let numberOfSections = self.getNumberOfSections()
        self.setUpArrayOfLocations()
        
        guard let result = arrayOfLocations?.chunked(by: numberOfSections) else {
            return
        }
        self.arrayOfLocationSections = result
    }
}


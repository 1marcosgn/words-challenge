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

public class DUOChallengeViewModel {
    /// Current challenge
    public let challenge: DUOChallenge?
    
    /// get the array of elements
    public let arrayOfWords: [[String]]?

    /// get the array of sections
    public let arrayOfSections: [[String]]?
    
    /// get the array of positions
    public var arrayOfLocations: [[Int]]?
    
    /// get the array of each location
    public var arrayOfLocationSections: [[[Int]]]?
    
    /// Model Initializer
    public init(challenge: DUOChallenge) {
        self.challenge = challenge
        arrayOfWords = challenge.character_grid
        arrayOfSections = arrayOfWords
        setUpArrayOfLocations()
        setUpLocationSections()
    }
}

internal extension DUOChallengeViewModel {
    /**
     Get each word from the array
     - returns: an array of words
     */
    func getWords() -> [[String]] {
        guard let rows = arrayOfWords else {
            return [[String]]()
        }
        return rows
    }
    
    /**
     Gets an array of words formatted
     - returns: a final array of words
     */
    func getArrayOfWordsFromatted() -> [String] {
        var finalArray = [String]()
        for row in getWords() {
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
        for (indexWord, row) in getWords().enumerated() {
            for (indexRow, _) in row.enumerated() {
                locations.append([indexRow, indexWord])
            }
        }
        arrayOfLocations = locations
    }
    
    /**
     Determines the number of sections in the 'arrayOfWords'
     - returns: number of sections
     */
    func getNumberOfSections() -> Int{
        return getWords().count
    }
    
    /**
     Configures the 'arrayOfLocationSections' with the next format:
        [ [[0,1], [0,2], [0,3], [0,4], [0,5], [0,6]],
          [[1,1], [1,2], [1,3], [1,4], [1,5], [1,6]].. ]
     */
    func setUpLocationSections() {
        let numberOfSections = getNumberOfSections()
        setUpArrayOfLocations()
        
        guard let result = arrayOfLocations?.chunked(by: numberOfSections) else {
            return
        }
        arrayOfLocationSections = result
    }
}


//
//  DUOLocation.swift
//  DuolingoApp
//
//  This class is a helper to determine the location of the target words,
//  has two initializers to support 'word_locations' coming from a service
//  response with the format:
//                              "0,2,0,3,0,4": "soy"
//
//  and also word location obtained from User Interaction as:
//                              [ [[5, 1], [5, 2], [5, 3], [5, 4]]   /// "ella"
//                                [[6,3],[6,4]] ]                    /// "el"
//
//  Created by Marcos Garcia on 12/13/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import UIKit

public class DUOLocation: NSObject {
    /// Property to expose the word locations
    public var word_locations: [[[Int]]]?
    
    /**
     Initializer to handle word locations coming from sources other than User Interaction, typically from Service Response
     - parameter word_locations: Array of dictionaries that represents the location of the words
     */
    public init(word_locations: [[String: String]]) {
        super.init()
        self.word_locations = transformLocations(locations: word_locations)
    }
    
    /**
     Initializer to handle User's selected location from the Grid
     - parameter selected_locations: send as a parameter the tuples of locations stored in sub arrays, example: [ [[6,3],[6,4]] ]
     */
    public init(selected_locations: [[[Int]]]) {
        self.word_locations = selected_locations
    }
}

internal extension DUOLocation {
    /**
     Method to transform location into a valid format
     - parameter locations: The word locations in the format: [["0,2,0,3,0,4": "soy"]]
     - returns: An array of locations with the format: [[[0,2],[0,3],[0,4]]]
     */
    internal func transformLocations(locations: [[String: String]]) -> [[[Int]]]? {
        var arrayOfTargetLocationsAsStrings = [[String]?]()
        var arrayOfTargetLocationsAsInts = [[Int]?]()
        var final_locations: [[[Int]]]? = [[[Int]()]]
        
        for wordLocation in locations {
            let keys = DUOLocation.returnArrayOfKeysFrom(wordLocation)
            arrayOfTargetLocationsAsStrings.append(keys)
        }
        
        for targetLocation in arrayOfTargetLocationsAsStrings {
            guard let singleaLocation = targetLocation?.first else {
                return nil
            }
            
            let splitString = singleaLocation.split(separator: ",")
            let arrayOfStrings = splitString.map { String($0) }
            let arrayOfInts = arrayOfStrings.compactMap { Int($0) }
            
            arrayOfTargetLocationsAsInts.append(arrayOfInts)
        }
        
        for elements in arrayOfTargetLocationsAsInts {
            guard let result = elements?.chunked(by: 2) else { return nil }
            
            final_locations?.append(result)
        }
        
        final_locations?.removeFirst()
        return final_locations
    }
    
    /**
     Method to return the keys of a dictionary in an Array
     - parameter dictionary: A dictionary that contains the target word with the format: ["0,2,0,3,0,4": "soy"]
     - returns: An array of strings that represents the keys of the received dictionary: ["0,2,0,3,0,4"]
     */
    internal class func returnArrayOfKeysFrom(_ dictionary: [String: String]) -> [String]? {
        let invertedDictionary = Dictionary(grouping: dictionary.keys, by: { dictionary[$0]! })
        
        guard let key = invertedDictionary.keys.first else {
            return nil
        }
        
        guard let arrayOfKeys = invertedDictionary[key]?.first else {
            return nil
        }
        
        return [arrayOfKeys]
    }
}

extension Array {
    /**
     Separates an array in components based on the chunk size
     - parameter chunkSize: desired number of elements that the chunk will contain, receives: [5,1,5,2,5,3,5,4]
     - returns: an array of arrays with the elements of the original array: [[[5,1],[5,2],[5,3],[5,4]]
     */
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}


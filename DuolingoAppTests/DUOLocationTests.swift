//
//  DUOLocationTests.swift
//  DuolingoAppTests
//
//  Created by Marcos Garcia on 12/13/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import XCTest

class DUOLocationTests: XCTestCase {

    func test_InitializerFor_Single_WordLocation_ShouldWorkAsExpected() {
        /// Given
        let wordLocation = [["0,2,0,3,0,4": "soy"]]
        let expectedLocation = [[[0,2],[0,3],[0,4]]]
        
        /// When
        let sut = DUOLocation.init(word_locations: wordLocation)
        
        /// Then
        XCTAssertNotNil(sut, "Initialized object should not be nil")
        XCTAssertEqual(sut.word_locations, expectedLocation, "word location should match with expected location")
    }
    
    func test_InitializerFor_Multiple_WordLocation_ShouldWorkAsExpected() {
        /// Given
        let wordLocation = [["0,2,0,3,0,4": "soy"],
                            ["1,2,1,3": "el"],
                            ["2,2,2,3,2,4,2,5": "ella"]]
        
        let expectedLocation = [[[0,2],[0,3],[0,4]],
                                [[1,2],[1,3]],
                                [[2,2],[2,3],[2,4],[2,5]]]

        /// When
        let sut = DUOLocation.init(word_locations: wordLocation)
        
        /// Then
        XCTAssertNotNil(sut, "Initialized object should not be nil")
        XCTAssertEqual(sut.word_locations, expectedLocation, "word location should match with expected location")
    }
    
    func testSwapKeys_ForSingleElement_ShouldCreateValidDictionary() {
        /// Given
        let sut = ["0,2,0,3,0,4": "soy"]
        let mockSwapedDictionary = ["0,2,0,3,0,4"]
        
        /// When
        let swapedDictionary = DUOLocation.returnArrayOfKeysFrom(sut)
        
        /// Then
        XCTAssertNotNil(swapedDictionary, "The inverted dictionary should not be nil")
        XCTAssertEqual(swapedDictionary, mockSwapedDictionary, "Both elements should match")
    }
    
    func testSwapKeys_ForMultipleElements_ShouldCreateValidDictionary() {
        /// Given
        let sut = [["0,2,0,3,0,4": "soy"],
                   ["1,2,1,3": "el"],
                   ["2,2,2,3,2,4": "ella"]]
        
        let mockSwapedDictionary = [["0,2,0,3,0,4"],
                                    ["1,2,1,3"],
                                    ["2,2,2,3,2,4"]]
        
        /// When
        var arrayWithSwapedDictionaries = [[String]?]()
        
        for wordLocation in sut {
            arrayWithSwapedDictionaries.append(DUOLocation.returnArrayOfKeysFrom(wordLocation))
        }
        
        /// Then
        XCTAssertNotNil(arrayWithSwapedDictionaries, "The array with the inverted dictionaries should not be nil")
        XCTAssertEqual(arrayWithSwapedDictionaries, mockSwapedDictionary, "Both arrays should match")
    }
    
    func test_InitializerFor_Single_SelectedLocation_ShouldWorkAsExpected() {
        /// Given
        let wordLocation = [[[6,3],[6,4]]]
        
        /// When
        let sut = DUOLocation.init(selected_locations: wordLocation)
        
        /// Then
        XCTAssertNotNil(sut, "Initialized object should not be nil")
        XCTAssertEqual(sut.word_locations, wordLocation, "Selected word location should match")
    }
    
    func test_InitializerFor_Multiple_SelectedLocation_ShouldWorkAsExpected() {
        /// Given
        let wordLocation = [[[6,3],[6,4]],
                            [[5, 1], [5, 2], [5, 3], [5, 4]]]
        
        /// When
        let sut = DUOLocation.init(selected_locations: wordLocation)
        
        /// Then
        XCTAssertNotNil(sut, "Initialized object should not be nil")
        XCTAssertEqual(sut.word_locations, wordLocation, "Selected word location should match")
    }
}


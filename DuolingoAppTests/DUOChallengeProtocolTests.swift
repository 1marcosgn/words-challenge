//
//  DUOChallengeProtocolTests.swift
//  DuolingoAppTests
//
//  Created by Marcos Garcia on 12/14/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import XCTest

class DUOChallengeProtocolTests: XCTestCase {

    func test_ObjectThatConforms_DUOChallengeProtocol_ShouldHaveValidInformationWhenInitialized() {
        /// Given
        let dictionaryWithLocations = [["6,1,6,2,6,3,6,4,6,5,6,6": "hombre"]]
        let locationObject = [DUOLocation(word_locations: dictionaryWithLocations)]
        
        let mockGrid = [["i", "q", "u00ed", "l", "n", "n", "m", "u00f3"],
                        ["f", "t", "v", "u00f1", "b", "m", "h", "a"],
                        ["h", "j", "u00e9", "t", "e", "t", "o", "z"],
                        ["x", "u00e1", "o", "i", "e", "u00f1", "m", "u00e9"],
                        ["q", "u00e9", "i", "u00f3", "q", "s", "b", "s"],
                        ["c", "u", "m", "y", "v", "l", "r", "x"],
                        ["u00fc", "u00ed", "u00f3", "m", "o", "t", "e", "k"],
                        ["a", "g", "r", "n", "n", "u00f3", "s", "m"]]
        
        /// When
        let sut = MockChallenge.init(source_language: "en",
                                     word: "man",
                                     character_grid: mockGrid,
                                     word_locations: locationObject,
                                     target_language: "es")
        
        /// Then
        XCTAssertNotNil(sut, "Created object that conforms 'DUOChallengeProtocol' should not be nil")
        XCTAssertEqual(sut.source_language, "en", "Source language should be English for this test")
        XCTAssertEqual(sut.character_grid, mockGrid, "Character grid should match with the mock grid provided on this test")
        XCTAssertEqual(sut.word_locations, locationObject, "Both object should be the same")
        XCTAssertEqual(sut.target_language, "es", "The target language shoud be Spanish")
    }
    
    func test_ObjectThatConforms_DUOChallengeProtocol_ShouldBeAbleToBeUpdated() {
        /// Given
        let dictionaryWithLocations = [["6,1,6,2": "el"]]
        let locationObject = DUOLocation(word_locations: dictionaryWithLocations)
        
        let mockGrid = [["i", "q", "u00ed", "l", "n", "n", "m", "u00f3"],
                        ["f", "t", "v", "u00f1", "b", "m", "h", "a"],
                        ["h", "j", "u00e9", "t", "e", "t", "o", "z"],
                        ["x", "u00e1", "o", "i", "e", "u00f1", "m", "u00e9"]]
        
        /// When
        let sut = MockChallenge.init(source_language: "en",
                                     word: "him",
                                     character_grid: mockGrid,
                                     word_locations: [locationObject],
                                     target_language: "es")
        
        /// Then
        XCTAssertNotNil(sut, "Created object that conforms 'DUOChallengeProtocol' should not be nil")
        XCTAssertEqual(sut.source_language, "en", "Source language should be English for this test")
        
        sut.source_language = "fr"
        sut.target_language = "cn"
        
        XCTAssertEqual(sut.source_language, "fr", "Source language should be updated after assigning a new value")
        XCTAssertEqual(sut.target_language, "cn", "Source language should be updated after assigning a new value")
    }

}

class MockChallenge: DUOChallengeProtocol {
    var source_language: String
    var word: String
    var character_grid: [[String]]
    var word_locations: [DUOLocation]?
    var target_language: String
    
    init(source_language: String, word: String, character_grid: [[String]], word_locations: [DUOLocation]?, target_language: String) {
        self.source_language = source_language
        self.word = word
        self.character_grid = character_grid
        self.word_locations = word_locations
        self.target_language = target_language
    }
}


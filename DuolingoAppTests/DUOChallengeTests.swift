//
//  DUOChallengeTests.swift
//  DuolingoAppTests
//
//  Created by Marcos Garcia on 12/14/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import XCTest

class DUOChallengeTests: XCTestCase {

    func test_Initialized_DUOChallenge_ShouldHaveValidData() {
        /// Given
        let sut: DUOChallenge?
        let mockDictionary = getMockDictionary()
        let mockLocation = DUOLocation.init(word_locations: [["0,2,0,3,0,4": "soy"]])
        
        /// When
        sut = DUOChallenge.init(challenge: mockDictionary)
        
        /// Then
        XCTAssertNotNil(sut, "DUOChallenge object should not be nil")
        XCTAssertEqual(sut?.source_language, "en", "source_language should match with the information in the Dictionary")
        XCTAssertEqual(sut?.word, "am", "Word should match")
        XCTAssertEqual(sut?.character_grid, mockDictionary["character_grid"] as? [[String]], "Character grid should match")
        XCTAssertEqual(sut?.word_locations?.first?.word_locations, mockLocation.word_locations, "Location should match")
        XCTAssertEqual(sut?.target_language, "es", "Target language should match")
    }
    
    func test_setUpChallengeManager_ShouldHave_UpdatedProperties() {
        /// Given
        let sut = DUOChallenge.init(challenge: getMockDictionary())
        
        /// When
        sut.setUpChallengeManager()
        
        /// Then
        XCTAssertNotNil(DUOChallengeManager.sharedInstance, "Manager should not be nil")
        XCTAssertEqual(DUOChallengeManager.sharedInstance.targetsCount, sut.word_locations?.first?.word_locations?.count, "Number of targets should match")
        XCTAssertEqual(DUOChallengeManager.sharedInstance.targetWords, [sut.word], "Target Words should match")
        XCTAssertEqual(DUOChallengeManager.sharedInstance.challengeLocations?.first?.word_locations, sut.word_locations?.first?.word_locations, "Word locations should match")
    }
}

extension DUOChallengeTests {
    /// Returns a dictionary with mock information to test
    func getMockDictionary() -> [String: Any] {
        var mainDictionary = [String: Any]()
    
        mainDictionary["source_language"] = "en"
        mainDictionary["word"] = "am"
        mainDictionary["character_grid"] = [["d", "c", "e", "h", "p"],
                                            ["f", "e", "u00fc", "p", "t"],
                                            ["s", "s", "u00f3", "u00ed", "l"],
                                            ["o", "s", "u00ed", "u00f1", "a"],
                                            ["y", "g", "i", "o", "n"]]
        mainDictionary["word_locations"] = ["0,2,0,3,0,4": "soy"]
        mainDictionary["target_language"] = "es"
        
        return mainDictionary
    }
    
}


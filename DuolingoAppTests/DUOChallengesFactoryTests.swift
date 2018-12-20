//
//  DUOChallengesFactoryTests.swift
//  DuolingoAppTests
//
//  Created by Marcos Garcia on 12/15/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import XCTest

class DUOChallengesFactoryTests: XCTestCase {

    func test_ChallengesFactory_SharedInstance_ShouldBeValid() {
        /// Given
        let sut: DUOChallengesFactory?
        
        /// When
        sut = DUOChallengesFactory.shared()
        
        /// Then
        XCTAssertNotNil(sut, "Shared instance of DUOChallengeFactory should not be nil")
    }
    
    func test_getSingleChallenges_WithFactory_ShouldReturnValidChallenges() {
        /// Given
        var challenges = [DUOChallenge]()
        var challengesInfoArray = [[String: Any]]()
        let challengesDictionaryA = DUOChallengeTests.init().getMockDictionary()
        
        /// When
        challengesInfoArray.append(challengesDictionaryA)
        challenges = DUOChallengesFactory.shared().getChallenges(duoChallenges: challengesInfoArray)!
        
        /// Then
        XCTAssertNotNil(challenges, "Array of challenges should not be nil")
        XCTAssertEqual(challenges.count, 1, "Array of challenges should have 4 elements created")
    }
    
    func test_getMultipleChallenges_WithFactory_ShouldReturnValidChallenges() {
        /// Given
        var challenges = [DUOChallenge]()
        var challengesInfoArray = [[String: Any]]()
        let challengesDictionaryA = DUOChallengeTests.init().getMockDictionary()
        let challengesDictionaryB = DUOChallengeTests.init().getMockDictionary()
        let challengesDictionaryC = DUOChallengeTests.init().getMockDictionary()
        let challengesDictionaryD = DUOChallengeTests.init().getMockDictionary()
        
        /// When
        challengesInfoArray.append(challengesDictionaryA)
        challengesInfoArray.append(challengesDictionaryB)
        challengesInfoArray.append(challengesDictionaryC)
        challengesInfoArray.append(challengesDictionaryD)
        
        challenges = DUOChallengesFactory.shared().getChallenges(duoChallenges: challengesInfoArray)!
        
        /// Then
        XCTAssertNotNil(challenges, "Array of challenges should not be nil")
        XCTAssertEqual(challenges.count, 4, "Array of challenges should have 4 elements created")
    }
    
    func test_PropertiesOfCreated_ChallengeWithFactory_ShouldMatch_Information() {
        /// Given
        var sut: DUOChallenge?
        var challenges = [DUOChallenge]()
        var challengesInfoArray = [[String: Any]]()
        let challengesDictionaryA = DUOChallengeTests.init().getMockDictionary()
        let mockLocation = DUOLocation.init(word_locations: [["0,2,0,3,0,4": "soy"]])
        
        /// When
        challengesInfoArray.append(challengesDictionaryA)
        challenges = DUOChallengesFactory.shared().getChallenges(duoChallenges: challengesInfoArray)!
        sut = challenges.first
        
        /// Then
        XCTAssertNotNil(sut, "Test Challenge should not be nil")
        XCTAssertEqual(sut?.source_language, "en", "source_language should match with the information in the Dictionary")
        XCTAssertEqual(sut?.word, "am", "Word should match")
        XCTAssertEqual(sut?.character_grid, challengesDictionaryA["character_grid"] as? [[String]], "Character grid should match")
        XCTAssertEqual(sut?.word_locations?.first?.word_locations, mockLocation.word_locations, "Location should match")
        XCTAssertEqual(sut?.target_language, "es", "Target language should match")
    }
}


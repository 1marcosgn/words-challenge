//
//  DUOChallengeManagerTests.swift
//  DuolingoAppTests
//
//  Created by Marcos Garcia on 12/14/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import XCTest

class DUOChallengeManagerTests: XCTestCase {
    
    override func tearDown() {
        DUOChallengeManager.sharedInstance.reset()
    }

    func test_DUOChallengeManager_SharedInstance_ShouldNotBeNil() {
        /// Given
        let sut: DUOChallengeManager?
        
        /// When
        sut = DUOChallengeManager.sharedInstance
        
        /// Then
        XCTAssertNotNil(sut, "Shared instance of DUOChallengeManager should not be nil")
    }
    
    func test_DUOChallengeManager_OnlyOneInstance_CanBeCreated() {
        /// Given
        let sut = DUOChallengeManager.sharedInstance
        
        /// When
        let secondManager = DUOChallengeManager.sharedInstance
        
        /// Then
        XCTAssertNotNil(sut, "The first instance should not be nil")
        XCTAssertNotNil(secondManager, "the second manager instance called should not be nil")
        XCTAssertEqual(sut, secondManager, "Both instances of DUOChallengeManager should be the same")
    }

    func test_DUOChallengeManager_ShouldBeAbleToUpdate_AndKeepConsistent_targetsCount() {
        /// Given
        let sut = DUOChallengeManager.sharedInstance
        let secondManager = DUOChallengeManager.sharedInstance
        
        /// When
        sut.targetsCount = 1
        
        /// Then
        XCTAssertNotNil(sut.targetsCount, "Targets count should not be nil after set up")
        XCTAssertEqual(sut.targetsCount, 1, "Target count should match with the number provided")
        XCTAssertEqual(secondManager.targetsCount, sut.targetsCount, "Since both managers are the same instance the number of targets should match")
    }
    
    func test_DUOChallengeManager_ShouldBeAbleToUpdate_AndKeepConsistent_targetWords() {
        /// Given
        let sut = DUOChallengeManager.sharedInstance
        let secondManager = DUOChallengeManager.sharedInstance
        
        /// When
        sut.targetWords = ["el, ella"]
        
        /// Then
        XCTAssertNotNil(sut.targetWords, "Targets count should not be nil after set up")
        XCTAssertEqual(sut.targetWords, ["el, ella"], "Target words should match with the array provided")
        XCTAssertEqual(secondManager.targetWords, sut.targetWords, "Since both managers are the same instance the target words should match")
    }
    
    func test_DUOChallengeManager_ShouldBeAbleToUpdate_AndKeepConsistent_challengeLocations() {
        /// Given
        let sut = DUOChallengeManager.sharedInstance
        let secondManager = DUOChallengeManager.sharedInstance
        let wordLocation = [["0,2,0,3,0,4": "soy"]]
        let testLocation = DUOLocation.init(word_locations: wordLocation)
        
        /// When
        sut.challengeLocations = [testLocation]
        
        /// Then
        XCTAssertNotNil(sut.challengeLocations, "Challenge words location should not be nil")
        XCTAssertEqual(sut.challengeLocations, [testLocation], "Location in challenge should match with the location in this test")
        XCTAssertEqual(secondManager.challengeLocations, sut.challengeLocations, "Both locations should match")
    }
    
    func test_SelectedLocation_NOTUpdated_ShouldBeNil() {
        /// Given
        let sut: DUOChallengeManager?
        
        /// When
        sut = DUOChallengeManager.sharedInstance
        
        /// Then
        XCTAssertNil(sut?.selected_location, "Selected location not updated shoud be nil by default")
    }
    
    func test_SelectedLocation_Updated_WithUserSelection() {
        /// Given
        let sut = DUOChallengeManager.sharedInstance
        let wordLocation = [["0,2,0,3,0,4": "soy"]]
        let testLocation = DUOLocation.init(word_locations: wordLocation)
        
        /// When
        let matches = sut.challengeLocationMatchesWith(userSelection: testLocation)
        
        /// Then
        XCTAssertNotNil(matches, "Validation should not be nil")
        XCTAssertNotNil(sut.selected_location, "Selected location should not be nil after being initialized")
        XCTAssertEqual(sut.selected_location, testLocation, "Selected location should match the location provided as a parameter")
    }
    
    func test_CorrectSelectedLocation_ShouldMatch_ChallengeLocation() {
        /// Given
        let sut = DUOChallengeManager.sharedInstance
        let challengeLocation = [DUOLocation.init(word_locations: [["0,2,0,3,0,4": "soy"]])]
        let selectedLocation = DUOLocation.init(selected_locations: [[[0,2],[0,3],[0,4]]])
        
        /// When
        sut.challengeLocations = challengeLocation
        
        /// Then
        XCTAssertNotNil(sut.challengeLocations, "Locations should not be nil")
        XCTAssertTrue(sut.challengeLocationMatchesWith(userSelection: selectedLocation), "Locations should match")
    }
    
    func test_IncorrectSelectedLocation_ShouldNOTMatch_ChallengeLocation() {
        /// Given
        let sut = DUOChallengeManager.sharedInstance
        let challengeLocation = [DUOLocation.init(word_locations: [["0,2,0,3,0,4": "soy"]])]
        let selectedLocation = DUOLocation.init(selected_locations: [[[0,2],[0,3]]])
        
        /// When
        sut.challengeLocations = challengeLocation
        
        /// Then
        XCTAssertNotNil(sut.challengeLocations, "Locations should not be nil")
        XCTAssertFalse(sut.challengeLocationMatchesWith(userSelection: selectedLocation), "Locations should match")
    }
    
    func test_DUOChallengeManager_ShouldBeAbleTo_Reset() {
        /// Given
        let sut = DUOChallengeManager.sharedInstance
        sut.targetsCount = 3
        sut.targetWords = ["el","ella","soy"]
        sut.challengeLocations = [DUOLocation.init(word_locations: [["0,2,0,3,0,4": "soy"]])]
        sut.selected_location = DUOLocation.init(selected_locations: [[[0,2],[0,3]]])
        
        /// When
        sut.reset()
        
        /// Then
        XCTAssertEqual(sut.targetsCount, 0, "Number of targets should be reset to 0")
        XCTAssertNil(sut.targetWords, "Array of words should be nil after reset")
        XCTAssertNil(sut.challengeLocations, "Challenge location should be nil after reset")
        XCTAssertNil(sut.selected_location, "Selected location should be nil after reset")
    }
}


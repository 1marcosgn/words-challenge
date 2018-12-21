//
//  DUOChallengeViewModelTests.swift
//  DuolingoAppTests
//
//  Created by Marcos Garcia on 12/16/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import XCTest

class DUOChallengeViewModelTests: XCTestCase {

    func test_getArraOfWordsFromatted_ShouldReturn_ArrayOfWords_Formatted() {
        /// Given
        let mockChallenge = DUOChallenge.init(challenge: DUOChallengeTests().getMockDictionary())
        let sut = DUOChallengeViewModel(challenge: mockChallenge)

        /// When
        let arrayOfWords = sut.getArrayOfWordsFromatted()
        
        /// Then
        XCTAssertNotNil(arrayOfWords, "Array of word should not be nil")
        XCTAssertEqual(arrayOfWords.first, "d", "First element should match")
        XCTAssertEqual(arrayOfWords.last, "n", "Last element should match")
    }
    
    func test_setUpArrayOfLocations_Should_Generate_ValidArrayOf_XY_Locations() {
        /// Given
        let mockChallenge = DUOChallenge.init(challenge: DUOChallengeTests().getMockDictionary())
        let sut = DUOChallengeViewModel(challenge: mockChallenge)
        
        /// When
        sut.setUpArrayOfLocations()
        
        /// Then
        XCTAssertNotNil(sut.arrayOfLocations, "Array of locations should not be nil")
        XCTAssertEqual(sut.arrayOfLocations?[0], [0,0], "Location should match")
        XCTAssertEqual(sut.arrayOfLocations?[3], [3, 0], "Location should match")
        XCTAssertEqual(sut.arrayOfLocations?[13], [3, 2], "Location should match")
    }
    
    func test_getNumberOfSections_ShouldReturn_Correct_Number() {
        /// Given
        let mockChallenge = DUOChallenge.init(challenge: DUOChallengeTests().getMockDictionary())
        
        /// When
        let sut = DUOChallengeViewModel.init(challenge: mockChallenge)
        
        /// Then
        XCTAssertNotNil(sut.getNumberOfSections(), "Number of sections should not be nil")
        XCTAssertEqual(sut.getNumberOfSections(), 5, "Number of sections should match")
    }
    
    func test_setUpSections_Should_Contain_ValidElements() {
        /// Given
        let mockChallenge = DUOChallenge.init(challenge: DUOChallengeTests().getMockDictionary())
        
        /// When
        let sut = DUOChallengeViewModel.init(challenge: mockChallenge)
        
        /// Then
        XCTAssertNotNil(sut.arrayOfSections, "The array of sections should not be nil")
        XCTAssertEqual(sut.arrayOfSections?.count, 5, "Number of sections should match")
        XCTAssertEqual(sut.arrayOfSections?.first, ["d", "c", "e", "h", "p"], "Elements should match")
    }
    
    func test_setUpLocationSections_Configured_Array_ShouldContain_CorrectInformation() {
        /// Given
        let mockChallenge = DUOChallenge.init(challenge: DUOChallengeTests().getMockDictionary())
        let sut = DUOChallengeViewModel.init(challenge: mockChallenge)
        
        /// When
        sut.setUpLocationSections()
        
        /// Then
        XCTAssertNotNil(sut.arrayOfLocationSections, "Array of locations should not be nil")
        XCTAssertEqual(sut.arrayOfLocationSections?.first, [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0]], "Locations for section should match")
        XCTAssertEqual(sut.arrayOfLocationSections?.last, [[0, 4], [1, 4], [2, 4], [3, 4], [4, 4]], "Locations for section should match")
    }
}


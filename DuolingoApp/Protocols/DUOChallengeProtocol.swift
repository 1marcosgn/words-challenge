//
//  DUOChallengeProtocol.swift
//  DuolingoApp
//
//  Created by Marcos Garcia on 12/14/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import UIKit

/// Protocol to handle the Challenge properties
public protocol DUOChallengeProtocol: class {
    /// The native language of the Challenge
    var source_language: String { get set }
    
    /// The source word
    var word: String { get set }
    
    /// Array to build the character grid to be shown
    var character_grid: [[String]] { get set }
    
    /// An array that contains the location of the translations
    var word_locations: [DUOLocation]? { get set }
    
    /// The target language of the Challenge
    var target_language: String { get set }
}


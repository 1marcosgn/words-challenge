//
//  DUOCollectionViewCell.swift
//  DuolingoApp
//
//  Collection View Cell to display the words in the Grid
//
//  Created by Marcos Garcia on 12/15/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import UIKit

class DUOCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var wordLabel: UILabel!
    public var position = [Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


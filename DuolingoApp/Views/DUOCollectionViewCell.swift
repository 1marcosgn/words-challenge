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
    
    let selectedColor = UIColor.init(red: 200.0/255.0, green: 239.0/255.0, blue: 159.0/255.0, alpha: 1.0)
    let nonSelectedColor = UIColor.init(red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 1.0)
    
    
    @IBOutlet weak var wordLabel: UILabel!
    public var position = [Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? selectedColor : nonSelectedColor
        }
    }
}


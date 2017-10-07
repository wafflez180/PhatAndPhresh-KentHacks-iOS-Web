//
//  SavedRapCollectionViewCell.swift
//  PhatAndPhresh
//
//  Created by Arthur De Araujo on 10/7/17.
//  Copyright © 2017 Arthur De Araujo. All rights reserved.
//

import UIKit

class SavedRapCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var title: UILabel!
    
    class func instanceFromNib() -> SavedRapCollectionViewCell {
        return UINib(nibName: "SavedRapCollectionViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SavedRapCollectionViewCell
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
    }

}

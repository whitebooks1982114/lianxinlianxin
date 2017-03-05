

//
//  CardCellCollectionViewCell.swift
//  廉兴连心
//
//  Created by whitebooks on 17/2/26.
//  Copyright © 2017年 whitebooks. All rights reserved.
//

import UIKit

class CardCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var testTitle: UILabel!
    
    @IBOutlet weak var testLevels: UILabel!
    
    @IBOutlet weak var testScore: UILabel!
    
    @IBOutlet weak var partyImage: UIImageView!
    @IBOutlet weak var myContentView: UIView!
    
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        testTitle.adjustsFontSizeToFitWidth = true
        testLevels.adjustsFontSizeToFitWidth = true
        
        myContentView.layer.cornerRadius = 10
        myContentView.clipsToBounds = true
        partyImage.isHidden = true
        
       
        
        
    }

}

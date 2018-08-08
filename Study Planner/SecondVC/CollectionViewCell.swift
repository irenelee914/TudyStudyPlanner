//
//  CollectionViewCell.swift
//  Study Planner
//
//  Created by Hojoon Lee on 2018-08-06.
//  Copyright © 2018 Irene Lee. All rights reserved.
//

import UIKit
import UICircularProgressRing

class CollectionViewCell: UICollectionViewCell {

    var uiColorArray = [UIColor]()
    var averageMark : Float = 0.0
    
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progressRing.maxValue = 100
        guard let customFont = UIFont(name:"OpenSans-Light", size: 25) else {
            fatalError("Failed")
        }
        progressRing.font = customFont
        progressRing.valueIndicator = " %"
        
        uiColorArray.append(UIColor(hexString: "#4568DC")!)
        uiColorArray.append(UIColor(hexString: "#B06AB3")!)
       // uiColorArray.append(UIColor(hexString: "#91EAE4")!)
        
        progressRing.gradientColors = uiColorArray

        
        
        
        
        cellView.layer.cornerRadius = 6
        cellView.layer.masksToBounds = true
        super.awakeFromNib()

        self.backView.layer.borderWidth = 2
        self.backView.layer.cornerRadius = 3
        self.backView.layer.borderColor = UIColor.clear.cgColor
        self.backView.layer.masksToBounds = true
        self.layer.shadowOpacity = 0.28
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        

        
    }

}

//
//  GradesCell.swift
//  Study Planner
//
//  Created by Hojoon Lee on 2018-08-08.
//  Copyright © 2018 Irene Lee. All rights reserved.
//

import UIKit

protocol GradesCellDelegate : class{
    func deleteMark(selectedGrade : Grades)
}


class GradesCell: UICollectionViewCell {
    
    var selectedGrade : Grades?
    weak var delegate: GradesCellDelegate?
    @IBOutlet weak var cellIndex: UILabel!
    @IBOutlet weak var gradeName: UILabel!
    @IBOutlet weak var grade: UILabel!
    @IBAction func deleteMark(_ sender: UIButton) {
    
        self.delegate?.deleteMark(selectedGrade : selectedGrade!)
    }
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var weighting: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 6
        cellView.layer.masksToBounds = true
        
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

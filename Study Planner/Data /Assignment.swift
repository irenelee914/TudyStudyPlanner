//
//  Assignment.swift
//  Study Planner
//
//  Created by Hojoon Lee on 2018-07-20.
//  Copyright © 2018 Irene Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Assignment: Object {
    @objc dynamic var nameOfAssignment: String = ""
    
    @objc dynamic var dueDate: String = ""
    @objc dynamic var daysLeft: Int = 0
    @objc dynamic var startDate: String = ""
    @objc dynamic var notes: String = ""
   // @objc dynamic var repeats: Bool = false
    @objc dynamic var weighting: Float = 0.0
    @objc dynamic var dateCreated: Date?
    
    
    
    //var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

//
//  Category.swift
//  Study Planner
//
//  Created by Hojoon Lee on 2018-07-20.
//  Copyright © 2018 Irene Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var nameOfCategory: String = ""
    @objc dynamic var repeats: String = ""
    @objc dynamic var dateCreated: String = ""
    @objc dynamic var notes: String = ""
    @objc dynamic var colour: String = ""
    @objc dynamic var underWhichDate: String = ""
    ///////////////////////////////////////////////////////////////
    @objc dynamic var isAssignment: Bool = false
    @objc dynamic var nameOfAssignment: String = ""
    @objc dynamic var assignmentDueDate: String = ""
    @objc dynamic var assignmentDaysLeft: Int = 0
    @objc dynamic var assignmentStartDate: String = ""
    @objc dynamic var assignmentTag: String = ""
    @objc dynamic var assignmentNotes: String = ""
    // @objc dynamic var repeats: Bool = false
    @objc dynamic var assignmentWeighting: Float = 0.0
    @objc dynamic var assignmentDateCreated: Date?
    
    @objc dynamic var assignmentStartDateInDays: Int = 0
    @objc dynamic var assignmentDateDueInDays: Int = 0
    
    let theTasks = List<Todo>()

}

//
//  Assignment.swift
//  Study Planner
//
//  Created by Hojoon Lee on 2018-07-20.
//  Copyright © 2018 Irene Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Course: Object {
    @objc dynamic var nameOfCourse: String = ""
    @objc dynamic var courseAverage: Float = 0.0

    let theGrades = List<Grades>()
    
    //var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

//
//  Event.swift
//  Study Planner
//
//  Created by Hojoon Lee on 2018-07-20.
//  Copyright © 2018 Irene Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Grades: Object {
    @objc dynamic var nameOfGrade: String = ""
    @objc dynamic var weighting: Float = 0.0
    @objc dynamic var mark: Float = 0.0
    @objc dynamic var dateCreated: Date?
    //var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

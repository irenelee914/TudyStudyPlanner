//
//  Todo.swift
//  Study Planner
//
//  Created by Hojoon Lee on 2018-07-22.
//  Copyright © 2018 Irene Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Todo: Object {
    @objc dynamic var todoName : String = ""
    @objc dynamic var todoDone: Bool = false
    
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "theTasks")
}

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
    
    let theTasks = List<Todo>()

}

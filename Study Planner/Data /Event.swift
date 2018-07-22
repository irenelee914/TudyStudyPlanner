//
//  Event.swift
//  Study Planner
//
//  Created by Hojoon Lee on 2018-07-20.
//  Copyright © 2018 Irene Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Event: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

//
//  Item.swift
//  Todoey
//
//  Created by Cem Akkaya on 16/03/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted var dateCreated: Date?
    @Persisted(originProperty: "items") var parentCategory: LinkingObjects<Category>
}

//
//  Category.swift
//  Todoey
//
//  Created by Cem Akkaya on 16/03/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name: String = ""
    @Persisted var color: String = ""
    @Persisted var items = List<Item>()
}

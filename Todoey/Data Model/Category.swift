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
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

//
//  DatabaseManager.swift
//  Todoey
//
//  Created by Cem Akkaya on 17/03/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    let realm = try! Realm()
    private init() {}
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Category Methods
    
    func fetchCategories() -> Results<Category> {
        return realm.objects(Category.self)
    }
    
    func delete(category: Category) {
        do {
            try realm.write {
                realm.delete(category.items)
                realm.delete(category)
            }
        } catch {
            print("An error occurred while deleting the category: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Item Methods
    
    func save(item: Item, to category: Category) {
        do {
            try realm.write {
                category.items.append(item)
            }
        } catch {
            print("An error occurred while saving the item: \(error.localizedDescription)")
        }
    }
    
    func updateItemStatus(item: Item) {
        do {
            try realm.write {
                item.done.toggle()
            }
        } catch {
            print("An error occurred while updating the item: \(error.localizedDescription)")
        }
    }
    
    func delete(item: Item) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("An error occurred while deleting the item: \(error.localizedDescription)")
        }
    }
    
    func searchItems(in category: Category, with text: String) -> Results<Item> {
        return category.items.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "dataCreated", ascending: true)
    }
}

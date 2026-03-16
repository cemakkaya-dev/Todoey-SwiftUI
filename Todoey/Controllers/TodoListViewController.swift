//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorEffect = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "\(selectedCategory!.name)"
        
        if let categoryColorHex = selectedCategory?.color {
            if let navBarColor = UIColor(hexString: categoryColorHex) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = navBarColor
                searchBar.barTintColor = navBarColor
                tableView.backgroundColor = navBarColor
                
                let contrastColor = navBarColor.contrastingText()
                appearance.titleTextAttributes = [.foregroundColor: contrastColor]
                
                navigationController?.navigationBar.standardAppearance = appearance
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
                
                navigationController?.navigationBar.tintColor = contrastColor
            }
        }
    }
    
    
    // MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let totalItemCount = CGFloat(todoItems?.count ?? 0)
        
        if let item = todoItems?[indexPath.row] {
            if let categoryColorHex = selectedCategory?.color {
                if let baseColor = UIColor(hexString: categoryColorHex) {
                    let cellColorPercentage = (CGFloat(indexPath.row) / totalItemCount) * 80
                    
                    if let cellColor = baseColor.lighter(by: cellColorPercentage) {
                        cell.backgroundColor = cellColor
                        
                        cell.textLabel?.textColor = cellColor.contrastingText()
                        cell.textLabel?.text = item.title
                        
                        cell.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
                        
                        if item.done{
                            cell.tintColor = cellColor.contrastingText()
                        }
                        cell.accessoryType = item.done ? .checkmark : .none
                    }
                }
            }
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems? [indexPath.row] {
            do{
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // MARK: - Model Manupulation Methods
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    // MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
                tableView.deleteRows(at: [indexPath], with: .left)
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}

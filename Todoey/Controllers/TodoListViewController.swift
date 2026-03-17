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
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorEffect = .none
        setupNavigationBar()
    }
    
    // MARK: - UI Setup Methods
    
    private func setupNavigationBar() {
        guard
            let categoryHex = selectedCategory?.color,
            let navBarColor = UIColor(hexString: categoryHex)
        else { return }
        
        title = selectedCategory?.name
        
        let contrastColor = navBarColor.contrastingText()
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = navBarColor
        appearance.titleTextAttributes = [.foregroundColor: contrastColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: contrastColor]
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        navigationController?.navigationBar.tintColor = contrastColor
        
        searchBar.barTintColor = navBarColor
        searchBar.tintColor = contrastColor
        tableView.backgroundColor = navBarColor
        
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
            DatabaseManager.shared.updateItemStatus(item: item)
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        presentAddAlert(title: "Add New Todoey Item", placeholder: "Create new item") { newItemTitle in
            if let currentCategory = self.selectedCategory {
                let newItem = Item()
                newItem.title = newItemTitle
                newItem.dateCreated = Date()
                
                DatabaseManager.shared.save(item: newItem, to: currentCategory)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Model Manupulation Methods
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            DatabaseManager.shared.delete(item: itemForDeletion)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

// MARK: - Search Bar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            if let category = selectedCategory {
                todoItems = DatabaseManager.shared.searchItems(in: category, with: searchBar.text!)
                tableView.reloadData()
            }
        }
    }
}

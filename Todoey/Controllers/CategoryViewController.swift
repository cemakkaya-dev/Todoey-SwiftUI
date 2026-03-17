//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Cem Akkaya on 22/02/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    var categories: Results<Category>?
    var lastSelectedColorHex: String?
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
            loadCategories()
            updateNavBar(with: "1D9BF6")
        }
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            if let categoryColor = UIColor(hexString: category.color) {
                cell.backgroundColor = categoryColor
                cell.textLabel?.textColor = categoryColor.contrastingText()
            }
        } else {
            cell.textLabel?.text = "No Categories Added Yet."
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let category = categories?[indexPath.row]
                destinationVC.selectedCategory = category
                
                // İŞTE SİHİR BURADA: Kullanıcı diğer sayfaya geçerken rengi güncelliyoruz!
                if let colorHex = category?.color {
                    self.lastSelectedColorHex = colorHex
                    self.updateNavBar(with: colorHex)
                }
            }
        }
    
    
    // MARK: - Data Manipulation Methods
    
    func loadCategories() {
        categories = DatabaseManager.shared.fetchCategories()
        tableView.reloadData()
    }
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            DatabaseManager.shared.delete(category: categoryForDeletion)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    // MARK: - Add New Categories
    @IBAction func addButtondPressed(_ sender: UIBarButtonItem) {
        presentAddAlert(title: "Add New Category", placeholder: "Create new category") { newCategoryName in
            let newCategory = Category()
            newCategory.name = newCategoryName
            newCategory.color = UIColor.randomFlat().hexValue()
            
            DatabaseManager.shared.save(category: newCategory)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation Bar Colors
    
    private func updateNavBar(with hexCode: String) {
        guard let navBarColor = UIColor(hexString: hexCode) else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = navBarColor
        
        let contrastColor = navBarColor.contrastingText()
        appearance.titleTextAttributes = [.foregroundColor: contrastColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: contrastColor]
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        navigationController?.navigationBar.tintColor = contrastColor
    }
}

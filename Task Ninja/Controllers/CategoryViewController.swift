//
//  CategoryViewController.swift
//  Task Ninja
//
//  Created by Tam Le on 10/11/24.
//

import UIKit

class CategoryViewController: SwipeTableViewController {
    
    let dataManager: DataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.readDatabaseEntityCategory()
    }
    
    override func deleteDatabaseEntity(indexPath: IndexPath) {
        dataManager.deleteDatabaseEntityCategory(index: indexPath.row)
        dataManager.readDatabaseEntityCategory()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let safeCategoryArray = dataManager.categoryArray {
            cell.backgroundColor = UIColor(safeCategoryArray[indexPath.row].cellBackgroundColorHexString!)
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = safeCategoryArray[indexPath.row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.categoryArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataManager.categoryArray != nil {
            performSegue(withIdentifier: "segueCategoryToItem", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCategoryToItem" {
            let destinationViewController = segue.destination as! ItemViewController
            if let indexPathSelected = tableView.indexPathForSelectedRow {
                destinationViewController.dataManager.categorySelected = dataManager.categoryArray![indexPathSelected.row]
            }
        }
    }
    
}

//MARK: - Add Button Method

extension CategoryViewController {
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var inputTextField = UITextField()
        let alert = UIAlertController(title: "Add New Category:", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            if let safeText = inputTextField.text {
                if safeText != "" {
                    self.dataManager.createDatabaseEntityCategory(name: safeText.capitalized)
                    self.dataManager.readDatabaseEntityCategory()
                    self.tableView.reloadData()
                }
            }
        }
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Category"
            inputTextField = alertTextField
        }
        present(alert, animated: true) { }
    }
    
}

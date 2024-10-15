//
//  CategoryViewController.swift
//  Task Ninja
//
//  Created by Tam Le on 10/11/24.
//

import UIKit

class CategoryViewController: BaseTableViewController {
    
    let dataManager: DataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.readDatabaseEntityCategory()
        tableView.reloadData()
    }
    
    override func updateDatabaseEntity(indexPath: IndexPath) {
        editDatabaseEntityCategory(index: indexPath.row)
    }
    
    override func deleteDatabaseEntity(indexPath: IndexPath) {
        dataManager.deleteDatabaseEntityCategory(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let safeCategoryArray = dataManager.categoryArray {
            cell.backgroundColor = UIColor(safeCategoryArray[indexPath.row].cellBackgroundColorHexString!)
            cell.textLabel?.textColor = cell.backgroundColor!.isLight ? .black : .white
            cell.textLabel?.text = safeCategoryArray[indexPath.row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.categoryArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueCategoryToItem", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCategoryToItem" {
            let destinationViewController = segue.destination as! ItemViewController
            destinationViewController.dataManager.categorySelected = dataManager.categoryArray![tableView.indexPathForSelectedRow!.row]
        }
    }
    
}

//MARK: - Add Button Method

extension CategoryViewController {
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var inputTextField = UITextField()
        let alert = UIAlertController(title: "Add New Category:", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Category", style: .default) { action in
            guard let safeText = inputTextField.text else { return }
            if safeText != "" {
                self.dataManager.createDatabaseEntityCategory(name: safeText.capitalized) ? self.tableView.reloadData() : self.invalidResponseAddPressed(message: "Category already exists.")
            } else {
                self.invalidResponseAddPressed(message: "Response is empty.")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in return }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Category"
            inputTextField = alertTextField
        }
        present(alert, animated: true) { }
    }
    
    func editDatabaseEntityCategory(index: Int) {
        var inputTextField = UITextField()
        let alert = UIAlertController(title: "Edit Current Category:", message: "", preferredStyle: .alert)
        let editAction = UIAlertAction(title: "Edit Category", style: .default) { action in
            guard let safeText = inputTextField.text else { return }
            if safeText != "" {
                self.dataManager.updateDatabaseEntityCategory(index: index, newName: safeText) ? self.tableView.reloadData() : self.invalidResponseAddPressed(message: "Category already exists.")
            } else {
                self.invalidResponseAddPressed(message: "Response is empty.")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in return }
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Edit Current Category"
            alertTextField.text = self.dataManager.categoryArray![index].name
            inputTextField = alertTextField
        }
        present(alert, animated: true) { }
    }
    
}

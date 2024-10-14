//
//  ItemViewController.swift
//  Task Ninja
//
//  Created by Tam Le on 10/11/24.
//

import UIKit

class ItemViewController: BaseTableViewController {
    
    let dataManager: DataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.readDatabaseEntityItem()
    }
    
    override func deleteDatabaseEntity(indexPath: IndexPath) {
        dataManager.deleteDatabaseEntityItem(index: indexPath.row)
        dataManager.readDatabaseEntityItem()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let safeItemArray = dataManager.itemArray, let safeCategorySelected = dataManager.categorySelected {
            let categorySelectedBackgroundColor = UIColor(safeCategorySelected.cellBackgroundColorHexString!)
            let newAlpha = 0.50 + CGFloat(indexPath.row + 1) * (1.00 - 0.50) / CGFloat(dataManager.itemArray!.count)
            cell.backgroundColor = UIColor(safeCategorySelected.cellBackgroundColorHexString!).withAlphaComponent(newAlpha)
            cell.textLabel?.textColor = categorySelectedBackgroundColor.isLight ? .black : .white
            cell.textLabel?.text = safeItemArray[indexPath.row].name
            cell.accessoryType = safeItemArray[indexPath.row].isDone ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.itemArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if dataManager.itemArray != nil {
            dataManager.updateDatabaseEntityItem(index: indexPath.row)
            dataManager.readDatabaseEntityItem()
            tableView.reloadData()
        }
    }
    
}

// MARK: - Add Button Method

extension ItemViewController {
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var inputTextField = UITextField()
        let alert = UIAlertController(title: "Add New Item:", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let safeText = inputTextField.text {
                if safeText != "" {
                    self.dataManager.createDatabaseEntityItem(name: safeText.capitalized)
                    self.dataManager.readDatabaseEntityItem()
                    self.tableView.reloadData()
                }
            }
        }
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            inputTextField = alertTextField
        }
        present(alert, animated: true) { }
    }
    
}

//MARK: - UISearchBarDelegate

extension ItemViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dataManager.readDatabaseEntityItem(searchBarText: searchBar.text ?? "")
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.dataManager.readDatabaseEntityItem(searchBarText: searchText)
            self.tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

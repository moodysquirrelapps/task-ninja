//
//  ItemViewController.swift
//  Task Ninja
//
//  Created by Tam Le on 10/11/24.
//

import UIKit

class ItemViewController: SwipeTableViewController {
    
    let dataManager: DataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.readDatabaseEntityItem()
        tableView.reloadData()
    }
    
    override func deleteDatabaseEntity(indexPath: IndexPath) {
        dataManager.deleteDatabaseEntityItem(index: indexPath.row)
        dataManager.readDatabaseEntityItem()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let newAlpha = dataManager.itemArray == nil ? CGFloat(0.0) : CGFloat(indexPath.row + 1) / CGFloat(dataManager.itemArray!.count)
        cell.backgroundColor = UIColor(dataManager.categorySelected?.cellBackgroundColorHexString ?? "#00000000").withAlphaComponent(newAlpha)
        cell.textLabel?.textColor = newAlpha <= 0.50 ? .black : .white
        cell.textLabel?.text = dataManager.itemArray?[indexPath.row].name ?? "No items added yet."
        cell.accessoryType = (dataManager.itemArray?[indexPath.row].isDone ?? false) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataManager.itemArray != nil {
            dataManager.updateDatabaseEntityItem(index: indexPath.row)
            tableView.cellForRow(at: indexPath)?.accessoryType = dataManager.itemArray![indexPath.row].isDone ? .checkmark : .none
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
        self.dataManager.readDatabaseEntityItem(searchBarText: searchBar.text ?? "")
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.dataManager.readDatabaseEntityItem(searchBarText: searchText)
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

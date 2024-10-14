//
//  ItemViewController.swift
//  Task Ninja
//
//  Created by Tam Le on 10/11/24.
//

import UIKit

class ItemViewController: BaseTableViewController {
    
    let dataManager: DataManager = DataManager()
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.readDatabaseEntityItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = dataManager.categorySelected!.name
        guard let navBar = navigationController?.navigationBar else { fatalError("itemVC error: Navigation Bar is nil.") }
        let backgroundColor = UIColor(dataManager.categorySelected!.cellBackgroundColorHexString!)
        navBar.backgroundColor = backgroundColor
        let tintColor = backgroundColor.isLight ? UIColor.black : UIColor.white
        navBar.tintColor = tintColor
        navBar.largeTitleTextAttributes = [.foregroundColor: tintColor]
        navigationItem.rightBarButtonItem?.tintColor = tintColor
        searchBar.barTintColor = backgroundColor
        searchBar.searchTextField.backgroundColor = .white
    }
    
    override func deleteDatabaseEntity(indexPath: IndexPath) {
        dataManager.deleteDatabaseEntityItem(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let safeItemArray = dataManager.itemArray, let categorySelected = dataManager.categorySelected {
            let newAlpha = CGFloat(0.50 +  Float(indexPath.row + 1) * (1.00 - 0.50) / Float(safeItemArray.count))
            cell.backgroundColor = UIColor(categorySelected.cellBackgroundColorHexString!).withAlphaComponent(newAlpha)
            cell.textLabel?.textColor = cell.backgroundColor!.isLight ? .black : .white
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

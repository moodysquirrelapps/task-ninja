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
        backgroundColor = UIColor(dataManager.categorySelected!.cellBackgroundColorHexString!)
        tintColor = backgroundColor.isLight ? UIColor.black : UIColor.white
        dataManager.readDatabaseEntityItem()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = dataManager.categorySelected!.name
        searchBar.searchTextField.font = smallFont
        searchBar.barTintColor = backgroundColor
        searchBar.searchTextField.backgroundColor = .white
    }
    
    override func updateDatabaseEntity(indexPath: IndexPath) {
        editDatabaseEntityItem(index: indexPath.row)
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
            cell.detailTextLabel?.textColor = cell.backgroundColor!.isLight ? .black : .white
            cell.detailTextLabel?.text =  "Created: " + dataManager.dateToString(date: safeItemArray[indexPath.row].date!)
            cell.accessoryView = safeItemArray[indexPath.row].isDone ? UIImageView(image: UIImage(systemName: "checkmark.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22.0))) : UIImageView(image: UIImage(systemName: "square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22.0)))
            cell.tintColor = cell.backgroundColor!.isLight ? .black : .white
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemArrayCount = dataManager.itemArray?.count ?? 0
        (itemArrayCount == 0) ? setEmptyMessage(message: "No items added yet.") : restore()
        return itemArrayCount
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataManager.itemArray != nil {
            _ = dataManager.updateDatabaseEntityItem(index: indexPath.row)
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Add Button Method

extension ItemViewController {
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var inputTextField = UITextField()
        let alert = UIAlertController(title: "Add New Item:", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            guard let safeText = inputTextField.text else { return }
            if safeText != "" {
                self.dataManager.createDatabaseEntityItem(name: safeText.capitalized) ? self.tableView.reloadData() : self.invalidResponseAddPressed(message: "Item already exists.")
            } else {
                self.invalidResponseAddPressed(message: "Response is empty.")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in return }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            inputTextField = alertTextField
        }
        present(alert, animated: true) { }
    }
    
    func editDatabaseEntityItem(index: Int) {
        var inputTextField = UITextField()
        let alert = UIAlertController(title: "Edit Current Item:", message: "", preferredStyle: .alert)
        let editAction = UIAlertAction(title: "Edit Item", style: .default) { action in
            guard let safeText = inputTextField.text else { return }
            if safeText != "" {
                self.dataManager.updateDatabaseEntityItem(index: index, newName: safeText) ? self.tableView.reloadData() : self.invalidResponseAddPressed(message: "Item already exists.")
            } else {
                self.invalidResponseAddPressed(message: "Response is empty.")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in return }
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Edit Current Item"
            alertTextField.text = self.dataManager.itemArray![index].name
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

//
//  ItemViewController.swift
//  Task Ninja
//
//  Created by Tam Le on 10/11/24.
//

import UIKit

class ItemViewController: BaseTableViewController {
    
    let dataManager: DataManager = DataManager()
    var segmentedControlValue: String = "Active"
    var searchBarText: String = ""
    @IBOutlet weak var uiViewBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor = UIColor(dataManager.categorySelected!.cellBackgroundColorHexString!)
        tintColor = backgroundColor.isLight ? UIColor.black : UIColor.white
        dataManager.readDatabaseEntityItem(withSearch: searchBarText, withControl: segmentedControlValue)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = dataManager.categorySelected!.name
        uiViewBar.backgroundColor = backgroundColor
        // Search Bar
        searchBar.searchTextField.font = smallFont
        searchBar.barTintColor = backgroundColor
        searchBar.searchTextField.backgroundColor = .white
        // Segmented Control
        segmentedControl.backgroundColor = backgroundColor
        segmentedControl.selectedSegmentTintColor = .white.withAlphaComponent(0.50)
        segmentedControl.setTitleTextAttributes([.foregroundColor: tintColor, .font: smallFont], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: tintColor, .font: smallFont], for: .selected)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let safeItemArray = dataManager.itemArray, let categorySelected = dataManager.categorySelected {
            let newAlpha = CGFloat(0.50 +  Float(indexPath.row + 1) * (1.00 - 0.50) / Float(safeItemArray.count))
            cell.backgroundColor = UIColor(categorySelected.cellBackgroundColorHexString!).withAlphaComponent(newAlpha)
            cell.textLabel?.textColor = cell.backgroundColor!.isLight ? .black : .white
            cell.textLabel?.text = safeItemArray[indexPath.row].name
            cell.detailTextLabel?.textColor = cell.backgroundColor!.isLight ? .black : .white
            cell.detailTextLabel?.text =  "Created: " + dataManager.dateToString(date: safeItemArray[indexPath.row].creationDate!)
            cell.detailTextLabel?.text = safeItemArray[indexPath.row].isDone ?
            ("Completed: " + dataManager.dateToString(date: safeItemArray[indexPath.row].completionDate!) + "\n" + cell.detailTextLabel!.text!) :
            cell.detailTextLabel?.text
            cell.accessoryView = safeItemArray[indexPath.row].isDone ?
            UIImageView(image: UIImage(systemName: "checkmark.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22.0))) :
            UIImageView(image: UIImage(systemName: "square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22.0)))
            cell.tintColor = cell.backgroundColor!.isLight ? .black : .white
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemArrayCount = dataManager.itemArray?.count ?? 0
        (itemArrayCount == 0) ? setEmptyMessage(message: "No items found.") : restore()
        return itemArrayCount
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataManager.itemArray != nil {
            _ = dataManager.updateDatabaseEntityItem(index: indexPath.row)
            dataManager.readDatabaseEntityItem(withSearch: searchBarText, withControl: segmentedControlValue)
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func updateDatabaseEntity(indexPath: IndexPath) {
        editDatabaseEntityItem(index: indexPath.row)
        dataManager.readDatabaseEntityItem(withSearch: searchBarText, withControl: segmentedControlValue)
    }
    
    override func deleteDatabaseEntity(indexPath: IndexPath) {
        dataManager.deleteDatabaseEntityItem(index: indexPath.row)
        dataManager.readDatabaseEntityItem(withSearch: searchBarText, withControl: segmentedControlValue)
    }
    
}

// MARK: - Add And Edit Button Methods

extension ItemViewController {
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var inputTextField = UITextField()
        let alert = UIAlertController(title: "Add New Item:", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            guard let safeText = inputTextField.text else { return }
            if safeText != "" {
                self.dataManager.createDatabaseEntityItem(name: safeText.capitalized) ?
                self.dataManager.readDatabaseEntityItem(withSearch: self.searchBarText, withControl: self.segmentedControlValue) :
                self.invalidResponseAddPressed(message: "Item already exists.")
            } else {
                self.invalidResponseAddPressed(message: "Response is empty.")
            }
            self.tableView.reloadData()
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
                self.dataManager.updateDatabaseEntityItem(index: index, newName: safeText) ?
                self.dataManager.readDatabaseEntityItem(withSearch: self.searchBarText, withControl: self.segmentedControlValue) :
                self.invalidResponseAddPressed(message: "Item already exists.")
            } else {
                self.invalidResponseAddPressed(message: "Response is empty.")
            }
            self.tableView.reloadData()
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

//MARK: - UISearchBarDelegate Methods

extension ItemViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dataManager.readDatabaseEntityItem(withSearch: searchBarText, withControl: segmentedControlValue)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarText = searchText
        if searchBarText == "" {
            dataManager.readDatabaseEntityItem(withSearch: searchBarText, withControl: segmentedControlValue)
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

//MARK: - SegmentedControl Methods

extension ItemViewController {
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        segmentedControlValue = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        dataManager.readDatabaseEntityItem(withSearch: searchBarText, withControl: segmentedControlValue)
        tableView.reloadData()
    }
    
}

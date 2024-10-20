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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.readDatabaseEntityCategory()
        tableView.reloadData()
    }
    
    override func updateDatabaseEntity(indexPath: IndexPath) {
        editDatabaseEntityCategory(index: indexPath.row)
    }
    
    override func deleteDatabaseEntity(indexPath: IndexPath) {
        dataManager.deleteDatabaseEntityCategory(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let safeCategoryArray = dataManager.categoryArray {
            let name = safeCategoryArray[indexPath.row].name
            let cellHeightMultiple = name!.count / K.numberCharPerLine
            return (CGFloat(cellHeightMultiple) * K.cellHeightPctIncreasePerLine * K.cellHeight + K.cellHeight)
        } else {
            return K.cellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let safeCategoryArray = dataManager.categoryArray {
            cell.backgroundColor = UIColor(safeCategoryArray[indexPath.row].cellBackgroundColorHexString!)
            cell.textLabel?.textColor = cell.backgroundColor!.isLight ? .black : .white
            let name = safeCategoryArray[indexPath.row].name
            cell.textLabel?.text = name
            let cellHeightMultiple = name!.count / K.numberCharPerLine
            cell.textLabel?.numberOfLines = cellHeightMultiple + 1
            cell.detailTextLabel?.text = nil
            cell.accessoryView = UIImageView(image: UIImage(systemName: "arrow.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: K.regularSize)))
            cell.tintColor = cell.backgroundColor!.isLight ? .black : .white
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryArrayCount = dataManager.categoryArray?.count ?? 0
        (categoryArrayCount == 0) ? setEmptyMessage(message: "No categories added.") : restore()
        return categoryArrayCount
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueCategoryToItem", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCategoryToItem" {
            let destinationViewController = segue.destination as! TaskViewController
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
                if self.dataManager.createDatabaseEntityCategory(name: safeText) {
                    self.dataManager.readDatabaseEntityCategory()
                    self.tableView.reloadData()
                } else {
                    self.invalidResponseAddPressed(message: "Category already exists.")
                }
            } else {
                self.invalidResponseAddPressed(message: "Category is empty.")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in return }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Category"
            alertTextField.returnKeyType = .done
            inputTextField = alertTextField
        }
        present(alert, animated: true) { }
    }
    
    private func editDatabaseEntityCategory(index: Int) {
        var inputTextField = UITextField()
        let alert = UIAlertController(title: "Edit Current Category:", message: "", preferredStyle: .alert)
        let editAction = UIAlertAction(title: "Edit Category", style: .default) { action in
            guard let safeText = inputTextField.text else { return }
            if safeText != "" {
                if self.dataManager.updateDatabaseEntityCategory(index: index, newName: safeText) {
                    self.dataManager.readDatabaseEntityCategory()
                    self.tableView.reloadData()
                } else {
                    self.invalidResponseAddPressed(message: "Category already exists.")
                }
            } else {
                self.invalidResponseAddPressed(message: "Category is empty.")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in return }
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Edit Current Category"
            alertTextField.text = self.dataManager.categoryArray![index].name
            alertTextField.returnKeyType = .done
            inputTextField = alertTextField
        }
        present(alert, animated: true) { }
    }
    
}

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("categoryVC error: Navigation Bar is nil.") }
        navBar.backgroundColor = .systemBlue
        navBar.standardAppearance.backgroundColor = .systemBlue
        navBar.compactAppearance?.backgroundColor = .systemBlue
        navBar.scrollEdgeAppearance?.backgroundColor = .systemBlue
        navBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.compactAppearance?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.compactAppearance?.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.scrollEdgeAppearance?.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
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

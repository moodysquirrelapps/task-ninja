//
//  TaskViewController.swift
//  Task Ninja
//
//  Created by Tam Le on 10/11/24.
//

import UIKit

class TaskViewController: BaseTableViewController {
    
    let dataManager: DataManager = DataManager()
    private var segmentedControlValue: String = "Active"
    private var searchBarText: String = ""
    @IBOutlet weak var uiViewBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor = UIColor(dataManager.categorySelected!.cellBackgroundColorHexString!)
        tintColor = backgroundColor.isLight ? UIColor.black : UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = dataManager.categorySelected!.name
        uiViewBar.backgroundColor = backgroundColor
        // Search Bar
        searchBar.searchTextField.font = K.smallFont
        searchBar.barTintColor = backgroundColor
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        // Segmented Control
        segmentedControl.backgroundColor = backgroundColor
        segmentedControl.selectedSegmentTintColor = .white.withAlphaComponent(K.minAlpha)
        segmentedControl.setTitleTextAttributes([.foregroundColor: tintColor, .font: K.smallFont], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: tintColor, .font: K.smallFont], for: .selected)
        // Refresh Table
        dataManager.readDatabaseEntityTask(withSearch: searchBarText, withControl: segmentedControlValue)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let safeTaskArray = dataManager.taskArray {
            let name = safeTaskArray[indexPath.row].name
            let cellHeightMultiple = name!.count / K.numberCharPerLine
            return (CGFloat(cellHeightMultiple) * K.cellHeightPctIncreasePerLine * K.cellHeight + K.cellHeight)
        } else {
            return K.cellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let safeTaskArray = dataManager.taskArray, let categorySelected = dataManager.categorySelected {
            let newAlpha = (K.minAlpha +  CGFloat(indexPath.row + 1) * (K.maxAlpha - K.minAlpha) / CGFloat(safeTaskArray.count))
            cell.backgroundColor = UIColor(categorySelected.cellBackgroundColorHexString!).withAlphaComponent(newAlpha)
            cell.textLabel?.textColor = cell.backgroundColor!.isLight ? .black : .white
            let name = safeTaskArray[indexPath.row].name
            cell.textLabel?.text = name
            let cellHeightMultiple = name!.count / K.numberCharPerLine
            cell.textLabel?.numberOfLines = cellHeightMultiple + 1
            cell.detailTextLabel?.textColor = cell.backgroundColor!.isLight ? .black : .white
            cell.detailTextLabel?.text =  "Created: " + dataManager.dateToString(safeTaskArray[indexPath.row].creationDate!)
            cell.detailTextLabel?.text = safeTaskArray[indexPath.row].isDone ?
            ("Completed: " + dataManager.dateToString(safeTaskArray[indexPath.row].completionDate!) + "\n" + cell.detailTextLabel!.text!) :
            cell.detailTextLabel?.text
            cell.accessoryView = safeTaskArray[indexPath.row].isDone ?
            UIImageView(image: UIImage(systemName: "checkmark.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: K.regularSize))) :
            UIImageView(image: UIImage(systemName: "square", withConfiguration: UIImage.SymbolConfiguration(pointSize: K.regularSize)))
            cell.tintColor = cell.backgroundColor!.isLight ? .black : .white
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskArrayCount = dataManager.taskArray?.count ?? 0
        (taskArrayCount == 0) ? setEmptyMessage(message: "No tasks found.") : restore()
        return taskArrayCount
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataManager.taskArray != nil {
            if dataManager.updateDatabaseEntityTask(index: indexPath.row) {
                dataManager.readDatabaseEntityTask(withSearch: searchBarText, withControl: segmentedControlValue)
                tableView.reloadData()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func updateDatabaseEntity(indexPath: IndexPath) {
        editDatabaseEntityTask(index: indexPath.row)
    }
    
    override func deleteDatabaseEntity(indexPath: IndexPath) {
        dataManager.deleteDatabaseEntityTask(index: indexPath.row)
    }
    
}

// MARK: - Add And Edit Button Methods

extension TaskViewController {
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var inputTextField = UITextField()
        let alert = UIAlertController(title: "Add New Task:", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Task", style: .default) { action in
            guard let safeText = inputTextField.text else { return }
            if safeText != "" {
                if self.dataManager.createDatabaseEntityTask(name: safeText) {
                    self.dataManager.readDatabaseEntityTask(withSearch: self.searchBarText, withControl: self.segmentedControlValue)
                    self.tableView.reloadData()
                } else {
                    self.invalidResponseAddPressed(message: "Task already exists.")
                }
            } else {
                self.invalidResponseAddPressed(message: "Task is empty.")
            }
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in return }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Task"
            alertTextField.returnKeyType = .done
            inputTextField = alertTextField
        }
        present(alert, animated: true) { }
    }
    
    private func editDatabaseEntityTask(index: Int) {
        var inputTextField = UITextField()
        let alert = UIAlertController(title: "Edit Current Task:", message: "", preferredStyle: .alert)
        let editAction = UIAlertAction(title: "Edit Task", style: .default) { action in
            guard let safeText = inputTextField.text else { return }
            if safeText != "" {
                if self.dataManager.updateDatabaseEntityTask(index: index, newName: safeText) {
                    self.dataManager.readDatabaseEntityTask(withSearch: self.searchBarText, withControl: self.segmentedControlValue)
                    self.tableView.reloadData()
                } else {
                    self.invalidResponseAddPressed(message: "Task already exists.")
                }
            } else {
                self.invalidResponseAddPressed(message: "Task is empty.")
            }
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in return }
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Edit Current Task"
            alertTextField.text = self.dataManager.taskArray![index].name
            alertTextField.returnKeyType = .done
            inputTextField = alertTextField
        }
        present(alert, animated: true) { }
    }
    
}

//MARK: - UISearchBarDelegate Methods

extension TaskViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dataManager.readDatabaseEntityTask(withSearch: searchBarText, withControl: segmentedControlValue)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarText = searchText
        if searchBarText == "" {
            dataManager.readDatabaseEntityTask(withSearch: searchBarText, withControl: segmentedControlValue)
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

//MARK: - SegmentedControl Methods

extension TaskViewController {
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        segmentedControlValue = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        dataManager.readDatabaseEntityTask(withSearch: searchBarText, withControl: segmentedControlValue)
        tableView.reloadData()
    }
    
}

//
//  SwipeTableViewController.swift
//  TaskNinja
//
//  Created by Tam Le on 10/12/24.
//

import UIKit
import SwipeCellKit

class BaseTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let smallFont: UIFont = UIFont(name: "ZenDots-Regular", size: 14.0)!
    let regularFont: UIFont = UIFont(name: "ZenDots-Regular", size: 22.0)!
    let titleFont: UIFont = UIFont(name: "ZenDots-Regular", size: 40.0)!
    var backgroundColor: UIColor = UIColor.systemBlue
    var tintColor: UIColor = UIColor.white

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Task Ninja"
        guard let navBar = navigationController?.navigationBar else { fatalError("categoryVC error: Navigation Bar is nil.") }
        navBar.backgroundColor = backgroundColor
        navBar.standardAppearance.backgroundColor = backgroundColor
        navBar.compactAppearance?.backgroundColor = backgroundColor
        navBar.scrollEdgeAppearance?.backgroundColor = backgroundColor
        navBar.titleTextAttributes = [.foregroundColor: tintColor, .font: regularFont]
        navBar.standardAppearance.titleTextAttributes = [.foregroundColor: tintColor, .font: regularFont]
        navBar.compactAppearance?.titleTextAttributes = [.foregroundColor: tintColor, .font: regularFont]
        navBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: tintColor, .font: regularFont]
        navBar.largeTitleTextAttributes = [.foregroundColor: tintColor, .font: titleFont]
        navBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor, .font: titleFont]
        navBar.compactAppearance?.largeTitleTextAttributes = [.foregroundColor: tintColor, .font: titleFont]
        navBar.scrollEdgeAppearance?.largeTitleTextAttributes = [.foregroundColor: tintColor, .font: titleFont]
        navBar.tintColor = tintColor
        navigationItem.rightBarButtonItem?.tintColor = tintColor
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            self.deleteDatabaseEntity(indexPath: indexPath)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = regularFont
        return cell
    }
    
    func invalidResponseAddPressed(message: String) {
        let alert = UIAlertController(title: "Error:", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in return }
        alert.addAction(okAction)
        present(alert, animated: true) { }
    }

    func deleteDatabaseEntity(indexPath: IndexPath) {
        // Implementation Provided By Children
    }
    
}

//MARK: - UIColor

extension UIColor {
    
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
    
}

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
    let regularFont: UIFont = UIFont(name: "ZenDots-Regular", size: 24.0)!
    let titleFont: UIFont = UIFont(name: "ZenDots-Regular", size: 40.0)!
    var backgroundColor: UIColor = UIColor.systemBlue
    var tintColor: UIColor = UIColor.white

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100.0
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).minimumScaleFactor = 0.50
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Navigation Bar
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
        // Top Safe Area
        var frame = tableView.bounds
        frame.origin.y = -frame.size.height
        let safeAreaView = UIView(frame: frame)
        safeAreaView.backgroundColor = backgroundColor
        tableView.addSubview(safeAreaView)
    }
    
    // Regular TableView Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.50
        cell.textLabel?.font = regularFont
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.minimumScaleFactor = 0.50
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.font = smallFont
        return cell
    }
    
    // SwipeTableView Methods
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
        let editAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.updateDatabaseEntity(indexPath: indexPath)
        }
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            self.deleteDatabaseEntity(indexPath: indexPath)
        }
        editAction.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22.0))
        editAction.backgroundColor = UIColor.systemYellow
        deleteAction.image = UIImage(systemName: "trash.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22.0))
        deleteAction.backgroundColor = UIColor.systemRed
        return [deleteAction, editAction]
    }
    
    func updateDatabaseEntity(indexPath: IndexPath) {
        // Implementation Provided By Children
    }
    
    func deleteDatabaseEntity(indexPath: IndexPath) {
        // Implementation Provided By Children
    }
    
    // UI Helper Methods
    func invalidResponseAddPressed(message: String) {
        let alert = UIAlertController(title: "Error:", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in return }
        alert.addAction(okAction)
        present(alert, animated: true) { }
    }
    
    func setEmptyMessage(message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = .black
        messageLabel.font = regularFont
        messageLabel.text = message
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel
    }

    func restore() {
        tableView.backgroundView = nil
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

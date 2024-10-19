//
//  AnalyticsViewController.swift
//  Task Ninja
//
//  Created by Tam Le on 10/18/24.
//

import UIKit
import SwiftUI

class AnalyticsViewController: UIViewController {
    
    let categoriesChartView = UIHostingController(rootView: CategoriesChart())
    let smallFont: UIFont = UIFont(name: "ZenDots-Regular", size: 14.0)!
    let regularFont: UIFont = UIFont(name: "ZenDots-Regular", size: 24.0)!
    let titleFont: UIFont = UIFont(name: "ZenDots-Regular", size: 40.0)!
    var backgroundColor: UIColor = UIColor.systemBlue
    var tintColor: UIColor = UIColor.white
    @IBOutlet weak var chartsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Navigation Bar
        navigationItem.title = "Analytics"
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
        view.backgroundColor = backgroundColor
        // Charts
        categoriesChartView.view.frame = chartsView.bounds
        chartsView.addSubview(categoriesChartView.view)
        addChild(categoriesChartView)
    }
    
}

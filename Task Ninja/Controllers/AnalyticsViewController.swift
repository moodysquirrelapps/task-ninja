//
//  AnalyticsViewController.swift
//  Task Ninja
//
//  Created by Tam Le on 10/18/24.
//

import UIKit
import SwiftUI

class AnalyticsViewController: UIViewController {
    
    private let categoriesChartView = UIHostingController(rootView: CategoriesChart())
    @IBOutlet weak var chartsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Navigation Bar
        navigationItem.title = "Analytics"
        guard let navBar = navigationController?.navigationBar else { fatalError("categoryVC error: Navigation Bar is nil.") }
        navBar.backgroundColor = K.backgroundColor
        navBar.standardAppearance.backgroundColor = K.backgroundColor
        navBar.compactAppearance?.backgroundColor = K.backgroundColor
        navBar.scrollEdgeAppearance?.backgroundColor = K.backgroundColor
        navBar.titleTextAttributes = [.foregroundColor: K.tintColor, .font: K.regularFont]
        navBar.standardAppearance.titleTextAttributes = [.foregroundColor: K.tintColor, .font: K.regularFont]
        navBar.compactAppearance?.titleTextAttributes = [.foregroundColor: K.tintColor, .font: K.regularFont]
        navBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: K.tintColor, .font: K.regularFont]
        navBar.largeTitleTextAttributes = [.foregroundColor: K.tintColor, .font: K.titleFont]
        navBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: K.tintColor, .font: K.titleFont]
        navBar.compactAppearance?.largeTitleTextAttributes = [.foregroundColor: K.tintColor, .font: K.titleFont]
        navBar.scrollEdgeAppearance?.largeTitleTextAttributes = [.foregroundColor: K.tintColor, .font: K.titleFont]
        navBar.tintColor = K.tintColor
        navigationItem.rightBarButtonItem?.tintColor = K.tintColor
        // Top Safe Area
        view.backgroundColor = K.backgroundColor
        // Charts
        categoriesChartView.view.frame = chartsView.bounds
        chartsView.addSubview(categoriesChartView.view)
        addChild(categoriesChartView)
    }
    
}

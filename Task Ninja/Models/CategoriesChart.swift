//
//  CategoriesChart.swift
//  Task Ninja
//
//  Created by Tam Le on 10/18/24.
//

import SwiftUI
import Charts
import Foundation

struct CategoryData: Identifiable {
    
    let id: Int
    let sumActive: Int
    let sumDone: Int
    let uiColor: UIColor
    
}

struct CategoriesAnalytics {
    
    let dataManager: DataManager = DataManager()
    var categoriesAnalyticsArray: [(category: String, categoryData: CategoryData, categorySumMax: Int)] = []
    var categoriesAnalyticsMaxSum: Int {
        if categoriesAnalyticsArray.count > 0 {
            let max1 = categoriesAnalyticsArray[0].categorySumMax
            let max2 = categoriesAnalyticsArray[1].categorySumMax
            return (max1 > max2) ? max1 : max2
        } else {
            return 0
        }
    }
    
    init(categoriesAnalyticsArray: [(category: String, categoryData: CategoryData, categorySumMax: Int)] = []) {
        instantiateProperties()
    }
    
    mutating func instantiateProperties() {
        dataManager.readDatabaseEntityCategory()
        for (index, category) in dataManager.categoryArray!.enumerated() {
            // Name
            dataManager.categorySelected = category
            let newCategoryName = category.name!
            // Active
            dataManager.readDatabaseEntityTask()
            let sumActive = dataManager.taskArray?.count ?? 0
            // Done
            dataManager.readDatabaseEntityTask(withControl: "Done")
            let sumDone = dataManager.taskArray?.count ?? 0
            // CategoryData
            let newCategoryData = CategoryData(id: index, sumActive: sumActive, sumDone: sumDone, uiColor: UIColor(category.cellBackgroundColorHexString!))
            // CategorySumMax
            let newCategorySumMax = (sumActive > sumDone) ? sumActive : sumDone
            // Append
            categoriesAnalyticsArray.append((category: newCategoryName, categoryData: newCategoryData, categorySumMax: newCategorySumMax))
        }
    }
    
}

struct CategoriesChart: View {
    
    let categoriesAnalytics = CategoriesAnalytics()
    let smallFont: UIFont = UIFont(name: "ZenDots-Regular", size: 14.0)!
    let regularFont: UIFont = UIFont(name: "ZenDots-Regular", size: 24.0)!
    let titleFont: UIFont = UIFont(name: "ZenDots-Regular", size: 40.0)!
    
    var body: some View {
        ScrollView {
            VStack {
                if #available(iOS 16.0, *) {
                    let dataArray = categoriesAnalytics.categoriesAnalyticsArray
                    let defaultHeight = 100
                    Chart(dataArray, id: \.category) { category in
                        BarMark(
                            x: .value("Sum", category.categoryData.sumActive),
                            y: .value("Name", category.category)
                        )
                        .foregroundStyle(Color(category.categoryData.uiColor.withAlphaComponent(0.50)))
                        .position(by: .value("Status", "Active"))
                        .annotation(position: .trailing, alignment: .trailing) {
                            Text("Active = \(category.categoryData.sumActive)")
                                .font(Font(smallFont as CTFont))
                                .foregroundColor(.black)
                        }
                        BarMark(
                            x: .value("Sum", category.categoryData.sumDone),
                            y: .value("Name", category.category)
                        )
                        .foregroundStyle(Color(category.categoryData.uiColor.withAlphaComponent(1.00)))
                        .position(by: .value("Status", "Done"))
                        .annotation(position: .trailing, alignment: .trailing) {
                            Text("Done = \(category.categoryData.sumDone)")
                                .font(Font(smallFont as CTFont))
                                .foregroundColor(.black)
                        }
                    }
                    .frame(height: CGFloat(dataArray.count * defaultHeight))
                    .chartXAxis { }
                    .chartYAxis {
                        AxisMarks {
                            let value = $0.as(String.self)!
                            AxisValueLabel {
                                Text("\(value)")
                                    .font(Font(regularFont as CTFont))
                                    .foregroundStyle(.black)
                                    .underline()
                            }
                        }
                    }
                } else {
                    Text("Please upgrade to iOS 16.0 or higher.")
                        .font(Font(smallFont as CTFont))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.all, 24.0)
        }
    }
    
}

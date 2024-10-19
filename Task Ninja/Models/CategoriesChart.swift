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
    let name: String
    let sumActive: Int
    let sumDone: Int
    let color: Color
    
}

struct CategoriesAnalytics {
    
    let dataManager: DataManager = DataManager()
    var categoriesAnalyticsArray: [CategoryData] = []
    var categoriesAnalyticsMaxSumActive: Int = 0
    var categoriesAnalyticsMaxSumDone: Int = 0
    var categoriesAnalyticsMaxX: Int = 0
    
    init(categoriesAnalyticsArray: [CategoryData] = []) {
        setup()
    }
    
    mutating func setup() {
        dataManager.readDatabaseEntityCategory()
        for (index, category) in dataManager.categoryArray!.enumerated() {
            dataManager.categorySelected = category
            dataManager.readDatabaseEntityTask()
            let sumActive = dataManager.taskArray?.count ?? 0
            dataManager.readDatabaseEntityTask(withControl: "Done")
            let sumDone = dataManager.taskArray?.count ?? 0
            let newCategoryData = CategoryData(id: index, name: category.name!, sumActive: sumActive, sumDone: sumDone, color: Color(UIColor(category.cellBackgroundColorHexString!)))
            categoriesAnalyticsArray.append(newCategoryData)
            categoriesAnalyticsMaxSumActive = (newCategoryData.sumActive > categoriesAnalyticsMaxSumActive) ? newCategoryData.sumActive : categoriesAnalyticsMaxSumActive
            categoriesAnalyticsMaxSumDone = (newCategoryData.sumDone > categoriesAnalyticsMaxSumDone) ? newCategoryData.sumDone : categoriesAnalyticsMaxSumDone
        }
        categoriesAnalyticsMaxX = max(categoriesAnalyticsMaxSumActive, categoriesAnalyticsMaxSumDone)
    }
    
}

struct CategoriesChart: View {
    
    let categoriesAnalytics = CategoriesAnalytics()
    let smallFont: UIFont = UIFont(name: "ZenDots-Regular", size: 14.0)!
    let regularFont: UIFont = UIFont(name: "ZenDots-Regular", size: 24.0)!
    let titleFont: UIFont = UIFont(name: "ZenDots-Regular", size: 40.0)!
    
    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                Text("Active Tasks")
                    .font(Font(regularFont as CTFont))
                    .foregroundStyle(.black)
                Chart {
                    ForEach(categoriesAnalytics.categoriesAnalyticsArray) { categoryAnalytics in
                        BarMark(
                            x: .value("SumActive", categoryAnalytics.sumActive),
                            y: .value("Name", categoryAnalytics.name)
                        ).foregroundStyle(categoryAnalytics.color)
                    }
                }
                .chartXAxisLabel(alignment: .center) {
                    Text("Sum")
                        .font(Font(smallFont as CTFont))
                        .foregroundStyle(.black)
                }
                .chartXScale(domain: [0, categoriesAnalytics.categoriesAnalyticsMaxX + 1])
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: categoriesAnalytics.categoriesAnalyticsMaxX + 1)) {
                        let value = $0.as(Int.self)!
                        AxisValueLabel {
                            Text("\(value)")
                                .font(Font(smallFont as CTFont))
                                .foregroundStyle(.black)
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks {
                        let value = $0.as(String.self)!
                        AxisValueLabel {
                            Text("\(value)")
                                .font(Font(smallFont as CTFont))
                                .foregroundStyle(.black)
                        }
                    }
                }
                .padding(.all, 14.0)
            } else {
                Text("Please upgrade to iOS 16.0 or higher.")
                    .font(Font(smallFont as CTFont))
                    .multilineTextAlignment(.center)
            }
        }.multilineTextAlignment(.center)
            .padding(.all, 24.0)
    }
    
}

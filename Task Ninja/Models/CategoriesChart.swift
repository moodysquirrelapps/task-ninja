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
    
    private mutating func instantiateProperties() {
        dataManager.readDatabaseEntityCategory()
        guard let safeCategoryArray = dataManager.categoryArray else { return }
        for (index, category) in safeCategoryArray.enumerated() {
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
    
    private let categoriesAnalytics = CategoriesAnalytics()
    
    var body: some View {
        if #available(iOS 16.0, *) {
            let dataArray = categoriesAnalytics.categoriesAnalyticsArray
            let dataArrayMaxRange = categoriesAnalytics.categoriesAnalyticsMaxSum + 1
            let dataArraySize = dataArray.count
            if dataArraySize > 0 {
                ScrollView {
                    VStack {
                        let defaultHeight = K.cellHeight
                        Chart(dataArray, id: \.category) { category in
                            BarMark(
                                x: .value("Sum", category.categoryData.sumActive),
                                y: .value("Name", category.category)
                            )
                            .foregroundStyle(Color(category.categoryData.uiColor.withAlphaComponent(K.minAlpha)))
                            .position(by: .value("Status", "Active"))
                            .annotation(position: .trailing, alignment: .trailing) {
                                Text("Active = \(category.categoryData.sumActive)")
                                    .font(Font(K.smallFont as CTFont))
                                    .foregroundColor(.black)
                            }
                            BarMark(
                                x: .value("Sum", category.categoryData.sumDone),
                                y: .value("Name", category.category)
                            )
                            .foregroundStyle(Color(category.categoryData.uiColor.withAlphaComponent(K.maxAlpha)))
                            .position(by: .value("Status", "Done"))
                            .annotation(position: .trailing, alignment: .trailing) {
                                Text("Done = \(category.categoryData.sumDone)")
                                    .font(Font(K.smallFont as CTFont))
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(height: CGFloat(2 * dataArraySize) * defaultHeight)
                        .chartXAxis { }
                        .chartXScale(domain: 0...dataArrayMaxRange)
                        .chartYAxis {
                            AxisMarks {
                                let value = $0.as(String.self)!
                                let valueAdjusted = (value.count >= 12) ? String(value.prefix(12) + "...") : value
                                AxisValueLabel {
                                    Text("\(valueAdjusted)")
                                        .font(Font(K.regularFont as CTFont))
                                        .foregroundStyle(.black)
                                        .underline()
                                }
                            }
                        }
                    }
                }
                .padding(.all, K.regularSize)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            } else {
                VStack {
                    Text("No data available.")
                        .font(Font(K.regularFont as CTFont))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.all, K.regularSize)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
        } else {
            VStack {
                Text("Please upgrade to iOS 16.0 or higher.")
                    .font(Font(K.regularFont as CTFont))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.all, K.regularSize)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
    }
    
}

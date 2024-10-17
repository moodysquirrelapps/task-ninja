//
//  DataManager.swift
//  Task Ninja
//
//  Created by Tam Le on 10/12/24.
//

import UIKit
import CoreData
import UIColorHexSwift

class DataManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray: [Category]?
    var itemArray: [Item]?
    var categorySelected: Category?
    
    func saveDatabase() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
}

// MARK: - Category CRUD Methods

extension DataManager {
    
    func createDatabaseEntityCategory(name: String) -> Bool {
        // Unique Name Constraint
        let nameTransformed = name.capitalized.trimmingCharacters(in: .whitespaces)
        if let safeCategoryArray = categoryArray {
            for category in safeCategoryArray {
                if (category.name!.capitalized == nameTransformed) { return false }
            }
        }
        // Create New Category
        let newCategory = Category(context: self.context)
        newCategory.name = nameTransformed
        let newCellBackgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.00)
        newCategory.cellBackgroundColorHexString = newCellBackgroundColor.hexString()
        // Save Changes
        saveDatabase()
        // Refresh Category Array
        readDatabaseEntityCategory()
        return true
    }
    
    func readDatabaseEntityCategory() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let fetchedCategory = try context.fetch(request)
            categoryArray = fetchedCategory.count == 0 ? nil : fetchedCategory
        } catch {
            print("readDatabaseEntityCategory Error: \(error.localizedDescription)")
        }
    }
    
    func updateDatabaseEntityCategory(index: Int, newName: String) -> Bool {
        // Unique Name Constraint
        let nameTransformed = newName.capitalized.trimmingCharacters(in: .whitespaces)
        if let safeCategoryArray = categoryArray {
            for category in safeCategoryArray {
                if (category.name!.capitalized == nameTransformed) { return false }
            }
        }
        // Edit Current Category
        categoryArray![index].name = nameTransformed
        // Save Changes
        saveDatabase()
        // Refresh Category Array
        readDatabaseEntityCategory()
        return true
    }
    
    func deleteDatabaseEntityCategory(index: Int) {
        context.delete(categoryArray![index])
        saveDatabase()
        readDatabaseEntityCategory()
    }
    
}

// MARK: - Item CRUD Methods

extension DataManager {
    
    func createDatabaseEntityItem(name: String) -> Bool {
        // Unique Name Constraint
        let nameTransformed = name.capitalized.trimmingCharacters(in: .whitespaces)
        if let safeItemArray = itemArray {
            for item in safeItemArray {
                if (item.name!.capitalized == nameTransformed) { return false }
            }
        }
        // Create New Item
        let newItem = Item(context: self.context)
        newItem.categoryName = categorySelected!.name
        newItem.name = nameTransformed
        newItem.isDone = false
        newItem.date = Date()
        newItem.parentCategory = categorySelected!
        // Save Changes
        saveDatabase()
        // Refresh Item Array
        readDatabaseEntityItem()
        return true
    }
    
    func readDatabaseEntityItem(searchBarText: String = "") {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = (searchBarText == "") ? NSPredicate(format: "categoryName MATCHES %@", categorySelected!.name!) : NSPredicate(format: "categoryName MATCHES %@ AND name CONTAINS[cd] %@", categorySelected!.name!, searchBarText)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false), NSSortDescriptor(key: "name", ascending: true)]
        do {
            let fetchedItem = try context.fetch(request)
            itemArray = fetchedItem.count == 0 ? nil : fetchedItem
        } catch {
            print("readDatabaseEntityItem Error: \(error.localizedDescription)")
        }
    }
    
    func updateDatabaseEntityItem(index: Int, newName: String = "") -> Bool {
        if newName == "" {
            itemArray![index].isDone = !(itemArray![index].isDone)
            saveDatabase()
            readDatabaseEntityItem()
        } else {
            // Unique Name Constraint
            let nameTransformed = newName.capitalized.trimmingCharacters(in: .whitespaces)
            if let safeItemArray = itemArray {
                for item in safeItemArray {
                    if (item.name!.capitalized == nameTransformed) { return false }
                }
            }
            // Edit Current Item
            itemArray![index].name = nameTransformed
            // Save Changes
            saveDatabase()
            // Refresh Item Array
            readDatabaseEntityItem()
        }
        return true
    }
    
    func deleteDatabaseEntityItem(index: Int) {
        context.delete(itemArray![index])
        saveDatabase()
        readDatabaseEntityItem()
    }
    
}

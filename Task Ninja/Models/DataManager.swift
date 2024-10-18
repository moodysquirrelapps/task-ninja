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
        return true
    }
    
    func readDatabaseEntityCategory() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let fetchedCategory = try context.fetch(request)
            categoryArray = (fetchedCategory.count == 0) ? nil : fetchedCategory
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
        return true
    }
    
    func deleteDatabaseEntityCategory(index: Int) {
        context.delete(categoryArray![index])
        categoryArray!.remove(at: index)
        saveDatabase()
    }
    
}

// MARK: - Item CRUD Methods

extension DataManager {
    
    func createDatabaseEntityItem(name: String) -> Bool {
        // Create New Item
        let nameTransformed = name.capitalized.trimmingCharacters(in: .whitespaces)
        let newItem = Item(context: self.context)
        newItem.categoryName = categorySelected!.name
        newItem.name = nameTransformed
        newItem.isDone = false
        newItem.creationDate = Date()
        newItem.completionDate = nil
        newItem.parentCategory = categorySelected!
        // Save Changes
        saveDatabase()
        return true
    }
    
    func readDatabaseEntityItem(withSearch searchBarText: String = "", withControl segmentedControlValue: String = "Active") {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicateCategoryName = NSPredicate(format: "categoryName MATCHES %@", categorySelected!.name!)
        let predicateName = (searchBarText == "") ?
        NSPredicate(format: "name LIKE[cd] %@", "*") :
        NSPredicate(format: "name CONTAINS[cd] %@", searchBarText)
        let predicateIsDone = (segmentedControlValue == "Active") ?
        NSPredicate(format: "isDone == %@", NSNumber(value: false)) :
        NSPredicate(format: "isDone == %@", NSNumber(value: true))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateCategoryName, predicateName, predicateIsDone])
        let sortDescriptorName = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptorDate = (segmentedControlValue == "Active") ?
        NSSortDescriptor(key: "creationDate", ascending: false) :
        NSSortDescriptor(key: "completionDate", ascending: false)
        request.sortDescriptors = [sortDescriptorDate, sortDescriptorName]
        do {
            let fetchedItem = try context.fetch(request)
            itemArray = (fetchedItem.count == 0) ? nil : fetchedItem
        } catch {
            print("readDatabaseEntityItem Error: \(error.localizedDescription)")
        }
    }
    
    func updateDatabaseEntityItem(index: Int, newName: String = "") -> Bool {
        if newName == "" {
            itemArray![index].isDone = !(itemArray![index].isDone)
            itemArray![index].completionDate = (itemArray![index].completionDate == nil) ? Date() : nil
        } else {
            let nameTransformed = newName.capitalized.trimmingCharacters(in: .whitespaces)
            itemArray![index].name = nameTransformed
        }
        saveDatabase()
        return true
    }
    
    func deleteDatabaseEntityItem(index: Int) {
        context.delete(itemArray![index])
        itemArray!.remove(at: index)
        saveDatabase()
    }
    
}

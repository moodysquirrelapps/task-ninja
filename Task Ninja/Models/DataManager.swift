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
    var taskArray: [Task]?
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
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func transformText(_ text: String) -> String {
        let newText = text.trimmingCharacters(in: .whitespaces)
        return (newText.count > 1) ?
        (newText.prefix(1).uppercased() + newText.lowercased().dropFirst()) :
        newText.prefix(1).uppercased()
    }
    
}

// MARK: - Category CRUD Methods

extension DataManager {
    
    func createDatabaseEntityCategory(name: String) -> Bool {
        // Unique Name Constraint
        let nameTransformed = transformText(name)
        if let safeCategoryArray = categoryArray {
            for category in safeCategoryArray {
                if (category.name == nameTransformed) { return false }
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
        // Sort Descriptors
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        // Fetch Data
        do {
            let fetchedCategory = try context.fetch(request)
            categoryArray = (fetchedCategory.count == 0) ? nil : fetchedCategory
        } catch {
            print("readDatabaseEntityCategory Error: \(error.localizedDescription)")
        }
    }
    
    func updateDatabaseEntityCategory(index: Int, newName: String) -> Bool {
        // Unique Name Constraint
        let newNameTransformed = transformText(newName)
        if let safeCategoryArray = categoryArray {
            for category in safeCategoryArray {
                if (category.name == newNameTransformed) { return false }
            }
        }
        // Edit Current Category
        categoryArray![index].name = newNameTransformed
        // Save Changes
        saveDatabase()
        return true
    }
    
    func deleteDatabaseEntityCategory(index: Int) {
        // Delete Current Category
        context.delete(categoryArray![index])
        categoryArray!.remove(at: index)
        // Save Changes
        saveDatabase()
    }
    
}

// MARK: - Task CRUD Methods

extension DataManager {
    
    func createDatabaseEntityTask(name: String) -> Bool {
        // Create New Task
        let nameTransformed = transformText(name)
        let newTask = Task(context: self.context)
        newTask.categoryName = categorySelected!.name
        newTask.name = nameTransformed
        newTask.isDone = false
        newTask.creationDate = Date()
        newTask.completionDate = nil
        newTask.parentCategory = categorySelected!
        // Save Changes
        saveDatabase()
        return true
    }
    
    func readDatabaseEntityTask(withSearch searchBarText: String = "", withControl segmentedControlValue: String = "Active") {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        // Predicates
        let predicateCategoryName = NSPredicate(format: "categoryName MATCHES %@", categorySelected!.name!)
        let predicateName = (searchBarText == "") ?
        NSPredicate(format: "name LIKE[cd] %@", "*") :
        NSPredicate(format: "name CONTAINS[cd] %@", searchBarText)
        let predicateIsDone = (segmentedControlValue == "Active") ?
        NSPredicate(format: "isDone == %@", NSNumber(value: false)) :
        NSPredicate(format: "isDone == %@", NSNumber(value: true))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateCategoryName, predicateName, predicateIsDone])
        // Sort Descriptors
        let sortDescriptorName = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptorDate = (segmentedControlValue == "Active") ?
        NSSortDescriptor(key: "creationDate", ascending: false) :
        NSSortDescriptor(key: "completionDate", ascending: false)
        request.sortDescriptors = [sortDescriptorDate, sortDescriptorName]
        // Fetch Data
        do {
            let fetchedTask = try context.fetch(request)
            taskArray = (fetchedTask.count == 0) ? nil : fetchedTask
        } catch {
            print("readDatabaseEntityTask Error: \(error.localizedDescription)")
        }
    }
    
    func updateDatabaseEntityTask(index: Int, newName: String = "") -> Bool {
        if newName == "" { // Edit Current Completion Status
            taskArray![index].isDone = !(taskArray![index].isDone)
            taskArray![index].completionDate = (taskArray![index].completionDate == nil) ? Date() : nil
        } else { // Edit Current Name
            let newNameTransformed = transformText(newName)
            taskArray![index].name = newNameTransformed
        }
        // Save Changes
        saveDatabase()
        return true
    }
    
    func deleteDatabaseEntityTask(index: Int) {
        // Delete Current Task
        context.delete(taskArray![index])
        taskArray!.remove(at: index)
        // Save Changes
        saveDatabase()
    }
    
}

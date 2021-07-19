//
//  PersistanceManager.swift
//  Maimon
//
//  Created by Evita Sihombing on 19/07/21.
//

import Foundation
import CoreData

class PersistanceManager {
    static let shared = PersistanceManager()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Maimon")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    // 1. Create save income function
    
    func insertIncome (descriptionInc: String, total: Double, date: Date, repeatInc: String) {
        
        let income = Income(context: persistentContainer.viewContext)
        income.id = UUID()
        income.descriptionInc = descriptionInc
        income.total = total
        income.date = date
        income.repeateInc = repeatInc
        saveContext()
    }
    
    // 2. Create save expanse function
    
    func insertExpense (total: Double, descriptionExp: String, date: Date, repeatExp: String, category: Category) {
        let expense = Expense(context: persistentContainer.viewContext)
        expense.id = UUID()
        expense.total = total
        expense.descriptionExp = descriptionExp
        expense.date = date
        expense.category = category
        expense.repeateExp = repeatExp
        saveContext()
        
    }
    
    // 3. Create save category function
    
    func insertCategory (name: String, percentage: Double) {
        let category = Category(context: persistentContainer.viewContext)
        category.id = UUID()
        category.name = name
        category.percentage = percentage
        saveContext()
    }
    
    // 4. Create function to fetch income data from coredata
    func fetchIncome() -> [Income] {
        let request : NSFetchRequest<Income> = Income.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor (key: "date", ascending: true)]
        
        var income : [Income] = []
        
        do {
            income = try persistentContainer.viewContext.fetch(request)
        } catch {
            print ("Error Fetching Data")
        }
        
        return income
    }
    
    // 5. Create function to fetch Expense
    // Get all expense
    func fetchExpense () -> [Expense] {
        let request : NSFetchRequest<Expense> = Expense.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor (key: "date", ascending: true)]
        var expense : [Expense] = []
        do {
            expense = try persistentContainer.viewContext.fetch(request)
        } catch {
            print ("Error Fetching Data")
        }
        return expense
    }
    
    // Get Expense by Category
    func fetchExpense (category: Category) -> [Expense] {
        let request : NSFetchRequest<Expense> = Expense.fetchRequest()
        
        request.predicate = NSPredicate(format: "category = %@", category)
        request.sortDescriptors = [NSSortDescriptor (key: "date", ascending: true)]
        
        var expense : [Expense] = []
        
        do {
            expense = try persistentContainer.viewContext.fetch(request)
        } catch {
            print ("Error Fetching Data")
        }
        
        return expense
    }
    
    // 6. Fetch Category
    func fetchCategory () -> [Category] {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor (key: "name", ascending: true)]
        
        var category : [Category] = []
        
        do {
            category = try persistentContainer.viewContext.fetch(request)
        } catch {
            print ("Error Fetching Data")
        }
        
        return category
    }
    
    // 7. Fetch Category by name
    
    func fetchCategory (name: String) -> [Category] {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "name = %@", name)
        
        request.sortDescriptors = [NSSortDescriptor (key: "name", ascending: true)]
        
        var category : [Category] = []
        
        do {
            category = try persistentContainer.viewContext.fetch(request)
        } catch {
            print ("Error Fetching Data")
        }
        
        return category
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

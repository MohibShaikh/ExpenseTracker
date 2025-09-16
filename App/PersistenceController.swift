import Foundation
import CoreData

final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        let model = Self.createManagedObjectModel()
        container = NSPersistentContainer(name: "ExpenseTracker", managedObjectModel: model)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error: \(error)")
            }
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            self.container.viewContext.automaticallyMergesChangesFromParent = true
        }
    }

    static func createManagedObjectModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // Expense entity
        let expenseEntity = NSEntityDescription()
        expenseEntity.name = "Expense"
        expenseEntity.managedObjectClassName = "Expense"

        let expenseId = NSAttributeDescription()
        expenseId.name = "id"
        expenseId.attributeType = .UUIDAttributeType
        expenseId.isOptional = false
        expenseId.isIndexed = true

        let expenseAmount = NSAttributeDescription()
        expenseAmount.name = "amount"
        expenseAmount.attributeType = .decimalAttributeType
        expenseAmount.isOptional = false

        let expenseDate = NSAttributeDescription()
        expenseDate.name = "date"
        expenseDate.attributeType = .dateAttributeType
        expenseDate.isOptional = false

        let expenseNote = NSAttributeDescription()
        expenseNote.name = "note"
        expenseNote.attributeType = .stringAttributeType
        expenseNote.isOptional = true

        let expenseVendor = NSAttributeDescription()
        expenseVendor.name = "vendor"
        expenseVendor.attributeType = .stringAttributeType
        expenseVendor.isOptional = true

        let expenseCategoryName = NSAttributeDescription()
        expenseCategoryName.name = "categoryName"
        expenseCategoryName.attributeType = .stringAttributeType
        expenseCategoryName.isOptional = true

        expenseEntity.properties = [expenseId, expenseAmount, expenseDate, expenseNote, expenseVendor, expenseCategoryName]

        // Budget entity
        let budgetEntity = NSEntityDescription()
        budgetEntity.name = "Budget"
        budgetEntity.managedObjectClassName = "Budget"

        let budgetId = NSAttributeDescription()
        budgetId.name = "id"
        budgetId.attributeType = .UUIDAttributeType
        budgetId.isOptional = false
        budgetId.isIndexed = true

        let month = NSAttributeDescription()
        month.name = "month"
        month.attributeType = .integer16AttributeType
        month.isOptional = false

        let year = NSAttributeDescription()
        year.name = "year"
        year.attributeType = .integer16AttributeType
        year.isOptional = false

        let limit = NSAttributeDescription()
        limit.name = "limit"
        limit.attributeType = .decimalAttributeType
        limit.isOptional = false

        budgetEntity.properties = [budgetId, month, year, limit]

        // Category entity
        let categoryEntity = NSEntityDescription()
        categoryEntity.name = "Category"
        categoryEntity.managedObjectClassName = "Category"

        let categoryId = NSAttributeDescription()
        categoryId.name = "id"
        categoryId.attributeType = .UUIDAttributeType
        categoryId.isOptional = false
        categoryId.isIndexed = true

        let categoryName = NSAttributeDescription()
        categoryName.name = "name"
        categoryName.attributeType = .stringAttributeType
        categoryName.isOptional = false

        categoryEntity.properties = [categoryId, categoryName]

        model.entities = [expenseEntity, budgetEntity, categoryEntity]
        return model
    }
}



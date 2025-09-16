import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
}

extension Category {
    static func ensureDefaults(in context: NSManagedObjectContext) {
        let request = Category.fetchRequest()
        request.fetchLimit = 1
        if let count = try? context.count(for: request), count > 0 { return }
        let defaultNames = [
            "Groceries", "Restaurants", "Transport", "Utilities",
            "Shopping", "Health", "Entertainment", "Travel", "Other"
        ]
        for n in defaultNames {
            let cat = Category(context: context)
            cat.id = UUID()
            cat.name = n
        }
        try? context.save()
    }
}



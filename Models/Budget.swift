import Foundation
import CoreData

@objc(Budget)
public class Budget: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var id: UUID
    @NSManaged public var month: Int16
    @NSManaged public var year: Int16
    @NSManaged public var limit: NSDecimalNumber
}

extension Budget {
    static func findOrCreate(in context: NSManagedObjectContext, month: Int, year: Int) -> Budget {
        let request = Budget.fetchRequest()
        request.predicate = NSPredicate(format: "month == %d AND year == %d", month, year)
        request.fetchLimit = 1
        if let existing = try? context.fetch(request).first, let existing {
            return existing
        }
        let budget = Budget(context: context)
        budget.id = UUID()
        budget.month = Int16(month)
        budget.year = Int16(year)
        budget.limit = 0
        return budget
    }
}



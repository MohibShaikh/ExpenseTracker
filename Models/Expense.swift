import Foundation
import CoreData

@objc(Expense)
public class Expense: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var id: UUID
    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var date: Date
    @NSManaged public var note: String?
    @NSManaged public var vendor: String?
    @NSManaged public var categoryName: String?
}

extension Expense {
    static func create(in context: NSManagedObjectContext,
                       amount: Decimal,
                       date: Date,
                       note: String?,
                       vendor: String?,
                       categoryName: String?) {
        let expense = Expense(context: context)
        expense.id = UUID()
        expense.amount = amount as NSDecimalNumber
        expense.date = date
        expense.note = note
        expense.vendor = vendor
        expense.categoryName = categoryName
    }
}



import Foundation
import CoreData

final class BudgetManager {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) { self.context = context }

    func setMonthlyLimit(_ limit: Decimal, for month: Int, year: Int) {
        let b = Budget.findOrCreate(in: context, month: month, year: year)
        b.limit = limit as NSDecimalNumber
        try? context.save()
    }

    func currentSpending(for month: Int, year: Int) -> Decimal {
        let start = DateComponents(calendar: .current, year: year, month: month, day: 1).date ?? Date()
        let endComponents = DateComponents(year: year, month: month + 1, day: 1)
        let end = Calendar.current.date(from: endComponents) ?? Date()

        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
        let items = (try? context.fetch(request)) ?? []
        let total = items.reduce(Decimal(0)) { $0 + ( $1.amount as Decimal ) }
        return total
    }

    func overLimit(for month: Int, year: Int) -> (isOver: Bool, remaining: Decimal, limit: Decimal) {
        let b = Budget.findOrCreate(in: context, month: month, year: year)
        let limit = b.limit as Decimal
        let spent = currentSpending(for: month, year: year)
        let remaining = limit - spent
        return (spent > limit, remaining, limit)
    }
}



import SwiftUI
import CoreData

struct AnalyticsView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Expense.date, ascending: false)])
    private var expenses: FetchedResults<Expense>

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Spending by Category")
                    .font(.headline)

                // Simple bar chart representation using rectangles
                VStack(spacing: 8) {
                    ForEach(summary, id: \.category) { item in
                        HStack {
                            Text(item.category)
                                .frame(width: 100, alignment: .leading)
                            Rectangle()
                                .fill(Color.blue.opacity(0.7))
                                .frame(width: max(10, CGFloat(item.total.doubleValue) * 2), height: 20)
                            Text(item.total.stringValue)
                                .frame(width: 80, alignment: .trailing)
                        }
                    }
                }
                .padding()

                Text("Totals")
                    .font(.headline)
                ForEach(summary, id: \.category) { item in
                    HStack {
                        Text(item.category)
                        Spacer()
                        Text(item.total.stringValue)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
        }
    }

    private var summary: [(category: String, total: NSDecimalNumber)] {
        let grouped = Dictionary(grouping: expenses) { (e: Expense) in e.categoryName ?? "Uncategorized" }
        let mapped: [(String, NSDecimalNumber)] = grouped.map { key, values in
            let totalDecimal = values.reduce(Decimal(0)) { $0 + ( $1.amount as Decimal ) }
            return (key, totalDecimal as NSDecimalNumber)
        }
        return mapped.sorted { $0.0 < $1.0 }.map { (category: $0.0, total: $0.1) }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}



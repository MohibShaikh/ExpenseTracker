import SwiftUI
import CoreData
import Charts

struct AnalyticsView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Expense.date, ascending: false)])
    private var expenses: FetchedResults<Expense>

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Spending by Category")
                    .font(.headline)

                Chart(summary, id: \.category) { item in
                    SectorMark(
                        angle: .value("Total", item.total as Decimal),
                        innerRadius: .ratio(0.5)
                    )
                    .foregroundStyle(by: .value("Category", item.category))
                }
                .chartLegend(.visible)
                .frame(height: 240)

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



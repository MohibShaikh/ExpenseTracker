import SwiftUI
import CoreData

struct BudgetView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var month: Int = Calendar.current.component(.month, from: Date())
    @State private var year: Int = Calendar.current.component(.year, from: Date())
    @State private var limitString: String = ""

    private var manager: BudgetManager { BudgetManager(context: context) }

    var body: some View {
        Form {
            Section(header: Text("Period")) {
                Stepper("Month: \(month)", value: $month, in: 1...12)
                Stepper("Year: \(year)", value: $year, in: 2000...2100)
            }
            Section(header: Text("Limit")) {
                TextField("0.00", text: $limitString).keyboardType(.decimalPad)
                Button("Save Limit") { saveLimit() }.disabled(Decimal(string: limitString) == nil)
            }
            Section(header: Text("Status")) {
                let status = manager.overLimit(for: month, year: year)
                HStack {
                    Text("Limit")
                    Spacer()
                    Text((status.limit as NSDecimalNumber).stringValue)
                }
                HStack {
                    Text("Remaining")
                    Spacer()
                    Text((status.remaining as NSDecimalNumber).stringValue)
                        .foregroundColor(status.isOver ? .red : .primary)
                }
            }
        }
        .navigationTitle("Budget")
    }

    private func saveLimit() {
        guard let limit = Decimal(string: limitString) else { return }
        manager.setMonthlyLimit(limit, for: month, year: year)
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}



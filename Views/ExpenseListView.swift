import SwiftUI
import CoreData

struct ExpenseListView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Expense.date, ascending: false)], animation: .default)
    private var expenses: FetchedResults<Expense>

    var body: some View {
        NavigationView {
            List {
                ForEach(expenses, id: \.id) { exp in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(exp.vendor ?? exp.note ?? "Expense")
                                .font(.headline)
                            Text(exp.categoryName ?? "Uncategorized")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(exp.amount.stringValue)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Expenses")
            .toolbar { EditButton() }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets { context.delete(expenses[index]) }
        try? context.save()
    }
}

struct ExpenseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseListView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}



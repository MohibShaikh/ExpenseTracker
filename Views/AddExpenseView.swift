import SwiftUI
import CoreData

struct AddExpenseView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var amountString: String = ""
    @State private var date: Date = Date()
    @State private var note: String = ""
    @State private var vendor: String = ""
    @State private var categoryName: String = ""
    @State private var autoCategorySuggestion: String = ""

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)])
    private var categories: FetchedResults<Category>

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Amount")) {
                    TextField("0.00", text: $amountString)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Details")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Vendor", text: $vendor)
                    TextField("Note", text: $note)
                    Picker("Category", selection: $categoryName) {
                        Text("Uncategorized").tag("")
                        ForEach(categories, id: \.id) { cat in
                            Text(cat.name).tag(cat.name)
                        }
                    }
                    if !autoCategorySuggestion.isEmpty && categoryName.isEmpty {
                        Text("Suggested: \(autoCategorySuggestion)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                Section {
                    Button("Save") { save() }.disabled(Decimal(string: amountString) == nil)
                }
            }
            .navigationTitle("Add Expense")
        }
    }

    private func save() {
        guard let amount = Decimal(string: amountString) else { return }
        let categorizer = CategorizationService()
        let result = categorizer.categorize(vendor: vendor, note: note, fullText: nil)
        let finalCategory = categoryName.isEmpty ? (result.categoryName ?? nil) : categoryName
        if categoryName.isEmpty, let suggestion = result.categoryName { autoCategorySuggestion = suggestion }
        Expense.create(in: context, amount: amount, date: date, note: note.isEmpty ? nil : note, vendor: vendor.isEmpty ? nil : vendor, categoryName: finalCategory)
        try? context.save()
        amountString = ""; note = ""; vendor = ""; categoryName = ""
        date = Date()
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}



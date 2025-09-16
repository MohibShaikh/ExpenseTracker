import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context

    var body: some View {
        TabView {
            ExpenseListView()
                .tabItem { Label("Expenses", systemImage: "list.bullet") }
            AddExpenseView()
                .tabItem { Label("Add", systemImage: "plus.circle") }
            ScanReceiptView()
                .tabItem { Label("Scan", systemImage: "camera.viewfinder") }
            BudgetView()
                .tabItem { Label("Budget", systemImage: "dollarsign.circle") }
            AnalyticsView()
                .tabItem { Label("Analytics", systemImage: "chart.pie") }
        }
        .onAppear {
            Category.ensureDefaults(in: context)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}



import SwiftUI
import VisionKit
import UIKit

struct ScanReceiptView: View {
    @State private var showingScanner = false
    @State private var ocrText: String = ""
    @State private var suggestedAmount: String = ""
    @State private var suggestedVendor: String = ""
    private let ocr = OCRService()
    private let categorizer = CategorizationService()

    var body: some View {
        VStack(spacing: 16) {
            Button {
                showingScanner = true
            } label: {
                Label("Scan Receipt", systemImage: "doc.text.viewfinder")
                    .font(.title2)
            }

            if !suggestedAmount.isEmpty || !suggestedVendor.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    if !suggestedAmount.isEmpty { Text("Amount: \(suggestedAmount)") }
                    if !suggestedVendor.isEmpty { Text("Vendor: \(suggestedVendor)") }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
            }

            if !ocrText.isEmpty {
                ScrollView { Text(ocrText).font(.footnote).padding() }
            } else {
                Text("Scan a receipt to extract details.")
                    .foregroundColor(.secondary)
            }
        }
        .sheet(isPresented: $showingScanner) {
            DocumentCameraView { image in
                guard let image = image else { return }
                ocr.recognize(from: image) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let r):
                            ocrText = r.fullText
                            if let amt = r.amountCandidates.first { suggestedAmount = NSDecimalNumber(decimal: amt).stringValue }
                            if let vendor = r.vendorCandidates.first { suggestedVendor = vendor }
                        case .failure:
                            ocrText = "Recognition failed."
                        }
                    }
                }
            }
        }
        .navigationTitle("Scan Receipt")
    }
}

struct ScanReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ScanReceiptView()
    }
}



import Foundation

final class CategorizationService {
    struct CategorizationResult {
        let categoryName: String?
        let confidence: Double
    }

    private let keywordToCategory: [String: String] = [
        "grocery": "Groceries",
        "market": "Groceries",
        "supermarket": "Groceries",
        "uber": "Transport",
        "lyft": "Transport",
        "fuel": "Transport",
        "gas": "Transport",
        "restaurant": "Restaurants",
        "cafe": "Restaurants",
        "coffee": "Restaurants",
        "electric": "Utilities",
        "water": "Utilities",
        "internet": "Utilities",
        "pharmacy": "Health",
        "hospital": "Health",
        "movie": "Entertainment",
        "cinema": "Entertainment",
        "flight": "Travel",
        "hotel": "Travel"
    ]

    func categorize(vendor: String?, note: String?, fullText: String?) -> CategorizationResult {
        let text = [vendor, note, fullText].compactMap { $0?.lowercased() }.joined(separator: " ")
        var scores: [String: Int] = [:]
        for (kw, cat) in keywordToCategory {
            if text.contains(kw) { scores[cat, default: 0] += 1 }
        }
        let best = scores.max(by: { $0.value < $1.value })
        if let best { return .init(categoryName: best.key, confidence: Double(best.value) / 3.0) }
        return .init(categoryName: nil, confidence: 0)
    }
}



import Foundation
import UIKit
import Vision

enum OCRServiceError: Error {
    case imageConversionFailed
    case recognitionFailed
}

struct OCRResult {
    let fullText: String
    let amountCandidates: [Decimal]
    let vendorCandidates: [String]
    let dateCandidates: [Date]
}

final class OCRService {
    func recognize(from image: UIImage, completion: @escaping (Result<OCRResult, Error>) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(OCRServiceError.imageConversionFailed)); return
        }

        let request = VNRecognizeTextRequest { request, error in
            if let error = error { completion(.failure(error)); return }
            let observations = (request.results as? [VNRecognizedTextObservation]) ?? []
            let lines: [String] = observations.compactMap { $0.topCandidates(1).first?.string }
            let fullText = lines.joined(separator: "\n")

            let amountCandidates = Self.extractAmounts(from: lines)
            let vendorCandidates = Self.extractVendors(from: lines)
            let dateCandidates = Self.extractDates(from: lines)

            completion(.success(OCRResult(fullText: fullText,
                                          amountCandidates: amountCandidates,
                                          vendorCandidates: vendorCandidates,
                                          dateCandidates: dateCandidates)))
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do { try handler.perform([request]) } catch { completion(.failure(error)) }
        }
    }

    private static func extractAmounts(from lines: [String]) -> [Decimal] {
        let amountRegex = try! NSRegularExpression(pattern: "(?<![\n\w])([0-9]{1,3}(?:,[0-9]{3})*(?:\\.[0-9]{2})|[0-9]+\\.[0-9]{2})(?![\n\w])")
        var found = [Decimal]()
        for line in lines {
            let range = NSRange(line.startIndex..<line.endIndex, in: line)
            amountRegex.enumerateMatches(in: line, options: [], range: range) { match, _, _ in
                if let m = match, let r = Range(m.range(at: 1), in: line) {
                    let raw = line[r].replacingOccurrences(of: ",", with: "")
                    if let dec = Decimal(string: raw) { found.append(dec) }
                }
            }
        }
        // Heuristic: return unique, sorted descending (largest likely total)
        let unique = Array(Set(found))
        return unique.sorted(by: >)
    }

    private static func extractVendors(from lines: [String]) -> [String] {
        // Heuristics: first 3 lines, prefer uppercase words without digits
        let candidates = lines.prefix(5)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .filter { $0.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil }
        return Array(Set(candidates)).prefix(3).map { String($0) }
    }

    private static func extractDates(from lines: [String]) -> [Date] {
        let formats = [
            "yyyy-MM-dd", "MM/dd/yyyy", "dd/MM/yyyy", "MMM d, yyyy", "d MMM yyyy"
        ]
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        var results: [Date] = []
        for line in lines {
            for fmt in formats {
                dateFormatter.dateFormat = fmt
                if let d = dateFormatter.date(from: line.trimmingCharacters(in: .whitespaces)) {
                    results.append(d)
                }
            }
        }
        return results
    }
}



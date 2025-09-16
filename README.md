# ExpenseTracker (iOS)

A SwiftUI iOS expense tracking app featuring:

- Receipt photo capture with automatic expense categorization (VisionKit + Vision)
- Manual expense entry with category selection and notes
- Monthly budget setting with spending limit alerts
- Visual spending analytics with category breakdowns (Charts)
- Local data storage with Core Data

## Requirements

- iOS 16+
- Xcode 15+ (for building/running)

You mentioned you don't have a Mac. You can still use this repo and build the app using one of the options below.

## No-Mac build options (choose one)

1. GitHub Actions (macOS runners)
   - This repo includes a workflow in `.github/workflows/ios-build.yml`.
   - Push to GitHub, the workflow will: install XcodeGen, generate the Xcode project from `project.yml`, then build with `xcodebuild`.
   - Artifacts: app build logs; you can extend the workflow to export an `.ipa` with a signing setup.

2. Cloud CI with signing (Codemagic/Bitrise/AppCenter)
   - Import the repository and configure signing (Apple Developer account).
   - Use `project.yml` to generate the project as a pre-build step (install XcodeGen).

3. Rent a remote macOS (MacStadium/MacInCloud)
   - Remote into a Mac, open the project after generating it with XcodeGen, and run on Simulator.

## Project structure

```
.
├─ project.yml                # XcodeGen project definition
├─ App/
│  ├─ ExpenseTrackerApp.swift
│  └─ PersistenceController.swift
├─ Models/
│  ├─ Expense.swift
│  ├─ Category.swift
│  └─ Budget.swift
├─ Services/
│  ├─ OCRService.swift
│  ├─ CategorizationService.swift
│  └─ BudgetManager.swift
├─ Views/
│  ├─ ContentView.swift
│  ├─ ExpenseListView.swift
│  ├─ AddExpenseView.swift
│  ├─ ScanReceiptView.swift
│  └─ AnalyticsView.swift
└─ .github/workflows/ios-build.yml
```

## Generate Xcode project locally (on macOS)

This repository uses XcodeGen so you don't have to commit `.xcodeproj` files.

```bash
brew install xcodegen
xcodegen generate
open ExpenseTracker.xcodeproj
```

## Run

1. Select the `ExpenseTracker` scheme
2. Target any iOS 16+ simulator
3. Run

## Notes

- OCR and document scanning require Camera permissions on device.
- Charts requires iOS 16+.
- Core Data stack and model are defined in code (no `.xcdatamodeld`).

## Roadmap

- Improve auto-categorization with on-device ML or rules training
- Export/import data (JSON/CSV)
- iCloud sync (CloudKit)



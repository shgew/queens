# Queens

An iOS puzzle game based on the N-Queens problem. Place N queens on an N×N chessboard so that no two queens threaten each other, i.e. no shared row, column, or diagonal.

## Requirements

- Xcode 26+
- iOS 26+
- macOS 26+ (for local package tests)

## Build

1. Open `Queens.xcodeproj` in Xcode.
2. Select the `Queens` scheme.
3. Select an iOS Simulator target.
4. Build with `Cmd+B`.

## Run

1. Open `Queens.xcodeproj`.
2. Select `Queens` + an iOS Simulator.
3. Run with `Cmd+R`.

## Test

1. Open `Queens.xcodeproj`.
2. Select the `Queens` scheme.
3. Run tests with `Cmd+U`.

## Gameplay

- [x] Select board size (`4...32`)
- [x] Tap to place or remove queens
- [x] Real-time conflict highlighting
- [x] Win screen on solve

## UI

- [x] Dynamic chessboard for any board size
- [x] Queens visually distinct
- [x] Conflicting placements clearly marked
- [x] Simple, clean, extensible design

## Nice-to-Haves

- [x] Queens-left counter
- [x] Restart / reset
- [x] Best times per board size
- [x] SFX and animations on placement and victory

## Submission Checklist

- [x] README includes how to build, run, and test
- [x] README includes architecture decisions
- [x] Built with Swift + SwiftUI
- [ ] Short app demo video

## Architecture Decisions

- Feature UI is under `Queens/Features/*` and feature logic sits in view models, keeping views declarative.
- Core domain logic is separated into local Swift packages:
  - `Board`: board state and moves
  - `Problems`: puzzle evaluation (`NQueensProblem`)
  - `Game`: session orchestration (`board + problem + history + timing`)
  - `GameAudio`: sound playback abstraction and implementation
  - `Logging`: shared logging helpers
- Persistence for best times uses `UserDefaults` behind the `BestTimesStoring` protocol to keep storage swappable in tests/previews.
- Conflict highlighting is computed in the domain layer (`NQueensProblem.Diagnostic`) and only rendered in UI.

## Testing Strategy

- View-model tests validate gameplay flow and win interactions.
- Store tests validate best-time persistence rules (new-best replacement and board-size separation).
- Package tests validate low-level modules (`Board`, `Game`) and N-Queens correctness scenarios.
- Performance checks for N-Queens conflict evaluation live in benchmark XCTest cases.

## Code Generation Disclosure

AI assistance was used during development/review for refactoring suggestions and test generation, with all final code manually reviewed and owned.

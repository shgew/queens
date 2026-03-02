# Queens

An iOS puzzle game based on the N-Queens problem. Place N queens on an N×N chessboard so that no two queens threaten each other — no shared row, column, or diagonal.

> While we don't mind you leverage modern code generation tools, we expect you to fully understand and own 100% of the code and disclose the extent of their use in your workflow.

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

Xcode:

1. Open `Queens.xcodeproj`.
2. Select the `Queens` scheme.
3. Run tests with `Cmd+U`.

Swift Package Manager (package-level tests):

- `swift test --package-path Dependencies/Board`
- `swift test --package-path Dependencies/Game`
- `swift test --package-path Dependencies/Problems`

## Gameplay

- Select board size (`4...32`)
- Tap to place or remove queens
- Real-time conflict highlighting
- Win screen on solve

## UI

- Dynamic chessboard for any board size
- Queens visually distinct (♛ or icon)
- Conflicting placements clearly marked
- Simple, clean, extensible design

## Nice-to-Haves

- Queens-left counter
- Restart / reset
- Best times per board size
- SFX and animations on placement and victory

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

- View-model tests validate gameplay flow, win interactions, and elapsed-time formatting.
- Store tests validate best-time persistence rules (new-best replacement and board-size separation).
- Package tests validate low-level modules (`Board`, `Game`) and N-Queens correctness scenarios.
- Performance checks for N-Queens conflict evaluation live in benchmark-oriented XCTest cases.

## Code Generation Disclosure

- No generated production code is checked into this repository.
- AI assistance was used during development/review for refactoring suggestions and test authoring, with all final code manually reviewed and owned.

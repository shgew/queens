import SwiftUI

struct ConfettiBurstView: View {
    @State private var startedAt = Date()
    @State private var particles: [Particle] = []

    var body: some View {
        GeometryReader { proxy in
            TimelineView(.animation(minimumInterval: 1.0 / 45.0)) { timeline in
                let elapsed = timeline.date.timeIntervalSince(startedAt)

                ZStack {
                    ForEach(particles) { particle in
                        if let frame = particle.frame(at: elapsed, in: proxy.size) {
                            RoundedRectangle(cornerRadius: 1.5)
                                .fill(particle.color)
                                .frame(width: particle.size, height: particle.size * 0.65)
                                .rotationEffect(.radians(frame.rotation))
                                .position(x: frame.x, y: frame.y)
                                .opacity(frame.opacity)
                        }
                    }
                }
            }
            .onAppear {
                startedAt = .now
                particles = Particle.makeBatch(count: 140)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

private struct Particle: Identifiable {
    struct Frame {
        let x: CGFloat
        let y: CGFloat
        let rotation: Double
        let opacity: Double
    }

    let id: Int
    let startX: CGFloat
    let startY: CGFloat
    let delay: Double
    let speed: CGFloat
    let drift: CGFloat
    let phase: Double
    let spin: Double
    let size: CGFloat
    let color: Color

    func frame(at elapsed: TimeInterval, in size: CGSize) -> Frame? {
        let t = elapsed - delay
        guard t >= 0, t <= 3.0 else { return nil }

        let x = startX * size.width + drift * sin((t * 2.0) + phase)
        let y = startY + speed * t + 58 * t * t
        let opacity = max(0, 1 - (t / 3.0))
        return Frame(x: x, y: y, rotation: spin * t, opacity: opacity)
    }

    static func makeBatch(count: Int) -> [Self] {
        var generator = SystemRandomNumberGenerator()
        let palette: [Color] = [.pink, .yellow, .green, .blue, .orange]

        return (0..<count).map { index in
            Particle(
                id: index,
                startX: .random(in: 0...1, using: &generator),
                startY: .random(in: -26...6, using: &generator),
                delay: .random(in: 0...0.3, using: &generator),
                speed: .random(in: 150...240, using: &generator),
                drift: .random(in: -52...52, using: &generator),
                phase: .random(in: 0...(2 * .pi), using: &generator),
                spin: .random(in: -8...8, using: &generator),
                size: .random(in: 4...8, using: &generator),
                color: palette.randomElement(using: &generator) ?? .pink
            )
        }
    }
}

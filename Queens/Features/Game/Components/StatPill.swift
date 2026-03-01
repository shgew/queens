import SwiftUI

struct StatPill: View {
  var systemImage: String
  var value: String

  var body: some View {
    Label {
      Text(value)
        .font(.title3.bold())
        .monospacedDigit()
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .allowsTightening(true)
    } icon: {
      Image(systemName: systemImage)
        .font(.subheadline.weight(.semibold))
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(12)
    .glassEffect(.regular, in: .rect(cornerRadius: 14.0))
  }
}

#Preview {
  HStack(spacing: 12) {
    StatPill(systemImage: "crown", value: "5")
    StatPill(systemImage: "clock", value: "01:23")
  }
  .padding()
}

import SwiftUI

struct StatPill: View {
    var systemImage: String
    var value: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title2.bold().monospaced())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    HStack(spacing: 12) {
        StatPill(systemImage: "crown", value: "5")
        StatPill(systemImage: "clock", value: "01:23")
    }
    .padding()
}

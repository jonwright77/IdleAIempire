import SwiftUI

struct AchievementsView: View {
    @ObservedObject var vm: GameViewModel

    private var unlockedCount: Int { vm.state.achievements.filter { $0.unlocked }.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("AWARDS")
                    .font(.caption)
                    .tracking(4)
                    .foregroundColor(.neonCyan.opacity(0.7))
                Spacer()
                Text("\(unlockedCount) / \(vm.state.achievements.count)")
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundColor(.textMuted)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            ScrollView {
                VStack(spacing: 8) {
                    ForEach(vm.state.achievements) { achievement in
                        AchievementRow(achievement: achievement)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

private struct AchievementRow: View {
    let achievement: Achievement

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: achievement.icon)
                .font(.title2)
                .foregroundColor(achievement.unlocked ? .neonCyan : .textMuted)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 3) {
                Text(achievement.name)
                    .font(.headline)
                    .foregroundColor(achievement.unlocked ? .white : .textMuted)
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.textMuted)
            }

            Spacer()

            if achievement.unlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.neonCyan)
                    .font(.callout)
            }
        }
        .padding(14)
        .background(Color.bgCard)
        .cornerRadius(12)
        .opacity(achievement.unlocked ? 1 : 0.45)
    }
}

// MARK: - Toast

struct AchievementToast: View {
    let achievement: Achievement

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: achievement.icon)
                .font(.title3)
                .foregroundColor(.neonCyan)

            VStack(alignment: .leading, spacing: 2) {
                Text("ACHIEVEMENT UNLOCKED")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .tracking(1)
                    .foregroundColor(.neonCyan.opacity(0.7))
                Text(achievement.name)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.bgCard)
        .cornerRadius(12)
        .shadow(color: .neonCyan.opacity(0.25), radius: 12)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

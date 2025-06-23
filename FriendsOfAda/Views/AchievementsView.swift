import SwiftUI

struct AchievementsView: View {
    let earnedAchievements: Set<Achievement>
    @Environment(\.dismiss) private var dismiss

    private let columns = [GridItem(.adaptive(minimum: 120), spacing: 15)]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Achievement.allCases, id: \.self) { achievement in
                        let isEarned = earnedAchievements.contains(achievement)
                        VStack(spacing: 8) {
                            Image(systemName: achievement.iconName)
                                .font(.system(size: 44))
                                .foregroundColor(isEarned ? .yellow : Color.gray.opacity(0.4))
                                .padding(10)
                                .background(
                                    (isEarned ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.15))
                                        .clipShape(Circle())
                                )

                            Text(achievement.title)
                                .font(.headline)
                                .foregroundColor(isEarned ? .primary : .secondary)
                            
                            Text(achievement.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(10)
                        .frame(minHeight: 180)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(15)
                        .opacity(isEarned ? 1.0 : 0.7)
                    }
                }
                .padding()
            }
            .navigationTitle("Achievements")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView(earnedAchievements: [.firstFeed, .mathGenius])
    }
} 
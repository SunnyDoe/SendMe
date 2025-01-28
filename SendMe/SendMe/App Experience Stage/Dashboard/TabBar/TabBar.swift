import Foundation
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            ForEach(0..<4) { index in
                Spacer()
                TabBarItem(
                    icon: tabBarItems[index].icon,
                    title: tabBarItems[index].title,
                    isSelected: selectedTab == index
                ) {
                    selectedTab = index
                }
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .overlay(Divider(), alignment: .top)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(title)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
        }
    }
}

struct TabBarItemModel {
    let icon: String
    let title: String
}

let tabBarItems = [
    TabBarItemModel(icon: "house.fill", title: "Home"),
    TabBarItemModel(icon: "arrow.left.arrow.right", title: "Transfer"),
    TabBarItemModel(icon: "chart.bar.fill", title: "Analytics"),
    TabBarItemModel(icon: "person.fill", title: "Profile")
] 

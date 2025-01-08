import Foundation

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
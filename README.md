# 🚀 SendMe App

Financial app that helps you request or send money with ease!

SendMe is a Swift-based iOS application designed to facilitate seamless money transfers and social interactions. The app leverages modern SwiftUI and MVVM architecture to provide a clean and efficient user experience.

## ✨ Features

- 💸 **Money Transfer**: Send and request money with ease.
- 📊 **Recent Transactions & Charts**: View recent transactions and analyze your **monthly expenses** with interactive charts.
- 📈 **Expense Analytics**: Get insights into your spending habits with **time-based analytics** (1 week, 1, 3, 6 months, 1 year, or all-time) for categories like **bills, entertainment, eating out**, etc.
- 🔒 **Secure Storage**: Use **Keychain** to securely store sensitive information.
- ⏱️ **Real-time Updates**: Get real-time updates on transactions and balances.
- 🏠 **Profile Customization**: Manage your **User Data, Payment Methods, Pro Status Upgrades, Marketing Notifications, Privacy Settings,** and more.
- 🤝 **Invite Friends**: Share a unique invite link with friends and earn rewards.
  
## 🏗️ Architecture

The app follows the MVVM (Model-View-ViewModel) pattern, ensuring a clear separation of concerns and making the codebase more maintainable and testable.

## 🛠️ Key Components

- **ViewModels**: Handle business logic and data manipulation.
- **Views**: SwiftUI views for user interface.
- **Utilities**: Helper classes like `KeychainManager` for secure data storage.

## 📚 Frameworks and Technologies

- **SwiftUI**: For building the user interface.
- **UIKit**: Used for certain UI components and interactions.
- **FirebaseFirestore**: For real-time database and data synchronization.
- **FirebaseAuth**: For user authentication.
- **Combine**: For handling asynchronous events and data streams.
- **Security**: For secure data storage using Keychain.
- **Charts**: For visualizing data in a user-friendly manner.
- **UserDefaults**: For storing simple user preferences and settings.

## 🛠️ Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/SunnyDoe/sendme.git
   ```
2. Open the project in Xcode:
   ```bash
   cd sendme
   open SendMe.xcodeproj
   ```
3. Install dependencies using CocoaPods or Swift Package Manager if needed.

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request for review.

## 📧 Contact

For questions or support, please contact me directly.

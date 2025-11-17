Pulse - Cryptocurrency Wallet & Card UI

A beautifully designed iOS app built with SwiftUI that combines cryptocurrency wallet management with a sleek digital card interface. Pulse offers an intuitive way to manage your crypto assets, track your portfolio, and control your spending all wrapped in a modern, glassmorphic design.

Features

### 💳 Digital Card Management
- **Interactive Card View**: Flip animation to reveal card details with smooth transitions
- **Card Controls**: Freeze/unfreeze your card instantly for added security
- **Spending Limits**: Set and monitor daily, weekly, and monthly spending limits
- **Payment Controls**: Toggle online payments, tap-and-pay, chip & PIN, and spending controls
- **Sticky Card Animation**: Elegant parallax effect as you scroll through the interface

### 💰 Wallet & Portfolio
- **Multi-Token Support**: Manage multiple cryptocurrencies including SOL, BTC, ETH, BNB, and more
- **Portfolio Overview**: Real-time portfolio value tracking with 24h change indicators
- **Token Management**: Add, remove, and organize your crypto holdings
- **Price Tracking**: Live price updates with 24-hour change percentages
- **Currency Conversion**: Built-in currency converter for seamless transactions

### 📊 Analytics & Insights
- **Portfolio Analytics**: Comprehensive analytics dashboard with interactive charts
- **Performance Metrics**: Track total gains, best performers, and portfolio statistics
- **Token Distribution**: Visual breakdown of your asset allocation
- **Timeframe Analysis**: View performance across 1D, 7D, 30D, 90D, and all-time periods
- **Price Charts**: Individual token price charts with historical data

### 🔄 Transactions
- **Send & Receive**: Quick actions to send and receive cryptocurrencies
- **Swap Functionality**: Exchange tokens directly within the app
- **Transaction History**: Complete transaction log with detailed information
- **Transaction Export**: Export your transaction history for record-keeping
- **Activity Feed**: Recent activity preview with full transaction details

### 🔐 Security & Authentication
- **Biometric Authentication**: Secure access with Face ID or Touch ID
- **Auto-Lock**: Automatic re-authentication when the app enters foreground
- **Onboarding Flow**: Smooth first-time user experience
- **Card Security**: Freeze card instantly if lost or stolen

### 🎨 Design & UX
- **Glassmorphism UI**: Modern frosted glass effects throughout the app
- **Liquid Glass Tab Bar**: Custom animated tab bar with glass morphism
- **Dark Theme**: Beautiful dark color scheme with purple and gold accents
- **Smooth Animations**: Spring-based animations for a premium feel
- **Haptic Feedback**: Tactile responses for better user interaction

## 🛠️ Tech Stack

- **SwiftUI**: Modern declarative UI framework
- **iOS 15+**: Built for the latest iOS features
- **Combine**: Reactive programming for state management
- **UIKit Integration**: Seamless integration where needed
- **Custom Modifiers**: Reusable glassmorphism and liquid glass effects

## 📱 Screenshots

*Add your screenshots here to showcase the beautiful UI*

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0+ deployment target
- macOS 12.0 or later (for development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/Pulse.git
cd Pulse
```

2. Open the project in Xcode:
```bash
open PhantomCardUI.xcodeproj
```

3. Build and run the project in Xcode (⌘R)

## 📁 Project Structure

```
PhantomCardUI/
├── App Core/              # App entry point and state management
├── Card Screen/           # Digital card interface and controls
├── Home/                  # Wallet and portfolio views
│   └── Wallet Screen/     # Main wallet functionality
├── Analytics/             # Portfolio analytics and charts
├── Components/            # Reusable UI components
├── Models/                # Data models
├── Sheets/                # Modal sheets and overlays
└── Utilities/             # Helpers, formatters, and extensions
```

## 🎯 Key Components

- **AppStateManager**: Centralized app state management
- **PriceService**: Real-time price fetching and caching
- **CurrencyFormatter**: Consistent currency formatting
- **BiometricAuth**: Secure authentication handling
- **GlassmorphismModifier**: Custom glass effect modifiers
- **ErrorHandler**: Global error handling system

## 🔧 Configuration

The app uses mock data for demonstration purposes. To integrate with real APIs:

1. Update `PriceService.swift` with your API endpoints
2. Configure authentication in `BiometricAuth.swift`
3. Set up your backend connection in `AppStateManager.swift`

## 🎨 Customization

### Colors
Edit `AppColors.swift` to customize the color scheme:
- `deepDark`: Background color
- `phantomPurple`: Primary accent color
- `phantomGold`: Secondary accent color

### Tokens
Add or modify supported tokens in `Token.swift` under the `topCryptocurrencies` array.

## 📝 License

This project is available for personal use. Feel free to explore the code and learn from it!

## 👨‍💻 Author

**Muhammad Bilal Siddiqui**

Created with ❤️ using SwiftUI

## 🙏 Acknowledgments

- Inspired by modern fintech app designs
- Built with SwiftUI best practices
- Glassmorphism design patterns from contemporary UI trends

---

*Note: This is a UI demonstration project. For production use, ensure proper backend integration, security measures, and compliance with financial regulations.*


# Medical Calculator Flutter App

A native Android medical billing calculator app built with Flutter, converted from the original Flask web application.

## Features

- **Patient Type Selection**: Choose from 11 different billing categories (Local, GCC, Resident, etc.)
- **Service Item Management**: Add multiple service items with charge codes
- **Real-time Price Lookup**: Automatic price fetching based on charge codes and patient type
- **Quantity & Discount**: Adjust quantities and apply discounts per item
- **Receipt Generation**: Generate detailed collection receipts
- **Native Android UI**: Optimized for mobile devices

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio or VS Code with Flutter extensions
- Android device or emulator for testing

## Setup Instructions

1. **Clone/Copy the project**:
   ```bash
   cd medical_calculator_flutter
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify Flutter setup**:
   ```bash
   flutter doctor
   ```

4. **Connect Android device or start emulator**

5. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── charge_item.dart      # Charge item data model
│   └── bill_item.dart        # Bill item data model
├── services/
│   └── data_service.dart     # CSV data loading service
├── screens/
│   ├── calculator_screen.dart # Main calculator interface
│   └── receipt_screen.dart    # Receipt display screen
├── widgets/
│   └── service_item_card.dart # Service item input widget
└── utils/
    └── patient_types.dart     # Patient type definitions

assets/
└── data/
    └── Price List as of 03-07-2024.csv # Medical pricing data
```

## Key Components

### Data Models
- **ChargeItem**: Represents medical service with pricing for different patient types
- **BillItem**: Represents a billed service item with quantity and calculations
- **ServiceItem**: Working model for service input forms

### Services
- **DataService**: Singleton service for loading and querying CSV pricing data

### UI Components
- **CalculatorScreen**: Main interface for entering billing information
- **ServiceItemCard**: Reusable widget for service item input
- **ReceiptScreen**: Formatted receipt display

## Usage

1. **Select Patient Type**: Choose the appropriate billing category from the dropdown
2. **Enter Service Code**: Input the medical service charge code
3. **Review Auto-filled Data**: Service description, category, and rate are populated automatically
4. **Adjust Quantity/Discount**: Modify as needed
5. **Add More Services**: Use "Add Service Item" button for multiple services
6. **Generate Receipt**: Tap "Generate Collection Receipt" to view the formatted receipt

## Data Format

The app uses the same CSV data format as the original Flask application:
- Charge codes are numeric identifiers
- Pricing varies by patient type (Local, GCC, Resident, etc.)
- Categories include pharmaceuticals, supplies, and services

## Building for Release

1. **Build APK**:
   ```bash
   flutter build apk --release
   ```

2. **Build App Bundle** (for Play Store):
   ```bash
   flutter build appbundle --release
   ```

## Troubleshooting

- **Data not loading**: Ensure the CSV file is in `assets/data/` and listed in `pubspec.yaml`
- **Build errors**: Run `flutter clean` then `flutter pub get`
- **Android issues**: Check `flutter doctor` for Android SDK/tools setup

## Differences from Web Version

- **Offline Operation**: All data loaded locally, no server required
- **Touch-optimized UI**: Larger buttons and touch targets
- **Mobile Navigation**: Native Android navigation patterns
- **Performance**: Optimized for mobile devices

## Future Enhancements

- Receipt sharing functionality
- Data export options
- Offline data synchronization
- Multi-language support
- Dark mode theme
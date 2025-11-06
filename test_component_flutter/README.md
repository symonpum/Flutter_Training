# test_component_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Skip to main content
Google Classroom
Classroom
Flutter Course
Home
Calendar
Teaching
To review
C
C Programing
Input & Output
S
Sales Modules
Sales Module 1
Enrolled
To-do
F
Flutter Course
Archived classes
Settings
Stream
Classwork
People
Flutter Course
Upcoming
Woohoo, no work due soon!

Post by Leav Chandara
Leav Chandara
Created Oct 19Oct 19
Video in the morning: https://drive.google.com/file/d/15VUj9z5sjBBye0LzRG_FFQv2tvukSDoh/view
Video in the afternoon: https://drive.google.com/file/d/1HFxwKl2JuWte9HiLy2i_e84o0OgFaHfZ/view
Assignment: "Project: Food Delivery App "
Leav Chandara posted a new assignment: Project: Food Delivery App
Created Oct 19Oct 19 (Edited Oct 19)

Post by Leav Chandara
Leav Chandara
Created Oct 19Oct 19 (Edited Oct 19)
Project: Food Delivery 
Noted: Student will get reward if complete the project in 2 weeks or before 2 weeks with complete functionality app 

Award: 20$ 

Deadline: 02 Nov 2025

Structure Project: 
.
├── main.dart
├── models
│   ├── address.dart
│   ├── food_item.dart
│   ├── order.dart
│   ├── restaurant.dart
│   └── review.dart
├── providers
│   ├── cart_provider.dart
│   └── order_provider.dart
├── screens
│   ├── cart_screen.dart
│   ├── checkout_screen.dart
│   ├── location_picker_screen.dart
│   ├── menu_screen.dart
│   ├── order_success_screen.dart
│   ├── order_tracking_screen.dart
│   ├── restaurant_detail_screen.dart
│   ├── restaurant_list_screen.dart
│   └── reviews_screen.dart
├── services
│   ├── location_service.dart
│   ├── order_service.dart
│   ├── payment_service.dart
│   ├── restaurant_service.dart
│   └── review_service.dart
└── widgets
    ├── cart_item_widget.dart
    ├── food_item_card.dart
    ├── location_selector.dart
    ├── mini_map_widget.dart
    ├── rating_widget.dart
    └── restaurant_card.dart
============================================================

Rule Student must follow: 
- state management: ValueNotifier, setState(), ChangeNotifier, 
- state management exclude: provider, riverpod, bloc, bloc cubit, getx, 
- students are free to use AI for help

===============

Theme: 


import 'package:flutter/material.dart';
import 'screens/restaurant_list_screen.dart';

void main() {
runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
const FoodDeliveryApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Food Delivery App',
debugShowCheckedModeBanner: false,
theme: ThemeData(
primarySwatch: Colors.green,
colorScheme: ColorScheme.fromSeed(
seedColor: Colors.green,
brightness: Brightness.light,
),
useMaterial3: true,
appBarTheme: const AppBarTheme(
backgroundColor: Colors.green,
foregroundColor: Colors.white,
elevation: 2,
),
elevatedButtonTheme: ElevatedButtonThemeData(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.green,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
),
cardTheme: const CardThemeData(
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.all(Radius.circular(12)),
),
),
inputDecorationTheme: InputDecorationTheme(
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(8),
borderSide: const BorderSide(color: Colors.green, width: 2),
),
),
),
home: const RestaurantListScreen(),
);
}
}
respository.zip
Compressed archive

pubspec.yaml
Unknown

README.student.md
Text

food_delivery_project_figure.zip
Compressed archive


Post by Leav Chandara
Leav Chandara
Created Oct 12Oct 12 (Edited Oct 12)
Video Record

Morning: https://drive.google.com/file/d/1tJ8SWpJijH6ZoU-mHbbgWG5ckcWciUZ1/view?usp=sharing
Afternoon: https://drive.google.com/file/d/1vnnva58KeEGhxDwXQUnB5AO7sbXIN3M3/view?usp=sharing

Post by Leav Chandara
Leav Chandara
Created Oct 12Oct 12
Gang Of Four: https://docs.google.com/document/d/1_Z0-WA2Lhw1aT2u3t0sepTStiKiF031YWvq2GoMY6pk/edit?tab=t.0

Post by Leav Chandara
Leav Chandara
Created Sep 15Sep 15
Week6 
video: 
1. Morning: https://drive.google.com/file/d/1eUiHJaBquhaN2Uf3CwXcF3biL4tLySZ9/view
2. Afternoon: https://drive.google.com/file/d/1zNlchjDo6XV1LdoHV6r9jNSSEzKMKm2I/view

Post by Leav Chandara
Leav Chandara
Created Sep 15Sep 15
Book I just bought:
Flutter Mastery-The Ultimate 2300 Pages Guide from Beginner to Expert 1.pdf
PDF

Assignment: "Practice Exercise"
Leav Chandara posted a new assignment: Practice Exercise
Created Sep 8Sep 8 (Edited Sep 19)
Material: "Lesson All Session"
Leav Chandara posted a new material: Lesson All Session
Created Sep 7Sep 7

Post by Leav Chandara
Leav Chandara
Created Sep 7Sep 7
Lesson Widget Beginner: https://docs.google.com/document/d/1FRqVjhaWYTyBqOi3CQZsECDcuu0YDI_DHN5Na6JiLDI/edit?usp=sharing

Lesson Widget Intermediate: https://docs.google.com/document/d/1-Qxs-9HL3VHhDP8Fp2SJaLOP6rRtc2FPlS_ZL6LE1Eo/edit?tab=t.0

Lesson Widget Advance: https://docs.google.com/document/d/1IC8rTLgMM1zbr6YqPVt1WSmm5lbgHr5JuNbc04iKiXA/edit?tab=t.0

Post by Leav Chandara
Leav Chandara
Created Sep 4Sep 4
Research Topic: https://aloisdeniel.com/blog/hidden-gems-in-my-flutter-toolbox

Post by Leav Chandara
Leav Chandara
Created Sep 1Sep 1
Shadow Tool:  https://shadow-generator-mobile.vercel.app/#editor
Assignment: "Beginner Project"
Leav Chandara posted a new assignment: Beginner Project
Created Sep 1Sep 1

Post by Leav Chandara
Leav Chandara
Created Sep 1Sep 1 (Edited Sep 1)
New Assignment: Watch, Code, & Record! 📢

Hi everyone,
Please read the instructions for your next assignment carefully.
Step 1: Watch the Video
Please watch the tutorial video found at this link: [Insert Video Link Here]
Step 2: Code Along 👨‍💻
Follow the instructions in the video and write the code exactly as shown.
Step 3: Record Your Work 📹
Once you have finished and your code is working, please record a short video of your screen demonstrating the final result.
Step 4: Submit
Please send me your completed video recording.
If you have any questions, feel free to reach out. Good luck and Enjoy your day with coding 


6. MiCard - How to Build Beautiful UIs with Flutter Widgets: https://drive.google.com/drive/folders/1eZJVwCl7lfErzXSS8TrYz0UAadZzbu8L?usp=drive_link



9.Xylophone: https://drive.google.com/drive/folders/1br550MUJrr3dlpP-q8mjMJhwyQl_B_63?usp=drive_link


12.BMI-Calculation: https://drive.google.com/drive/folders/1rDcTx0Ufad4b5WvbWVW2B1Yb0xfB9mGe?usp=drive_link
Material: "Git Usage"
Leav Chandara posted a new material: Git Usage
Created Aug 31Aug 31
Assignment: "Assignment Widget Begginer"
Leav Chandara posted a new assignment: Assignment Widget Begginer
Created Aug 24Aug 24 (Edited Aug 30)
Material: "Free UI"
Leav Chandara posted a new material: Free UI
Created Aug 23Aug 23
Material: "Job Opportunity (Remote)"
Leav Chandara posted a new material: Job Opportunity (Remote)
Created Aug 23Aug 23
Material: "Free UI Figma"
Leav Chandara posted a new material: Free UI Figma
Created Aug 23Aug 23
Material: "Widget Flutter (Beginner,Intermediate,Advance)"
Leav Chandara posted a new material: Widget Flutter (Beginner,Intermediate,Advance)
Created Aug 23Aug 23

Post by Symon Pum
Symon Pum
Created Aug 18Aug 18
Link Download a Completed SDKs​ for Flutter Development:

សូមដោនឡូតនៅកន្លែង Internet លឿន ឬហាងកាហ្វ! 
កុំដោនឡូតក្នុងថ្នាក់រៀនយើង!!
Flutter_Programing.7z
Unknown

Assignment: "Assignment Dart Fundamental"
Leav Chandara posted a new assignment: Assignment Dart Fundamental
Created Aug 10Aug 10 (Edited Sep 15)
Material: "Flutter Books"
Leav Chandara posted a new material: Flutter Books
Created Aug 10Aug 10
Assignment: "Exercise Basic Dart Programing Part 01"
Leav Chandara posted a new assignment: Exercise Basic Dart Programing Part 01
Created Aug 7Aug 7 (Edited Aug 10)
Material: "Basic Dart Programing"
Leav Chandara posted a new material: Basic Dart Programing
Created Aug 3Aug 3 (Edited Aug 3)
Flutter Course
# Food Delivery App

A comprehensive food delivery platform built with Flutter featuring restaurant browsing, menu display, cart management, order tracking, payment integration, reviews and ratings, and delivery tracking.

## 🚀 Features

### Core Features

- **Restaurant Browsing**: Browse restaurants with filtering by category, search, and location-based sorting
- **Menu Display with Categories**: Organized menu items with categorized tabs and search functionality
- **Cart Management**: Add items to cart, modify quantities, special instructions, and minimum order validation
- **Order Tracking**: Real-time order status updates with progress tracking and estimated delivery times
- **Payment Integration**: Multiple payment methods, secure payment processing, and payment validation
- **Reviews and Ratings**: Star ratings, detailed reviews, and review submission functionality
- **Delivery Tracking**: Driver information, location tracking, and delivery updates

### Additional Features

- **Error Handling**: Comprehensive error handling for network issues, empty states, and unexpected errors
- **State Management**: Implemented using ValueNotifier and setState() for efficient state management
- **Location Services**: GPS location detection, address autocomplete, and distance calculation
- **Responsive UI**: Modern Material Design with consistent theming and animations
- **Mock Data**: Realistic mock data for testing and demonstration

## 📱 Screens

### 1. Restaurant List Screen (`restaurant_list_screen.dart`)

- Display list of available restaurants
- Search functionality
- Category filtering
- Location-based sorting
- Restaurant cards with ratings, delivery info, and status

### 2. Restaurant Detail Screen (`restaurant_detail_screen.dart`)

- Restaurant information and images
- Menu categories with tabbed navigation
- Add items to cart functionality
- Reviews and ratings display
- Restaurant info cards (delivery time, fee, minimum order)

### 3. Menu Screen (`menu_screen.dart`)

- Detailed menu item display
- Search through menu items
- Category-wise organization
- Item details with ingredients and dietary information
- Quantity selection and special instructions

### 4. Cart Screen (`cart_screen.dart`)

- Display cart items with images
- Quantity controls (add/remove items)
- Special instructions for items
- Order summary with price breakdown
- Minimum order validation
- Proceed to checkout

### 5. Checkout Screen (`checkout_screen.dart`)

- Delivery address input with current location
- Payment method selection
- Add new payment methods
- Special instructions for order
- Order total and place order functionality
- Payment processing

### 6. Order Tracking Screen (`order_tracking_screen.dart`)

- Real-time order status updates
- Order progress visualization
- Driver information and contact
- Order details and items
- Cancel order functionality
- Estimated delivery time

### 7. Reviews Screen (`reviews_screen.dart`)

- Display restaurant reviews and ratings
- Rating breakdown and statistics
- Write new reviews with star ratings
- Review photos and helpful votes
- Average rating calculation

## 🏗️ Architecture

### Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/                            # Data models
│   ├── restaurant.dart               # Restaurant model
│   ├── food_item.dart               # Food item and cart item models
│   ├── order.dart                   # Order model with status enum
│   └── review.dart                  # Review model
├── services/                         # Business logic and API services
│   ├── restaurant_service.dart      # Restaurant data and menu management
│   ├── order_service.dart          # Order creation and management
│   ├── payment_service.dart        # Payment processing and validation
│   └── location_service.dart       # GPS and location services
├── screens/                         # UI screens
│   ├── restaurant_list_screen.dart  # Main restaurant listing
│   ├── restaurant_detail_screen.dart # Restaurant details and menu
│   ├── menu_screen.dart            # Detailed menu browser
│   ├── cart_screen.dart            # Shopping cart management
│   ├── checkout_screen.dart        # Order checkout and payment
│   ├── order_tracking_screen.dart  # Real-time order tracking
│   └── reviews_screen.dart         # Reviews and ratings
├── widgets/                         # Reusable UI components
│   ├── restaurant_card.dart        # Restaurant display card
│   ├── food_item_card.dart        # Food item display card
│   ├── cart_item_widget.dart      # Cart item with controls
│   └── rating_widget.dart         # Star rating components
└── providers/                       # State management
    ├── cart_provider.dart          # Cart state management
    └── order_provider.dart         # Order state management
```

### State Management

- **ValueNotifier & setState()**: Used as specified in requirements
- **CartProvider**: Manages cart items, quantities, and calculations
- **OrderProvider**: Handles order creation, tracking, and updates
- **Local Storage**: SharedPreferences for cart persistence

### Error Handling

- **Network Errors**: Retry mechanisms with user-friendly messages
- **Empty States**: Informative empty state screens
- **Validation**: Form validation and business rule checking
- **Exception Handling**: Try-catch blocks with proper error propagation
- **User Feedback**: SnackBars and dialogs for user notifications

## 🛠️ Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # HTTP client for API requests
  http: ^1.1.0

  # Location services
  geolocator: ^10.1.0
  permission_handler: ^11.0.1

  # Maps
  google_maps_flutter: ^2.5.0

  # Image handling
  cached_network_image: ^3.3.0

  # State management and utilities
  shared_preferences: ^2.2.2
  uuid: ^4.1.0

  # UI components
  flutter_rating_bar: ^4.0.1
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd food_delivery_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

#### Location Services

- iOS: Add location permissions to `ios/Runner/Info.plist`
- Android: Location permissions are automatically configured

#### Payment Integration

- The app uses mock payment services
- For production, integrate with real payment providers (Stripe, PayPal, etc.)

## 📱 Usage

### Basic Flow

1. **Browse Restaurants**

   - Open the app to see the restaurant list
   - Use search or category filters to find restaurants
   - Tap on a restaurant to view details

2. **View Menu**

   - Browse menu categories
   - Search for specific items
   - Tap items to see detailed information
   - Add items to cart with quantities and special instructions

3. **Manage Cart**

   - Review cart items
   - Modify quantities or remove items
   - Add special instructions
   - Proceed to checkout when ready

4. **Checkout Process**

   - Enter delivery address
   - Select payment method
   - Add order instructions
   - Place order and confirm payment

5. **Track Order**

   - Monitor order status in real-time
   - Contact driver when assigned
   - Receive delivery updates

6. **Review Experience**
   - Rate and review restaurants
   - View other customer reviews
   - Help others make informed decisions

### Key Features

#### Restaurant Discovery

- **Search**: Find restaurants by name or cuisine
- **Categories**: Filter by cuisine type
- **Location**: Sort by distance from your location
- **Status**: See which restaurants are open/closed

#### Menu Browsing

- **Categories**: Organized menu sections
- **Search**: Find specific dishes
- **Details**: Ingredients, dietary info, and photos
- **Customization**: Special instructions and quantity selection

#### Cart Management

- **Persistence**: Cart saved between app sessions
- **Validation**: Minimum order requirements
- **Flexibility**: Easy quantity adjustments
- **Instructions**: Item-specific special requests

#### Order Tracking

- **Real-time Updates**: Live order status
- **Progress Tracking**: Visual progress indicator
- **Driver Info**: Contact details and location
- **Communication**: Call driver functionality

#### Payment System

- **Multiple Methods**: Support for various payment types
- **Security**: Secure payment processing
- **Validation**: Card validation and error handling
- **Management**: Add/remove payment methods

## 🔧 Customization

### Adding New Features

#### New Payment Provider

1. Create service in `services/` directory
2. Implement payment interface
3. Add to checkout screen selection
4. Handle success/error states

#### Additional Restaurant Data

1. Update `Restaurant` model
2. Modify `RestaurantService` to handle new data
3. Update UI components to display new information

#### Enhanced Tracking

1. Integrate real map services
2. Add GPS tracking for drivers
3. Implement push notifications

### Styling

- Modify theme in `main.dart`
- Update component styles in widget files
- Add custom colors and typography

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Test Structure

- **Widget Tests**: UI component testing
- **Unit Tests**: Business logic testing
- **Integration Tests**: Full app flow testing

## 🚀 Deployment

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```
README.student.md
Displaying README.student.md.
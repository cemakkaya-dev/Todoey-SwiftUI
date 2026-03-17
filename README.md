# Todoey 📝

A modern, highly optimized, and beautifully designed iOS Task Management application built with Swift and Realm Database. Todoey goes beyond a simple to-do list by offering category-based organization, custom color gradients, and real-time data persistence.

## ✨ Features

* **Category Management:** Create unique categories for your tasks with automatically generated random flat colors.
* **Smart UI/UX:** * Adaptive Navigation Bar that seamlessly transitions to match the selected category's color.
  * Contrast-aware text rendering (automatically switches between dark and light text depending on background luminance for optimal readability).
  * Smooth cell gradients based on task position.
* **Native Swipe Actions:** Built-in iOS native swipe-to-delete functionality across all lists.
* **Instant Search:** Real-time filtering and querying using Realm's fast `NSPredicate` engine.
* **Data Persistence:** Offline-first architecture powered by modern Realm Database.

## 🏗 Architecture & Tech Stack

This project strictly follows **Clean Code** principles and modern iOS development standards:

* **Language:** Swift 5+ (Xcode 16+ Compatible)
* **Architecture:** MVC (Model-View-Controller) with Service/Manager Pattern.
* **Database:** `RealmSwift` using modern `@Persisted` property wrappers (No legacy `@objc dynamic` code).
* **DatabaseManager:** A centralized Singleton Service (`DatabaseManager.shared`) that completely isolates CRUD (Create, Read, Update, Delete) operations from the ViewControllers, ensuring a clean and modular codebase.
* **Extensions:** Custom UIViewController and UIColor extensions for reusable, DRY (Don't Repeat Yourself) code.

## 📸 Screenshots

| Categories | Tasks (Items) | Search & Filter |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/b353ad23-31c3-4dd8-961d-8a03fca82c38" width="250"> | <img src="[ADD_YOUR_SCREENSHOT_LINK_HERE]" width="250"> | <img src="[ADD_YOUR_SCREENSHOT_LINK_HERE]" width="250"> |

*(Note: Add your actual screenshot image links above)*

## 🛠 Installation & Setup

1. Clone this repository:
   ```bash
   git clone [https://github.com/yourusername/Todoey.git](https://github.com/yourusername/Todoey.git)

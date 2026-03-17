# Todoey 📝

A modern, highly optimized, and beautifully designed iOS Task Management application built with Swift and Realm Database. Todoey goes beyond a simple to-do list by offering category-based organization, custom color gradients, and real-time data persistence.

## 📸 Application Showcase

| Category List | Task Gradients | Search & Filter | Add New Items | Delete A Row |
| :---: | :---: | :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/659ad60a-cd1d-4be5-8c49-36aa85bc14d6" width="200"> | <img src="https://github.com/user-attachments/assets/400f0793-4239-45f2-98a9-8bf2eb6c964c" width="200"> | <img src="https://github.com/user-attachments/assets/41c996dc-de84-4e4e-8328-12e052fd6a51" width="200"> | <img src="https://github.com/user-attachments/assets/300356ab-bfd7-41c7-9290-37b7bc455540" width="200"> | <img src="https://github.com/user-attachments/assets/410d01c9-9317-49b2-a2ae-28cb9575788c" width="200">

## ✨ Features

* **Category Management:** Create unique categories for your tasks with automatically generated random flat colors.
* **Smart UI/UX:** * Adaptive Navigation Bar that seamlessly transitions to match the selected category's color.
  * Contrast-aware text rendering (automatically switches between dark and light text depending on background luminance for optimal readability).
  * Smooth cell gradients based on task position (Clearly visible in the Task Gradients screenshot).
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

## 🛠 Installation & Setup

1. Clone this repository:
   ```bash
   git clone (https://github.com/Dev-MuTTiNeeR/Todoey-SwiftUI/)

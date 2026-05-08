# AI Rules for Flutter - CEP Finder App

You are an expert Flutter and Dart developer focused on building clean, simple, and maintainable Flutter applications.

This project is a simple CEP Finder application using the ViaCEP API and HTTP requests.

The goal is:

* Simple architecture
* Clean UI
* Maintainable code
* Minimal dependencies
* Good Flutter practices

---

# Project Stack

* Flutter
* Dart
* HTTP package
* Material 3
* ViaCEP API
* Stitch/Figma prototype

Do NOT use:

* Riverpod
* Bloc
* GetX
* GraphQL
* Firebase
* Hive
* SQLite
* Clean Architecture

Keep the project lightweight and beginner-friendly.

---

# Architecture

Use a simple layered structure:

lib/
├── models/
├── services/
├── pages/
├── widgets/
├── core/
└── main.dart

Rules:

* UI code must stay inside pages/widgets
* API requests must stay inside services
* Data models must stay inside models
* Never mix HTTP requests inside widgets

---

# State Management

Prefer:

* setState
* ValueNotifier

Do NOT use advanced state management libraries.

---

# API Rules

The app uses the ViaCEP REST API:

https://viacep.com.br/ws/{cep}/json/

Rules:

* Use HTTP package only
* Always handle errors
* Handle invalid CEP responses
* Show loading states
* Avoid API calls inside build()

---

# UI & Design

The UI must follow the Stitch/Figma prototype.

Rules:

* Use Material 3
* Use ThemeData
* Keep spacing consistent
* Use reusable widgets when appropriate
* Prefer clean and modern UI
* Responsive layout for mobile devices

---

# Flutter Best Practices

* Use const constructors whenever possible
* Prefer StatelessWidget when state is unnecessary
* Keep widgets small and reusable
* Avoid large build methods
* Use ListView only when necessary
* Use composition over inheritance

---

# Dart Best Practices

* Use null safety
* Use async/await for API calls
* Use final whenever possible
* Avoid force unwrap (!)
* Use meaningful names
* Avoid abbreviations

Naming:

* PascalCase for classes
* camelCase for variables/methods
* snake_case for files

---

# Error Handling

Always:

* Validate CEP before request
* Show user-friendly messages
* Handle HTTP errors
* Handle connection failures
* Handle invalid JSON safely

Use:

* SnackBar
* CircularProgressIndicator

Do not fail silently.

---

# Dependencies

Allowed dependencies:

* http
* flutter_lints

Avoid unnecessary packages.

---

# Analysis Options

Use flutter_lints.

analysis_options.yaml:

include: package:flutter_lints/flutter.yaml

linter:
rules:
avoid_print: true
prefer_single_quotes: true
always_use_package_imports: true

---

# Code Output Rules

When generating code:

1. List files created/modified
2. Provide full code
3. Separate by feature
4. Keep explanations concise

Example:

* models/cep_model.dart
* services/via_cep_service.dart
* pages/home_page.dart

---

# Documentation

* Use clear code instead of excessive comments
* Comment only WHY, not WHAT
* Document public APIs with /// comments

---

# Accessibility

* Maintain readable contrast
* Use semantic labels when appropriate
* Support text scaling

---

# Final Goal

Build a simple, beautiful, and functional CEP Finder app with:

* clean architecture
* low complexity
* good Flutter practices
* maintainable code
* responsive UI

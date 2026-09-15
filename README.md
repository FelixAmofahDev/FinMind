# FinMind

A Flutter-based finance and inventory management app for small and medium businesses.

## Features

- **Authentication & Onboarding** — email verification, role-based login, multi-step signup
- **Sales & Products** — POS sales flow, product catalogue, bulk import, stock tracking, restock management
- **Purchases** — purchase and restock workflows
- **Money & People** — debtors and creditors tracking, repayments, expenses, owner deposits/withdrawals
- **Reports** — profit & loss, trial balance, cash position, debtors/creditors summaries
- **AI Assistant** — chat-based insights with conversation history
- **Audit Trail** — activity logging and audit details

## Tech Stack

- **Framework:** Flutter
- **State Management:** Riverpod
- **Networking:** Dio
- **Storage:** flutter_secure_storage, shared_preferences
- **UI/Utils:** intl, markdown, pdf/printing
- **Architecture:** Clean architecture with feature-first folder structure

## Getting Started

1. **Install Flutter SDK** (>= 3.10.3)
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Configure environment:** update `lib/app/config/env.dart` and `lib/core/constants/api_constants.dart` with your backend URL
4. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── app/
│   ├── bootstrap.dart        # App initialization
│   ├── app.dart              # Root widget
│   ├── config/               # Constants and environment
│   ├── di/                   # Dependency injection
│   └── router/               # Route definitions and navigation
├── core/
│   ├── api/                  # HTTP client
│   ├── constants/            # API and storage keys
│   ├── errors/               # Failures and exception mapping
│   ├── network/              # Connectivity
│   ├── services/             # Auth and API services
│   ├── storage/              # Secure/local storage
│   └── theme/                # Colors, text styles, theme
├── features/
│   ├── auth/
│   ├── ai/
│   ├── dashboard/
│   ├── sales/
│   ├── products/
│   ├── purchases/
│   ├── debtors/
│   ├── creditors/
│   ├── expenses/
│   ├── owner_transactions/
│   ├── reports/
│   ├── business/
│   ├── money_people_hub/
│   ├── audit_trail/
│   └── onboarding/
└── shared/                   # Shared widgets, utils, models
```

## API

The app communicates with a backend API. Base URL is defined in `lib/core/constants/api_constants.dart`.

Key endpoints include auth, products, sales, purchases, reports, AI conversations, and audit endpoints.

## License

Private — not published to pub.dev.

# Track Your Nekhi 🌙

> A private Islamic spiritual growth tracker — **100% free to build and host**

---

## Screenshot

_Add your app screenshot here after building._

---

## About

**Track Your Nekhi** helps Muslims privately log daily good deeds and view their spiritual consistency. It is **not** a social app — no leaderboards, no public sharing, no game coins. Just a calm, personal, reflective companion.

### Features
- 🕌 **Salah Tracker** — mark all five Fard prayers with post-prayer dhikr reminders
- 📿 **Daily Dhikr** — bead-style counters for SubhanAllah, Astaghfirullah, and La ilaha illa Allah (×100 each)
- 🪞 **Muhasabah (Character Reflection)** — daily yes/no toggles for anger, forgiveness, helping others, and avoiding backbiting
- ✨ **Noor Score** — client-side spiritual score with a streak multiplier (no paid cloud functions!)
- 🔒 **Private** — Firebase Auth + Firestore security rules ensure all data is user-private

---

## Tech Stack — ALL FREE

| Layer | Technology | Cost |
|-------|-----------|------|
| Frontend | Flutter (latest stable) | Free |
| Auth | Firebase Auth (Spark plan) | Free |
| Database | Cloud Firestore (Spark plan) | Free |
| State Mgmt | Provider | Free |
| Hosting | Firebase Hosting (optional, Spark plan) | Free |

**Free tier limits reminder:**
- Firestore: 50K reads/day, 20K writes/day, 20K deletes/day, 1 GiB storage
- Firebase Auth: Unlimited email/password auth
- Firebase Hosting: 10 GB/month transfer, 1 GB storage

---

## Project Structure

```
lib/
├── main.dart
├── config/
│   ├── theme.dart              # App colours and typography
│   └── routes.dart             # Named route constants
├── constants/
│   ├── hadith_data.dart        # Hadith and reward text
│   ├── app_strings.dart        # All UI strings
│   └── noor_config.dart        # Noor score point values (editable)
├── models/
│   ├── user_model.dart
│   ├── daily_log.dart
│   └── streak_model.dart
├── providers/
│   ├── auth_provider.dart
│   ├── daily_log_provider.dart
│   └── streak_provider.dart
├── screens/
│   ├── onboarding_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   ├── salah_tracker_screen.dart
│   ├── dhikr_screen.dart
│   └── character_screen.dart
├── services/
│   ├── auth_service.dart
│   └── firestore_service.dart
├── utils/
│   └── noor_calculator.dart    # Client-side score (no cloud functions)
└── widgets/
    ├── circular_progress.dart
    ├── prayer_card.dart
    ├── dhikr_counter.dart
    ├── post_prayer_modal.dart
    └── character_toggle.dart
```

---

## Setup Instructions

### Prerequisites
1. Install [Flutter](https://flutter.dev/docs/get-started/install) (latest stable)
2. Create a **free Firebase project** at [console.firebase.google.com](https://console.firebase.google.com)
   - Choose the **Spark (free) plan**

### Firebase Setup
1. In the Firebase console, go to **Authentication → Sign-in method** and enable **Email/Password**
2. Go to **Firestore Database → Create database** (start in production mode)
3. Deploy the security rules:
   ```bash
   firebase deploy --only firestore:rules
   ```
4. For **Android**: Download `google-services.json` and place it at `android/app/google-services.json`
5. For **iOS**: Download `GoogleService-Info.plist` and place it at `ios/Runner/GoogleService-Info.plist`
6. Update `.firebaserc` with your Firebase project ID

### Run the App
```bash
flutter pub get
flutter run
```

### Run Tests
```bash
flutter test
```

---

## Noor Score Formula

All calculation happens in Dart — no Cloud Functions needed:

```
Fard prayer completed  = 20 pts each  (max 100)
Dhikr set completed    = 15 pts each  (max 45)
Character deed done    = 25 pts each  (max 100)
─────────────────────────────────────────────
Daily max base         = 245 pts
Streak multiplier      = +10% if streak > 1 day
```

Point values live in `lib/constants/noor_config.dart` for easy editing.

---

## What Is NOT Included (By Design)
- ❌ Cloud Functions (requires Blaze billing plan)
- ❌ Push notifications
- ❌ Social features / leaderboards
- ❌ Music / audio
- ❌ Paid plugins or APIs

---

## License

MIT — free to use, modify, and distribute.
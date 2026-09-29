# PennyPal

PennyPal is a Flutter app using Firebase Authentication, Cloud Firestore, and Gemini-powered financial education.

## Setup

1. Install Flutter and the FlutterFire CLI.
2. Configure your Firebase project with `flutterfire configure`. This generates the local Firebase options used by the app. Follow the Firebase setup instructions for each platform you plan to run.
3. Run `flutter pub get`.
4. To enable Gemini in a local development build, supply a key at build time:

	```powershell
	flutter run --dart-define=GEMINI_API_KEY=your_key_here
	```

	Without a key, the app uses its built-in educational fallback responses.

## Keep credentials out of Git

The root `.gitignore` excludes local secret files, environment files, Firebase Admin service-account JSON files, and Android signing materials. Never commit service-account keys, signing keys, passwords, or private API credentials. Use a secret manager or CI-provided environment variables for deployment credentials.

The Gemini key is read from `GEMINI_API_KEY`; do not put it in Dart source. A key passed with `--dart-define` is still bundled into a client app and can be extracted, so production Gemini access should go through a server you control. Restrict the key and rotate it if it has ever been shared or committed.

Firebase client configuration (`firebase_options.dart` and platform configuration files) contains app identifiers and client API keys, not Firebase Admin credentials. These values are visible in distributed apps; protect the project with Firebase API-key restrictions, Authentication settings, and correctly scoped Firestore Security Rules. Never put Admin SDK credentials in the Flutter app.

Ignoring a file only prevents new untracked copies from being added. It does not remove a file already tracked by Git or erase it from commit history. If a credential was pushed, revoke/rotate it first, then remove it from the repository and history as appropriate.

## Admin accounts

The app does not create or promote admin accounts during startup or login. Create admin users through a trusted administrative process and enforce role changes with server-side controls and Firestore Security Rules; never trust a role value supplied by the client.

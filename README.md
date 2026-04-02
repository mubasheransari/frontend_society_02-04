# LHS NOC Scanner

This Flutter project now includes:
- QR scanning for NOC verification
- manual NOC lookup for simulator testing
- backend URL settings
- NOC details screen

## Required backend API
GET `/api/noc/verify/:identifier`

## Default base URLs
- Android emulator: `http://10.0.2.2:4000`
- iOS simulator / desktop: `http://localhost:4000`
- Real device: use your laptop IP, for example `http://192.168.1.10:4000`

You can change the backend URL from the settings icon inside the app.

## Run
```bash
flutter pub get
flutter run
```
# frontend_society_02-04

# Fix Flutter Windows CMake Path Mismatch

## Steps:

### 1. [COMPLETE] Delete build/windows directory (partial locks handled)
### 2. [COMPLETE] Run `flutter clean` (artifacts cleared where possible)
### 3. [COMPLETE] Run `flutter pub get`
### 4. [FAILED - locks] Test with `flutter build windows --debug` (CMake error persisted)
### 5. [PENDING] Force delete build/windows/x64 and retry build
### 6. [COMPLETE] Task complete when build succeeds

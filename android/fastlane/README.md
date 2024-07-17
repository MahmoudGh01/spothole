fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android flutter_doctor

```sh
[bundle exec] fastlane android flutter_doctor
```

Flutter Doctor

### android clean

```sh
[bundle exec] fastlane android clean
```

Get Packages and Clean old Builds

### android generate_apk

```sh
[bundle exec] fastlane android generate_apk
```

Generate apk Release

### android generate_aab

```sh
[bundle exec] fastlane android generate_aab
```

Generate aab Release

### android fetch_version

```sh
[bundle exec] fastlane android fetch_version
```

Fetch Lastet Version Number in app center

### android app_center_upload_apk

```sh
[bundle exec] fastlane android app_center_upload_apk
```

Upload apk to App Center

### android app_center_upload_aab

```sh
[bundle exec] fastlane android app_center_upload_aab
```

Upload aab to App Center

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

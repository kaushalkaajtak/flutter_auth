# flutter_auth

Flutter plugin for seamless authentication system. This does two ways authentication, first with respective third party servers (apple, google, facebook) and then with your own server.

## Features

- Login via Google, Facebook, Apple, OTP
- Customise the login options to enable the Login services.
- Customise the Widgets according to needs.

## Setup Instructions

### Google Auth

Follow the iOS & Android setup instructions provided by official google auth plugin.

https://pub.dev/packages/google_sign_in

### Facebook Auth

Follow the link to guidelines provided below.

for iOS:
https://facebook.meedu.app/docs/5.x.x/ios

for Android:
https://facebook.meedu.app/docs/5.x.x/android

### Apple Auth

- IOS
  1. Open Xcode.
  2. Setect Targets -> Runner
  3. Navigate to Signing & Capabilites, then click `+ Capability` button to add one.
  4. Select Sign in with Apple.

### OTP Auth

No configuration need for OTP Auth.

### Dart Setup Code

In your dart code you can call `AuthBuilder()` class to use the plugin. Parameter definitions follows:

- `baseUrl`: The base url at which your server points.
- `onloginSuccess`: A callbacl function which returns a `UserModel` which has properties as firstname, lastname, email, token etc.
- `onfailure`: A callback with message stating whats wrong.
- `googleScopes`: Accepts List of Strings which are defined google scopes (Refer example app).
- `fbScopes`: Accepts comma seperated strings which are defined facebook scopes (Refer example app).
- `headerWidget`: A widget to be passed as header (most probably Icon).
- `footerWidget`: A widget to be passed as header (most probably some terms conditions).
- `enable[type_of_login]Auth`: These are four boolean params to enable login buttons.
- `skipText`: Provide a text for skip button.
- `onSkip`: Callback for skip button.
- `isSkipVisible`: Bool to enable skip button.
- `onlySupportIndianNo` : Bool for enabling/disabling international support.
- `isPhoneVerifyFlow`: disable the line sepertion between otp and social login when used this screen as otp verify flow.
- `showBottomLine`: Whether to enable/disable the line sepertion between otp and social login.
- `screen1Description`:Customized description for login page.
- `screen1Title`: Customized title for login page.
- `titleTextStyle`:TextStyle for title.
- `descriptionTextStyle`: TextStyle for description.
- `headers`: Base option headers.
- `loginApi`: Login end point.
- `otpVerifyApi`: Otp verify end point.
- `otpResendApi`: Otp resend end point.

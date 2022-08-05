<h1 align="center">Flutter AppMetrica Push Android</h1>

<a href="https://madbrains.ru/"><img src="https://firebasestorage.googleapis.com/v0/b/mad-brains-web.appspot.com/o/logo.png?alt=media" width="200" align="right" style="margin: 20px;"/></a>

[Read this in Russian][readme_ru]

The [AppMetrica Push][appmetrica_push] SDK is a set of libraries for working with push notifications. After enabling the AppMetrica Push SDK, you can create and configure push notification campaigns, then monitor statistics in the AppMetrica web interface.

[SDK documentation][appmetrica_documentation].

## SDK features

- Receive and display Push notifications
- Receiving Silent Push notifications
- Processing payload from notifications
- image display in notifications
- support of deeplink action when opening a notification
- support for URL action, when you open a notification

## Setup

Add this to your project's pubspec.yaml file:
```yaml
dependencies:
  firebase_core: <lastles>
  firebase_analytics: <lastles>
  appmetrica_plugin: <lastles>
  appmetrica_push_android: <lastles>
```

## To get started with the SDK, you'll need:

- create a project in [AppMetrica][appmetrica]
- create a project in [Firebase][firebase], add android application and load the `google-services.json` configuration file
- In the AppMetrica project settings, get the `API key (for use in the SDK)`
- in the project settings [Firebase Console][firebase] get `Server key` from `Cloud Messaging API (Legacy)`
- [configure AppMetrica to work with FCM][appmetrica_android_setup]

**(Optional) Enable push token updating:** The FCM service can withdraw the push token of the device, for example, if the user did not launch the application for a long time. AppMetrica stores push tokens on the server and can not send a push notification to a device with an obsolete token. To automatically collect current push token go to the application settings in the AppMetrica interface and enable the Update tokens with a Silent Push notification option in the Push Notifications tab.

## Connecting the AppMetrica Push SDK (an example can be found in examples/example_fcm)

In the file `<project>/android/app/build.gradle` put `minSdkVersion 19`

<details><summary><b>Using the Google Services Plugin</b></summary>
Place the configuration file <code>google-services.json</code> in the module directory of the project(<code>"<project>/android/app"</code>).</br>

In the file <code>"<project>/android/build.gradle"</code> add:
<pre><code data-code-language="gradle">
buildscript {
  dependencies {
    ...
    classpath 'com.google.gms:google-services:4.3.13'
  }
}
</code></pre>

In the file <code>"<project>/android/app/build.gradle"</code> add:
<pre><code data-code-language="gradle">
...
apply plugin: 'com.google.gms.google-services'
</code></pre>
</details>

<details><summary><b>Without using the plugin</b></summary>
Make changes to the <code>application</code> element of the <code>AndroidManifest.xml</code> file:
<pre><code data-code-language="xml">
&lt;meta-data android:name="ymp_firebase_default_app_id" android:value="APP_ID"/>
&lt;meta-data android:name="ymp_gcm_default_sender_id" android:value="number:SENDER_ID"/>
&lt;meta-data android:name="ymp_firebase_default_api_key" android:value="API_KEY"/>
&lt;meta-data android:name="ymp_firebase_default_project_id" android:value="PROJECT_ID"/>
</code></pre>
<p><code>APP_ID</code> — ID of the app in Firebase. You can find it in the Firebase console: go to the Project settings. In the Your application section copy the value of the application ID field.</p>
<p><code>SENDER_ID</code> — The unique ID of the sender in Firebase. You can find it in the Firebase console: go to Project settings → Cloud Messaging and copy the value of the Sender ID field.</p>
<p><code>API_KEY</code> — App key in Firebase. You can find it in the current_key field of the google-services.json file. You can download the file in the Firebase console.</p>
<p><code>PROJECT_ID</code> — App ID in Firebase. You can find it in the project_id field of the google-services.json file. You can download the file in the Firebase console.</p>
</details>

## Initializing the AppMetrica Push SDK (an example can be found in examples/example_fcm)

```dart
await Firebase.initializeApp();
await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

// AppMetrica.activate must be called before AppmetricaPush.activate
await AppMetrica.activate(AppMetricaConfig('<AppMetrica API key>'));
await AppmetricaPushAndroid.instance.activate();
await AppmetricaPushAndroid.instance.requestPermission(PermissionOptions(
    alert: true,
    badge: true,
    sound: true,
  ));
```

## Using the AppMetrica Push SDK (an example can be found in examples/example_fcm)

```dart
// Get a PUSH service token
await AppmetricaPushAndroid.instance.getTokens();

// Streaming PUSH service tokens. Comes when the token on the device changes
// Note that this is a stream broadcast
AppmetricaPushAndroid.instance.tokenStream.listen((Map<String, String?> data) => print('token: $data'));

// Stream silent push, as the data comes payload
// Note that this is a stream broadcast
AppmetricaPushAndroid.instance.onMessage
      .listen((String data) => print('onMessage: $data'));

// Stream push, as the data comes payload
// Note that this is a stream broadcast
AppmetricaPushAndroid.instance.onMessageOpenedApp
      .listen((String data) => print('onMessageOpenedApp: $data'));
```

## Example of work

An example of how the SDK works is available at [Example][example_fcm]

[readme_ru]: https://github.com/MadBrains/AppMetrica-Push-Flutter/blob/main/packages/appmetrica_push_android/README.ru.md
[appmetrica]: https://appmetrica.yandex.ru/
[appmetrica_push]: https://appmetrica.yandex.ru/about/push-campaigns
[appmetrica_documentation]: https://appmetrica.yandex.ru/docs/mobile-sdk-dg/push/push-about.html?lang=en
[firebase]: https://console.firebase.google.com/
[appmetrica_android_setup]: https://appmetrica.yandex.ru/docs/mobile-sdk-dg/push/android-settings.html?lang=en#firebase
[example_fcm]: https://github.com/MadBrains/AppMetrica-Push-Flutter/tree/main/examples/example_fcm
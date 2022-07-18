<h1 align="center">Flutter AppMetrica Push Huawei</h1>

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
  huawei_analytics: <lastles>
  appmetrica_plugin: <lastles>
  appmetrica_push_huawei: <lastles>
```

## To get started with the SDK, you'll need:
- create a project in [AppMetrica][appmetrica]
- create a project in [Huawei AppGallery Connect][app_gallery], add android application and load the `agconnect-services.json` configuration file
- In the AppMetrica project settings, get the `API key (for use in the SDK)`
- in the project settings [Huawei AppGallery Connect][app_gallery] get the `ID of the application` and `App secret`
- [configure AppMetrica to work with HMS][appmetrica_huawei_setup]

**(Optional) Enable push token updating:** The HMS service can withdraw the push token of the device, for example, if the user did not launch the application for a long time. AppMetrica stores push tokens on the server and can not send a push notification to a device with an obsolete token. To automatically collect current push token go to the application settings in the AppMetrica interface and enable the Update tokens with a Silent Push notification option in the Push Notifications tab.

## Connecting the AppMetrica Push SDK (an example can be found in examples/example_hms)

Place the configuration file `agconnect-services.json` in the module directory of the project (`<project>/android/app`).

In the `<project>/android/app/src/main/AndroidManifest.xml` file, add in `application`:

```xml
<meta-data android:name="ymp_hms_default_app_id" android:value="number:<AppGallery App ID>"/>

<provider android:authorities="${applicationId}.HMSContentProvider"
          android:name="com.huawei.hms.flutter.analytics.AnalyticsContentProvider"/>
```

In the file `<project>/android/build.gradle` add:

```gradle
buildscript {
  ...
  repositories {
    ...
    maven {url 'https://developer.huawei.com/repo/'}
  }

  dependencies {
    ...
    classpath 'com.huawei.agconnect:agcp:1.5.2.300'
  }
}

...

allprojects {
  repositories {
    ...
    maven {url 'https://developer.huawei.com/repo/'}
  }
}
```

In the file `<project>/android/app/build.gradle` change and add:

```gradle
...
apply plugin: 'com.huawei.agconnect'

android {
  ...

  defaultConfig {
    ...
    minSdkVersion 19

  }

  ...

  buildTypes {
    ...

    release {
      ...
      // Enables code shrinking, obfuscation and optimization for release builds
      minifyEnabled true
      // Unused resources will be removed.
      shrinkResources true
      proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
  }
}

dependencies {
  ...
  implementation 'com.huawei.agconnect:agconnect-core:1.5.2.300'
}
```

Create a file `proguard-rules.pro` at the path `<project>/android/app/proguard-rules.pro`:

```pro
-ignorewarnings
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keep class com.hianalytics.android.**{*;}
-keep class com.huawei.updatesdk.**{*;}
-keep class com.huawei.hms.**{*;}
-repackageclasses

## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**
```

## Initializing the AppMetrica Push SDK (an example can be found in examples/example_hms)

```dart
HMSAnalytics analytics = await HMSAnalytics.getInstance();
await analytics.setAnalyticsEnabled(true);

// AppMetrica.activate must be called before AppmetricaPush.activate
await AppMetrica.activate(AppMetricaConfig('<AppMetrica API key>'));
await AppmetricaPushHuawei.instance.activate();
await AppmetricaPushHuawei.instance.requestPermission(PermissionOptions(
    alert: true,
    badge: true,
    sound: true,
  ));
```

## Using the AppMetrica Push SDK (an example can be found in examples/example_hms)

```dart
// Get a PUSH service token
await AppmetricaPushHuawei.instance.getTokens();

// Streaming PUSH service tokens. Comes when the token on the device changes
// Note that this is a stream broadcast
AppmetricaPushHuawei.instance.tokenStream.listen((Map<String, String?> data) => print('token: $data'));

// Stream silent push, as the data comes payload
// Note that this is a stream broadcast
AppmetricaPushHuawei.instance.onMessage
      .listen((String data) => print('onMessage: $data'));

// Stream push, as the data comes payload
// Note that this is a stream broadcast
AppmetricaPushHuawei.instance.onMessageOpenedApp
      .listen((String data) => print('onMessageOpenedApp: $data'));
```

## Example of work

An example of how the SDK works is available at [Example][example_hms]

[readme_ru]: https://github.com/MadBrains/AppMetrica-Push-Flutter/blob/main/packages/appmetrica_push_huawei/README.ru.md
[appmetrica]: https://appmetrica.yandex.ru/
[appmetrica_push]: https://appmetrica.yandex.ru/about/push-campaigns
[appmetrica_documentation]: https://appmetrica.yandex.ru/docs/mobile-sdk-dg/push/push-about.html?lang=en
[app_gallery]: https://developer.huawei.com/consumer/en/
[appmetrica_huawei_setup]: https://appmetrica.yandex.ru/docs/mobile-sdk-dg/push/android-settings.html?lang=en#hms
[example_hms]: https://github.com/MadBrains/AppMetrica-Push-Flutter/tree/main/examples/example_hms
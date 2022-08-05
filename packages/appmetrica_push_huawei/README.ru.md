<h1 align="center">Flutter AppMetrica Push Huawei</h1>

<a href="https://madbrains.ru/"><img src="https://firebasestorage.googleapis.com/v0/b/mad-brains-web.appspot.com/o/logo.png?alt=media" width="200" align="right" style="margin: 20px;"/></a>

[AppMetrica Push][appmetrica_push] SDK — это набор библиотек для работы с push-уведомлениями. Подключив AppMetrica Push SDK, вы можете создать и настроить кампанию push-уведомлений, а затем отслеживать статистику в веб-интерфейсе AppMetrica.

[Документация по SDK][appmetrica_documentation].

## Возможности SDK

- получение и отображение Push уведомлений
- получение Silent Push уведомлений
- обработка payload из уведомлений
- отображение изображения в уведомлениях
- поддержка действия deeplink, при открытии уведомления
- поддержка действия URL, при открытии уведомления

## Установка

Добавьте это в файл pubspec.yaml вашего проекта:
```yaml
dependencies:
  huawei_analytics: <lastles>
  appmetrica_plugin: <lastles>
  appmetrica_push_huawei: <lastles>
```

## Чтобы начать работу с SDK, вам потребуется:
- создать проект в [AppMetrica][appmetrica]
- создать проект в [Huawei AppGallery Connect][app_gallery], добавить android приложение и загрузить конфигурационный файл `agconnect-services.json`
- в настройках проекта AppMetrica получить `API key (для использования в SDK)`
- в настройках проекта [Huawei AppGallery Connect][app_gallery] получить `ID приложения` и `App secret`
- [настроить AppMetrica для работы с HMS][appmetrica_huawei_setup]

**(Опционально) Включите актуализацию push-токенов:** Сервис HMS может отозвать push-токен устройства, например, если пользователь долго не запускал приложение. AppMetrica хранит push-токены на сервере и не может отправить push-уведомление на устройство с устаревшим токеном. Чтобы автоматически собирать актуальные push-токены, перейдите в настройки приложения в веб-интерфейсе AppMetrica и выберите опцию Актуализировать токены с помощью Silent Push-уведомлений во вкладке Push-уведомления.

## Подключение AppMetrica Push SDK (пример можно найти в examples/example_hms)

Разместите конфигурационный файл `agconnect-services.json` в каталоге модуля проекта (`<project>/android/app`).

В файле `<project>/android/app/src/main/AndroidManifest.xml` добавить в `application`:

```xml
<meta-data android:name="ymp_hms_default_app_id" android:value="number:<AppGallery App ID>"/>

<provider android:authorities="${applicationId}.HMSContentProvider"
          android:name="com.huawei.hms.flutter.analytics.AnalyticsContentProvider"/>
```

В файле `<project>/android/build.gradle` добавить:

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

В файле `<project>/android/app/build.gradle` изменить и добавить:

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

Создать файл `proguard-rules.pro` по пути `<project>/android/app/proguard-rules.pro`:

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

## Инициализация AppMetrica Push SDK (пример можно найти в examples/example_hms)

```dart
HMSAnalytics analytics = await HMSAnalytics.getInstance();
await analytics.setAnalyticsEnabled(true);

// AppMetrica.activate должна быть вызвана до AppmetricaPush.activate
await AppMetrica.activate(AppMetricaConfig('<AppMetrica API key>'));
await AppmetricaPushHuawei.instance.activate();
await AppmetricaPushHuawei.instance.requestPermission(PermissionOptions(
    alert: true,
    badge: true,
    sound: true,
  ));
```

## Использование AppMetrica Push SDK (пример можно найти в examples/example_hms)

```dart
// Получить токен PUSH сервиса
await AppmetricaPushHuawei.instance.getTokens();

// Стрим токенов PUSH сервиса. Приходит, когда токен на устройстве меняется
// Обратите внимание что это stream broadcast
AppmetricaPushHuawei.instance.tokenStream.listen((Map<String, String?> data) => print('token: $data'));

// Стрим silent push, в качестве данных приходит payload
// Обратите внимание что это stream broadcast
AppmetricaPushHuawei.instance.onMessage
      .listen((String data) => print('onMessage: $data'));

// Стрим push, в качестве данных приходит payload
// Обратите внимание что это stream broadcast
AppmetricaPushHuawei.instance.onMessageOpenedApp
      .listen((String data) => print('onMessageOpenedApp: $data'));
```

## Пример работы

Пример работы SDK доступен в [Example][example_hms]

[appmetrica]: https://appmetrica.yandex.ru/
[appmetrica_push]: https://appmetrica.yandex.ru/about/push-campaigns
[appmetrica_documentation]: https://appmetrica.yandex.ru/docs/mobile-sdk-dg/push/push-about.html
[app_gallery]: https://developer.huawei.com/consumer/en/
[appmetrica_huawei_setup]: https://appmetrica.yandex.ru/docs/mobile-sdk-dg/push/android-settings.html#hms
[example_hms]: https://github.com/MadBrains/AppMetrica-Push-Flutter/tree/main/examples/example_hms
<h1 align="center">Flutter AppMetrica Push Android</h1>

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
  firebase_core: <lastles>
  firebase_analytics: <lastles>
  appmetrica_plugin: <lastles>
  appmetrica_push_android: <lastles>
```

## Чтобы начать работу с SDK, вам потребуется:

- создать проект в [AppMetrica][appmetrica]
- создать проект в [Firebase][firebase], добавить android приложение и загрузить конфигурационный файл `google-services.json`
- в настройках проекта AppMetrica получить `API key (для использования в SDK)`
- в настройках проекта [Firebase Console][firebase] получить `Server key` от `Cloud Messaging API (Legacy)`
- [настроить AppMetrica для работы с FCM][appmetrica_android_setup]

**(Опционально) Включите актуализацию push-токенов:** Сервис FCM может отозвать push-токен устройства, например, если пользователь долго не запускал приложение. AppMetrica хранит push-токены на сервере и не может отправить push-уведомление на устройство с устаревшим токеном. Чтобы автоматически собирать актуальные push-токены, перейдите в настройки приложения в веб-интерфейсе AppMetrica и выберите опцию Актуализировать токены с помощью Silent Push-уведомлений во вкладке Push-уведомления.

## Подключение AppMetrica Push SDK (пример можно найти в examples/example_fcm)

В файле `<project>/android/app/build.gradle` поставить `minSdkVersion 19`

<details><summary><b>Использование Google Services Plugin</b></summary>
Разместите конфигурационный файл <code>google-services.json</code> в каталоге модуля проекта (<code>"<project>/android/app"</code>).</br>

В файле <code>"<project>/android/build.gradle"</code> добавить:
<pre><code data-code-language="gradle">
buildscript {
  dependencies {
    ...
    classpath 'com.google.gms:google-services:4.3.13'
  }
}
</code></pre>

В файле <code>"<project>/android/app/build.gradle"</code> добавить:
<pre><code data-code-language="gradle">
...
apply plugin: 'com.google.gms.google-services'
</code></pre>
</details>

<details><summary><b>Без использования плагина</b></summary>
Внесите изменения в элемент <code>application</code> файла <code>AndroidManifest.xml</code>:
<pre><code>
&lt;meta-data android:name="ymp_firebase_default_app_id" android:value="APP_ID"/>
&lt;meta-data android:name="ymp_gcm_default_sender_id" android:value="number:SENDER_ID"/>
&lt;meta-data android:name="ymp_firebase_default_api_key" android:value="API_KEY"/>
&lt;meta-data android:name="ymp_firebase_default_project_id" android:value="PROJECT_ID"/>"
</code></pre>
<p><code>APP_ID</code> — идентификатор приложения в Firebase. Его можно узнать в консоли Firebase: перейдите в Настройки проекта. В разделе Ваши приложения скопируйте значение поля Идентификатор приложения.</p>
<p><code>SENDER_ID</code> — уникальный идентификатор отправителя в Firebase. Его можно узнать в консоли Firebase: перейдите во вкладку Настройки проекта → Cloud Messaging и скопируйте значение поля Идентификатор отправителя.</p>
<p><code>API_KEY</code> — ключ приложения в Firebase. Его можно найти в поле current_key файла google-services.json. Файл можно скачать из консоли Firebase.</p>
<p><code>PROJECT_ID</code> — id приложения в Firebase. Его можно найти в поле project_id файла google-services.json. Файл можно скачать из консоли Firebase.</p>
</details>

## Инициализация AppMetrica Push SDK (пример можно найти в examples/example_fcm)

```dart
await Firebase.initializeApp();
await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

// AppMetrica.activate должна быть вызвана до AppmetricaPush.activate
await AppMetrica.activate(AppMetricaConfig('<AppMetrica API key>'));
await AppmetricaPushAndroid.instance.activate();
await AppmetricaPushAndroid.instance.requestPermission(PermissionOptions(
    alert: true,
    badge: true,
    sound: true,
  ));
```

## Использование AppMetrica Push SDK (пример можно найти в examples/example_fcm)

```dart
// Получить токен PUSH сервиса
await AppmetricaPushAndroid.instance.getTokens();

// Стрим токенов PUSH сервиса. Приходит, когда токен на устройстве меняется
// Обратите внимание что это stream broadcast
AppmetricaPushAndroid.instance.tokenStream.listen((Map<String, String?> data) => print('token: $data'));

// Стрим silent push, в качестве данных приходит payload
// Обратите внимание что это stream broadcast
AppmetricaPushAndroid.instance.onMessage
      .listen((String data) => print('onMessage: $data'));

// Стрим push, в качестве данных приходит payload
// Обратите внимание что это stream broadcast
AppmetricaPushAndroid.instance.onMessageOpenedApp
      .listen((String data) => print('onMessageOpenedApp: $data'));
```

## Пример работы

Пример работы SDK доступен в [Example][example_fcm]

[appmetrica]: https://appmetrica.yandex.ru/
[appmetrica_push]: https://appmetrica.yandex.ru/about/push-campaigns
[appmetrica_documentation]: https://appmetrica.yandex.ru/docs/mobile-sdk-dg/push/push-about.html
[firebase]: https://console.firebase.google.com/
[appmetrica_android_setup]: https://appmetrica.yandex.ru/docs/mobile-sdk-dg/push/android-settings.html#firebase
[example_fcm]: https://github.com/MadBrains/AppMetrica-Push-Flutter/tree/main/examples/example_fcm
 
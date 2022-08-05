<h1 align="center">Flutter AppMetrica Push iOS</h1>

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
  appmetrica_push_ios: <lastles>
```

## Чтобы начать работу с SDK, вам потребуется:

- создать проект в [AppMetrica][appmetrica]
- создать проект в [Firebase][firebase], добавить iOS приложение и загрузить конфигурационный файл `GoogleService-Info.plist`
- в настройках проекта AppMetrica получить `API key (для использования в SDK)`
- [настроить AppMetrica для работы с APNs][appmetrica_ios_setup]

**(Опционально) Включите актуализацию push-токенов:** Сервис APNs может отозвать push-токен устройства, например, если пользователь долго не запускал приложение. AppMetrica хранит push-токены на сервере и не может отправить push-уведомление на устройство с устаревшим токеном. Чтобы автоматически собирать актуальные push-токены, перейдите в настройки приложения в веб-интерфейса AppMetrica и выберите опцию Актуализировать токены с помощью Silent Push-уведомлений во вкладке Push-уведомления.

## Подключение AppMetrica Push SDK (пример можно найти в examples/example_fcm)

Разместите конфигурационный файл `GoogleService-Info.plist` в `<project>/ios/Runner/` через XCode.

#### Создайте расширение Notification Service Extension:
1. В Xcode выберите `File → New → Target`.
2. В разделе расширений iOS выберите из списка `Notification Service Extension` и нажмите `Next`.
3. Введите название расширения в поле `Product Name` и нажмите `Finish`.

#### Cоздайте общую группу App Groups:
1. В настройках проекта Xcode перейдите во вкладку Capabilities.
2. Включите App Groups для созданного расширения и для приложения. Чтобы переключиться между расширением и приложением, нажмите на панели настроек проекта кнопку или на выпадающий элемент.
3. В разделе App Groups создайте группу с помощью кнопки +. Название группы понадобится при дальнейшей настройке.
4. Выберите созданную группу для приложения и для созданного расширения.

В созданом `Notification Service Extension` измените код следующим образом:

```swift
import UserNotifications
import YandexMobileMetricaPush

class <YourNotificationServiceName>: UNNotificationServiceExtension {
    
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    private let syncQueue = DispatchQueue(label: "<YourNotificationServiceName>.syncQueue")
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if bestAttemptContent != nil {
            // Modify the notification content here...
            YMPYandexMetricaPush.setExtensionAppGroup("<your.app.group.name>")
            YMPYandexMetricaPush.handleDidReceive(request)
        }
        
        YMPYandexMetricaPush.downloadAttachments(for: request) { [weak self] attachments, error in
            if let error = error {
                print("Error: \(error)")
            }
            
            self?.completeWithBestAttempt(attachments: attachments)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        completeWithBestAttempt(attachments: nil)
    }
    
    func completeWithBestAttempt(attachments: [UNNotificationAttachment]?) {
        syncQueue.sync { [weak self] in
            if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
                if let attachments = attachments {
                    bestAttemptContent.attachments = attachments
                }
                
                contentHandler(bestAttemptContent)
                self?.bestAttemptContent = nil
                self?.contentHandler = nil
            }
        }
    }
}
```

В файле `<project>/ios/Runner/AppDelegate.swift` добавить следующие строки в `application:didFinishLaunchingWithOptions` между `GeneratedPluginRegistrant.register` и `return super.application`:

```swift
...
YMPYandexMetricaPush.setExtensionAppGroup("<your.app.group.name>")
...
```

В файле `<project>/ios/Podfile` изменить и добавить:

```Podfile
platform :ios, '10.0'

...

target '<YourNotificationServiceName>' do
  use_frameworks!
  
  pod 'YandexMobileMetricaPush'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    # In case of `Multiple commands produce .../XCFrameworkIntermediates/YandexMobileMetrica` problem
    if target.name == 'YandexMobileMetrica-Static_Core'
      target.remove_from_project
    end
    flutter_additional_ios_build_settings(target)
  end
end
```

## Инициализация AppMetrica Push SDK (пример можно найти в examples/example_fcm)

```dart
await Firebase.initializeApp();
await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

// AppMetrica.activate должна быть вызвана до AppmetricaPush.activate
await AppMetrica.activate(AppMetricaConfig('<AppMetrica API key>'));
await AppmetricaPushIos.instance.activate();
await AppmetricaPushIos.instance.requestPermission(PermissionOptions(
    alert: true,
    badge: true,
    sound: true,
  ));
```

## Использование AppMetrica Push SDK (пример можно найти в examples/example_fcm)

```dart
// Получить токен PUSH сервиса
await AppmetricaPushIos.instance.getTokens();

// Стрим токенов PUSH сервиса. Приходит, когда токен на устройстве меняется
// Обратите внимание что это stream broadcast
AppmetricaPushIos.instance.tokenStream.listen((Map<String, String?> data) => print('token: $data'));

// Стрим silent push, в качестве данных приходит payload
// Обратите внимание что это stream broadcast
AppmetricaPushIos.instance.onMessage
      .listen((String data) => print('onMessage: $data'));

// Стрим push, в качестве данных приходит payload
// Обратите внимание что это stream broadcast
AppmetricaPushIos.instance.onMessageOpenedApp
      .listen((String data) => print('onMessageOpenedApp: $data'));
```

## Пример работы

Пример работы SDK доступен в [Example][example_fcm]

[appmetrica]: https://appmetrica.yandex.ru/
[appmetrica_push]: https://appmetrica.yandex.ru/about/push-campaigns
[appmetrica_documentation]: https://appmetrica.yandex.ru/docs/mobile-sdk-dg/push/push-about.html
[firebase]: https://console.firebase.google.com/
[appmetrica_ios_setup]: https://appmetrica.yandex.ru/docs/mobile-sdk-dg/push/ios-settings.html
[example_fcm]: https://github.com/MadBrains/AppMetrica-Push-Flutter/tree/main/examples/example_fcm
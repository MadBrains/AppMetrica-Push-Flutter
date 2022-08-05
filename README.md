<h1 align="center">Flutter AppMetrica Push</h1>

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

## Platform Support
| Android | iOS | Huawei |
|:---:|:---:|:---:|
| FCM | APNs | HMS |

## Packages
|  |  |
|:---:|:---:|
| appmetrica_push | [![pub package](https://img.shields.io/pub/v/appmetrica_push.svg)](https://pub.dartlang.org/packages/appmetrica_push) |
| appmetrica_push_android | [![pub package](https://img.shields.io/pub/v/appmetrica_push_android.svg)](https://pub.dartlang.org/packages/appmetrica_push_android) |
| appmetrica_push_huawei | [![pub package](https://img.shields.io/pub/v/appmetrica_push_huawei.svg)](https://pub.dartlang.org/packages/appmetrica_push_huawei) |
| appmetrica_push_ios | [![pub package](https://img.shields.io/pub/v/appmetrica_push_ios.svg)](https://pub.dartlang.org/packages/appmetrica_push_ios) |
| appmetrica_push_platform_interface | [![pub package](https://img.shields.io/pub/v/appmetrica_push_platform_interface.svg)](https://pub.dartlang.org/packages/appmetrica_push_platform_interface) |

## Пример работы

Пример работы SDK доступен в [Example iOS & Android][example_fcm]

Пример работы SDK доступен в [Example Huawei][example_hms]

[appmetrica_push]: https://appmetrica.yandex.ru/about/push-campaigns
[appmetrica_documentation]: https://appmetrica.yandex.ru/docs/mobile-sdk-dg/push/push-about.html
[example_hms]: https://github.com/MadBrains/AppMetrica-Push-Flutter/tree/main/examples/example_hms
[example_fcm]: https://github.com/MadBrains/AppMetrica-Push-Flutter/tree/main/examples/example_fcm
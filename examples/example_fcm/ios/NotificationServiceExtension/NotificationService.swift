import UserNotifications
import YandexMobileMetricaPush

class NotificationService: UNNotificationServiceExtension {
    
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    private let syncQueue = DispatchQueue(label: "NotificationService.syncQueue")
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if bestAttemptContent != nil {
            // Modify the notification content here...
            YMPYandexMetricaPush.setExtensionAppGroup("group.ru.madbrains.appmetrica")
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

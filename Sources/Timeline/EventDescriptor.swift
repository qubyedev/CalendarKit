import Foundation
import UIKit

public protocol EventDescriptor: AnyObject {
    var startDate: Date {get set}
    var endDate: Date {get set}
    var isAllDay: Bool {get}
    var titleText: String {get}
    var titleAttributedText: NSAttributedString? {get}
    var timeText: String {get}
    var timeAttributedText: NSAttributedString? {get}
    var lineBreakMode: NSLineBreakMode? {get}
    var isHiddenRedCircle: Bool {get}
    var font : UIFont {get}
    var color: UIColor {get}
    var textColor: UIColor {get}
    var backgroundColor: UIColor {get}
    var borderWidth: CGFloat {get}
    var borderColor: CGColor {get}
    var appointmentIndex: Int {get}
    var editedEvent: EventDescriptor? {get set}
    func makeEditable() -> Self
    func commitEditing()
}

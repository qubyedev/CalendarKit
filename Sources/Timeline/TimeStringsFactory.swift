import Foundation

struct TimeStringsFactory {
  private let calendar: Calendar
  
  init(_ calendar: Calendar = Calendar.autoupdatingCurrent) {
    self.calendar = calendar
  }
  
  func make24hStrings() -> [String] {
    var numbers = [String]()
    numbers.append("00:00")

    for i in 1...24 {
      let i = i % 24
      var string = i < 10 ? "0" + String(i) : String(i)
      string.append(":00")
      numbers.append(string)
    }

    return numbers
  }

  func make12hStrings() -> [String] {
    var numbers = [String]()
    numbers.append("12")

    for i in 1...11 {
      let string = String(i)
      numbers.append(string)
    }

    var am = numbers.map { $0 + " " + calendar.amSymbol}
    var pm = numbers.map { $0 + " " + calendar.pmSymbol}

    am.append(localizedString("12:00"))
    pm.removeFirst()
    pm.append(am.first!)
    return am + pm
  }
    
//    func make12hStrings() -> [String] {//0115 by Yuan
//      var numbers = [String]()
//      numbers.append("12")
//
//      for i in 1...11 {
//        let string = String(i)
//        numbers.append(string)
//      }
//
//        var am:[String] = []
//        for i in numbers{
//            am.append(i + ":00 " + calendar.amSymbol)
//            am.append(i + ":30 " + calendar.amSymbol)
//        }
//
//        var pm:[String] = []
//        for i in numbers{
//            pm.append(i + ":00 " + calendar.pmSymbol)
//            pm.append(i + ":30 " + calendar.pmSymbol)
//        }
//
////      var am = numbers.map { $0 + " " + calendar.amSymbol}
////        print("test 0115 am: \(am)")
////      var pm = numbers.map { $0 + " " + calendar.pmSymbol}
////        print("test 0115 pm: \(pm)")
//
//      am.append("12:00 PM")
//      pm.removeFirst()
//      pm.append(am.first!)
////        let newList = am+pm
////        print("test 0115 newList count: \(newList.count)")
////        print("test 0115 newList: \(newList)")
//      return am + pm
//    }
}

import Foundation

struct Article: Codable
{
    var id: Int
    var title: String
    var url: String
    var score: Int
    var kids: [Int]
    var time: Double
}

extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
}

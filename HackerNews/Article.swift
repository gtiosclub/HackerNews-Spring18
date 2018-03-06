import Foundation

struct Article: Codable
{
    var id: Int
    var title: String
    var url: String
    var score: Int
    var kids: [Int]
    var time: Date
}

import Foundation

struct Article
{
    var id: Int
    var title: String
    var url: String
    var score: Int
    var kids: [Int]
    var time: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
        case score
        case kids
        case time
    }
}

extension Article: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        url = try values.decode(String.self, forKey: .url)
        score = try values.decode(Int.self, forKey: .score)
        kids = try values.decode([Int].self, forKey: .kids)
        
        let dateUTC = try values.decode(Double.self, forKey: .time)
        let date = Date(timeIntervalSince1970: dateUTC)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        time = dateFormatter.string(from: date)
    }
    
}


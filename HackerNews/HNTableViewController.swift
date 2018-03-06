//
//  HNTableViewController.swift
//  HackerNews
//
//  Created by Numeric on 3/6/18.
//  Copyright © 2018 Numeric. All rights reserved.
//

import UIKit
import SafariServices

class HNTableViewController: UITableViewController {

    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTopArticles()
    }
    
    // MARK: - Fetching Data
    func fetchTopArticles() {
        guard let topArticleURL = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty") else {
            return
        }
        URLSession.shared.dataTask(with: topArticleURL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                var text = String(data: data!, encoding: String.Encoding.utf8) as String!
                text = text?.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: " ", with: "")
                var entries = text?.components(separatedBy: ",")
                entries = Array(entries!.prefix(30))
                for entryId in entries! {
                    self.fetchArticleForEntry(entryId)
                }
            }
        }).resume()
    }
    
    func fetchArticleForEntry(_ entryId: String) {
        guard let articleURL = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(entryId).json?print=pretty") else {
            return
        }
        URLSession.shared.dataTask(with: articleURL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    let article = try JSONDecoder().decode(Article.self, from: data!)
                    self.articles.append(article)
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.tableView?.reloadData()
                    })
                } catch {
                    print("Error info: \(error)")
                }
            }
        }).resume()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HackerNewsTableViewCell", for: indexPath)
        let article = articles[indexPath.row]
        if let articleCell = cell as? HackerNewsTableViewCell {
            articleCell.articleTime.text = "\(article.time.getDateStringFromUTC())"
            articleCell.articleLabel.text = "\(article.title)"
            articleCell.articleVote.text = "🔥\n\(article.score)"
            articleCell.commentButton.setTitle("Comments (\(article.kids.count))", for: .normal)
            articleCell.commentButton.tag = indexPath.row
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    
    // MARK: - Presenting Links
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentWebLink(articles[indexPath.row].url)
    }
    
    @IBAction func showCommentsTapped(_ sender: UIButton) {
        let commentsLink = "https://news.ycombinator.com/item?id=\(articles[sender.tag].id)"
        presentWebLink(commentsLink)
    }
    
    func presentWebLink(_ link: String) {
        guard let urlForLink = URL.init(string: link) else {
            return
        }
        let sfViewController = SFSafariViewController(url: urlForLink)
        self.present(sfViewController, animated: true, completion: nil)
    }
}

struct Article: Codable
{
    var id: Int
    var title: String
    var url: String
    var score: Int
    var time: Double
    var kids: [Int]
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


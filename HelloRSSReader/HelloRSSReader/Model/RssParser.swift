//
//  RssParser.swift
//  HelloRSSReader
//
//  Created by Uran on 2018/6/29.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
typealias ParserCompletion = (_ items : [RssItem]?) -> Void
class RssParser: NSObject {
    private var rssItems : [RssItem] = []
    private var currentElement = ""
    private var currentTitle : String = "" {
        didSet{
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription:String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate:String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    var paserComplete : ParserCompletion?
    func parserFeed(feedUrl : String , complete : @escaping ParserCompletion){
        self.paserComplete = complete
        guard let url = URL(string: feedUrl) else {
            self.paserComplete?(nil)
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                self.paserComplete?(nil)
                return
            }
            let parserData = XMLParser(data: data)
            parserData.delegate = self
            parserData.parse()
            
            
        }
        
        dataTask.resume()
    }
}
extension RssParser : XMLParserDelegate{
    // 開始 parser XML
    func parserDidStartDocument(_ parser: XMLParser) {
        self.rssItems = []
    }
    // 結束 Parser
    func parserDidEndDocument(_ parser: XMLParser) {
        self.paserComplete?(self.rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        NSLog("Parser error : \(parseError.localizedDescription)")
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentPubDate = ""
            currentDescription = ""
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "description": currentDescription += string
        case "pubDate": currentPubDate += string
        default:
            break
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            let rssItem : RssItem = RssItem(title: currentTitle, description: currentDescription, pubDate: currentPubDate)
            rssItems += [rssItem]
        }
    }
}





public protocol Rss{
    var title : String {set get}
    var description : String {get set}
    var pubDate : String {get set}
}

struct RssItem: Rss {
    var title: String
    
    var description: String
    
    var pubDate: String
    
    
}

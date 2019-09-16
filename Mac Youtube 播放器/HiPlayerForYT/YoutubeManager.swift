//
//  YoutubeManager.swift
//  HiPlayerForYT
//
//  Created by Uran on 2019/5/16.
//  Copyright © 2019 Uran. All rights reserved.
//

import Cocoa
import GoogleAPIClientForREST
class YoutubeManager: NSObject {
    public static let stand = YoutubeManager()
    fileprivate var servicer = GTLRYouTubeService()
    fileprivate static let apiKey = "AIzaSyB_5_uuUMhNotqc1r9WUmoAtBaigyABoFQ"
    override init() {
        super.init()
        self.servicer.apiKey = YoutubeManager.apiKey
    }
    public func search(with keyword : String , type : SearchType , completion : @escaping ([YoutubeResult]?) -> Void){
        var typeStr : String
        switch type {
        case .channel:
            typeStr = "channel"
            break
        case .playList:
            typeStr = "playList"
            break
        default:
            typeStr = "video"
            break
        }
        let searchQuery = GTLRYouTubeQuery_SearchList.query(withPart: "snippet")
        searchQuery.q = keyword
        searchQuery.maxResults = 20
        searchQuery.type = typeStr
        if servicer.apiKey == nil{
            servicer.apiKey = YoutubeManager.apiKey
        }
        servicer.executeQuery(searchQuery)
        { (ticket, response, error) in
            if let error = error {
                NSLog("搜尋 Fail : \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let response = response as?  GTLRYouTube_SearchListResponse ,
                let items = response.items
            else {
                completion(nil)
                return
            }
            var results = [YoutubeResult]()
            for item in items{
                let videoId =  item.identifier?.videoId
                let playlistId = item.identifier?.playlistId
                guard
                    let kind = item.identifier?.kind,
                    let snippet = item.snippet,
                    let publishDate = snippet.publishedAt?.date,
                    let channelId = snippet.channelId,
                    let channelName = snippet.channelTitle,
                    let name = snippet.title,
                    let infoDescription = snippet.descriptionProperty,
                    let thumbnailUrlStr = snippet.thumbnails?.defaultProperty?.url
                    else {continue}
                
                let resultInfo = YoutubeResult(kind: kind, publishDate: publishDate, channelId: channelId, channelName : channelName , name: name, infoDescription: infoDescription, thumbnailUrlStr: thumbnailUrlStr)
                resultInfo.videoId = videoId
                resultInfo.playlistId = playlistId
                resultInfo.isLiving = snippet.liveBroadcastContent == "live"
                NSLog("resultInfo name : \(resultInfo.name),是否為 Live:\(resultInfo.isLiving)")
                results.append(resultInfo)
            }
            completion(results)
        }
    }
}

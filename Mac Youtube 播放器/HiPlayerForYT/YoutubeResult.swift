//
//  YoutubeResult.swift
//  HiPlayerForYT
//
//  Created by Uran on 2019/5/16.
//  Copyright © 2019 Uran. All rights reserved.
//

import Cocoa
enum SearchResultType : String {
    case video = "youtube#video"
    case playlist = "youtube#playlist"
    case channel = "youtube#channel"
}
class YoutubeResult: NSObject {
    var playlistId : String?
    var videoId : String?
    var kind : String {
        didSet{
            switch self.kind {
            case SearchResultType.channel.rawValue:
                self.resultType = .channel
                break
            case SearchResultType.playlist.rawValue:
                self.resultType = .playlist
                break
            default:
                self.resultType = .video
                break
            }
        }
    }
    var resultType : SearchResultType = .channel
    var publishDate : Date
    var channelId : String
    var channelName : String
    var name : String
    var infoDescription : String
    var thumbnailUrlStr : String
    var isLiving : Bool = false
    init(kind : String , publishDate : Date , channelId : String , channelName : String , name : String , infoDescription : String , thumbnailUrlStr : String) {
        self.kind = kind
        self.publishDate = publishDate
        self.channelId = channelId
        self.channelName = channelName
        self.name = name
        self.infoDescription = infoDescription
        self.thumbnailUrlStr = thumbnailUrlStr
    }
}

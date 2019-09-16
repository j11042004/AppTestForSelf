//
//  Song.swift
//  SongDecoder
//
//  Created by Uran on 2018/11/19.
//  Copyright © 2018 Uran. All rights reserved.
//

import Foundation
struct Song : Codable {
    /** 演奏者 */
    var artistName: String
    /** 歌名 */
    var trackName: String
    /** 專輯名 */
    var collectionName: String?
    /** 音訊檔  */
    var previewUrl: URL
    /** 專輯 Image Url */
    var artworkUrl100: URL
    /** 歌曲價格 */
    var trackPrice: Double?
    /** 出的時間 */
    var releaseDate: Date
    var isStreamable: Bool?
}


struct SongResults: Codable {
    var resultCount: Int
    var results: Array<Song>
}

//
//  SongTableModle.swift
//  SongDecoder
//
//  Created by Uran on 2018/11/19.
//  Copyright © 2018 Uran. All rights reserved.
//

import UIKit
typealias VoidCompletion = ()->()
class SongTableModle: NSObject {
    let serviceApi : ServiceApiProtocol
    private var songViewModule : [SongCellModel] = [SongCellModel]()
    private var songs : [Song] = [Song]()
    //MARK:- 控制畫面用變數
    var reloadTableClosure : VoidCompletion?
    var waitingClosure : VoidCompletion?
    var alertClosure : VoidCompletion?
    var isLoading = false{
        didSet{
            self.waitingClosure?()
        }
    }
    var alertMessage : String?{
        didSet{
            self.alertClosure?()
        }
    }
    var cellCount : Int = 0{
        didSet{
            self.reloadTableClosure?()
        }
    }
    
    
    init(service : ServiceApiProtocol = SongServiceApi()) {
        self.serviceApi = service
    }
    /** 更新 歌曲訊息 */
    func updateInfo(With urlStr : String ){
        self.serviceApi.updateApiInfo(urlStr: urlStr) { [weak self](success, songs, error) in
            if let error = error {
                self?.alertMessage = error.localizedDescription
                return
            }
            // 更新 Songs
            self?.songs = [Song]()
            guard let songs = songs else{
                return
            }
            self?.songs = songs
            // 更新 Song Cell Model
            self?.songViewModule = [SongCellModel]()
            for song in songs{
                let cellModel = self!.createSongCellModel(with: song)
                self?.songViewModule.append(cellModel)
            }
            if let songInfos = self?.songViewModule{
                self?.cellCount = songInfos.count
            }
        }
    }
    /** 取的指定的 CellModel */
    func getSongCellModel(for index : Int) -> SongCellModel? {
        if index >= self.cellCount {
            return nil
        }
        return self.songViewModule[index]
    }
    /** 現在被點到的Cell 資訊 */
    func nowTapCell(for indexPath : IndexPath)->Song?{
        if indexPath.row >= self.songs.count ||
            self.songs.count != self.songViewModule.count{
            return nil
        }
        let selectSong = self.songs[indexPath.row]
        return selectSong
    }
    //MARK:- Private Function
    private func createSongCellModel(with song:Song) -> SongCellModel{
        let img = self.getImageFromUrl(with: song.artworkUrl100)
        let songCell = SongCellModel(name: song.trackName, image: img, singer: song.artistName)
        
        return songCell
    }
}

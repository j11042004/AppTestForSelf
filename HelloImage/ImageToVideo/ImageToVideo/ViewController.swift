//
//  ViewController.swift
//  ImageToVideo
//
//  Created by Uran on 2018/7/17.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class ViewController: UIViewController {
    var images = [UIImage]()
    let imageStrings = [ "word.png",
                         "jobs.png",
                         "noImage.png",
                         "sss.jpeg",
                         "sakura.jpeg",
                         "sad 2.jpeg" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for str in imageStrings{
            let img = UIImage(named: str)!
            images.append(img)
        }
        for index in 0..<2000{
            let d = index % imageStrings.count
            images.append(images[d])
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let settings = ImagesToVideo.videoSettings(width: (images[0].cgImage?.width)!, height: (images[0].cgImage?.height)!)
        let movieMaker = ImagesToVideo(videoSettings: settings)
        movieMaker.createMovieFrom(images: images){ (fileURL:URL) in
            print("saved url : \(fileURL)")
            let avVc = AVPlayerViewController()
            avVc.player = AVPlayer(url: fileURL)
            DispatchQueue.main.async {
                self.present(avVc, animated: true, completion: nil)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


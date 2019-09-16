//
//  ViewController.swift
//  HelloTextToSound
//
//  Created by Uran on 2018/6/28.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    
    @IBOutlet weak var speakTextView: UITextView!
    let speecher = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        speecher.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func speakText(_ sender: UIButton) {
        // 停止說話
        speecher.stopSpeaking(at: AVSpeechBoundary.immediate)
        guard let speakText = speakTextView.text else {
            return
        }
        let utterance = AVSpeechUtterance(string: speakText)
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // 口音
        utterance.rate = 0.4 // 話說的速率
        utterance.pitchMultiplier = 1 // 高音頻率([0.5 - 2] Default = 1)
        utterance.volume = 0.5 // 聲音大小([0-1] Default = 1)
        // 開始進行說話
        speecher.speak(utterance)
    }
    
}
extension ViewController : AVSpeechSynthesizerDelegate{
    //告知要更換的內容
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        // 將指定範圍的字改成紅色
        mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: characterRange)
        self.speakTextView.attributedText = mutableAttributedString
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.speakTextView.attributedText = NSAttributedString(string: utterance.speechString)
    }
}

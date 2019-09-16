//
//  ViewController.swift
//  HelloAttributedText
//
//  Created by Uran on 2018/11/20.
//  Copyright © 2018 WalkGame. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var inputTextField: UITextField!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellId = "ChatTableCell"
    
    fileprivate var selectColor : UIColor = .white
    
    var selectMessages : [NSAttributedString] = [NSAttributedString]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputTextField.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    @IBAction func createPicWithText(_ sender: UIButton) {
        
    }
    @IBAction func addImg(_ sender: UIButton) {
        
        let testImgUrlStr = "https://edge.camerabay.tv/pimg/lamigo.png"
        
        let attributedString = NSMutableAttributedString(string: "")
        let textAttachment = NSTextAttachment()
        NSLog("開始取得 image")
        guard let url = URL(string: testImgUrlStr),
            let data = try? Data.init(contentsOf: url),
            let iconImg = UIImage(data: data)
        else {
            return
        }
        NSLog("結束取得 image")
        textAttachment.image = iconImg;
        let imgAttrubuteStr = NSAttributedString(attachment: textAttachment)
        /// 訊息 Attribute string
        let messageAttributeStr = NSMutableAttributedString(string: "Vip Hello iconImage", attributes: [NSAttributedString.Key.foregroundColor : UIColor.brown])
       
        let range = NSString(string: messageAttributeStr.string).range(of: "Vip")
        NSLog("range : \(range)")
        messageAttributeStr.replaceCharacters(in: range, with: imgAttrubuteStr)
        
        self.selectMessages.append(messageAttributeStr)
        self.tableView.reloadData()
    }
    
    @IBAction func changeRed(_ sender: Any) {
        self.selectColor = .red
        let resultAttributeStr = NSMutableAttributedString()
        let firstAttributeStr = NSAttributedString(string: "first", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        resultAttributeStr.append(firstAttributeStr)
        
        let seconeAttributeStr = NSAttributedString(string: "Second", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        resultAttributeStr.append(seconeAttributeStr)
        
        self.selectMessages.append(resultAttributeStr)
        self.tableView.reloadData()
        // 取代 first Attributestring 為 image attributeString
        let replaceAttributeStr = NSMutableAttributedString(attributedString: resultAttributeStr)
        let range = NSString(string: resultAttributeStr.string).range(of: firstAttributeStr.string)
        
        let img : UIImage = UIImage(named: "128k.png")!
        let attachment = NSTextAttachment()
        attachment.image = img
        attachment.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        let imgAttributeStr = NSAttributedString(attachment: attachment)
        replaceAttributeStr.replaceCharacters(in: range, with: imgAttributeStr)
        self.selectMessages.append(replaceAttributeStr)
        self.tableView.reloadData()
    }
    @IBAction func changeGreen(_ sender: Any) {
        self.selectColor = .green
        let message = "臣亮言：先帝創業未半，而中道崩殂。今天下三分，益州疲弊，此誠危急存亡之秋也。然侍衛之臣，不懈於內；忠志之士，忘身於外者，蓋追先帝之殊遇，欲報之於陛下也。誠宜開張聖聽，以光先帝遺德，恢弘志士之氣；不宜妄自菲薄，引喻失義，以塞忠諫之路也。宮中府中，俱為一體，陟罰臧否，不宜異同。若有作姦犯科，及為忠善者，宜付有司，論其刑賞，以昭陛下平明之治，不宜篇私，使內外異法也。"
        let attributeStr = NSAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor : self.selectColor])
        self.selectMessages.append(attributeStr)
        self.tableView.reloadData()
    }
    @IBAction func changePurple(_ sender: Any) {
        self.selectColor = .purple
        let message = "Test https://www.google.com hello https://www.facebook.com"
        let attributeStr = NSMutableAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor : UIColor.purple])
        // 進行正則表達式取出聊天內容中的圖片資訊
        let parten = "https://[a-zA-Z0-9\\../_?=&%-]+"
        let regex = try? NSRegularExpression(pattern: parten, options: .caseInsensitive)
        // 取得符合正則表達式的結果
        let regexResults = regex?.matches(in: message, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, message.count))
        // 判斷結果是否為 nil 或 count 為 0
        guard var results = regexResults ,
            results.count != 0
            else {
                return
        }
        results.reverse()
        for result in results {
            let range = result.range
            let urlStr = NSString(string: message).substring(with: range)
            guard let url = URL(string: urlStr) else {continue}
            
            attributeStr.addAttribute(.link, value: url, range: range)
            
            let attributeDict : [NSAttributedString.Key : Any] = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.thick.rawValue]
            attributeStr.addAttributes(attributeDict, range: range)
        }
        self.selectMessages.append(attributeStr)
        self.tableView.reloadData()
    }
    
}
extension ViewController :UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension ViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("Cell selected")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! ChatTableCell
        let message = self.selectMessages[indexPath.row]
        let linkAttributeStr : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor.yellow , NSAttributedString.Key.underlineStyle : NSUnderlineStyle.byWord.rawValue]
        
        cell.set(message: message, linkAttributes: linkAttributeStr)
        return cell
    }
}

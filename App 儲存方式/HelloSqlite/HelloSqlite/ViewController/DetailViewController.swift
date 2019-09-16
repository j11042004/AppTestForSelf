//
//  DetailViewController.swift
//  HelloSqlite
//
//  Created by Uran on 2018/2/26.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,ImagePickerManagerDelegate {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var image : UIImage?
    var idText : String?
    var nameText : String?
    
    private let sqlManager : SqlManager = SqlManager.standard
    private let imagePicker : ImagePickerManager = ImagePickerManager.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = image{
            self.imageView.image = image
        }
        if let id = idText{
            self.idLabel.text = id
        }
        self.nameTextField.text = nameText
        self.imageView.contentMode = UIViewContentMode.scaleAspectFit
        imagePicker.imagePickerDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController != nil{
            let cameraBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera, target: self, action: #selector(DetailViewController.getImage))
            let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(DetailViewController.saveData))
            let barItems = [saveBtn,cameraBtn]
            self.navigationItem.rightBarButtonItems = barItems
        }
    }
    @objc func getImage() {
        imagePicker.showImageAlert()
    }
    @objc func saveData() {
        var savedImg : UIImage!
        if let image = self.imageView.image {
            savedImg = image
        }else{
            savedImg = UIImage()
        }
        
        if let id = self.idLabel.text {
            let changeName = self.nameTextField.text
            sqlManager.updateData(id: id, name: changeName, image: savedImg, complete: { (success,errmsg)  in
                if let errmsg = errmsg{
                    NSLog("收到的錯誤訊息: \(errmsg)")
                }
                if success{
                    self.reloadResult()
                    DispatchQueue.main.async {
                        if (self.navigationController != nil){
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            })
        }
    }
    func reloadResult(){
        self.sqlManager.searchDB(showAll: true, id: nil) { (success, results) in
            if !success{
                for result in results{
                    for dictionary in result{
                        print(dictionary.key)
                        print(dictionary.value as Any)
                    }
                }
                return
            }
            for result in results{
                if result["iid"] as? String != self.idLabel.text{
                    continue
                }
                if let image = result["image"] as? UIImage{
                    self.imageView.image = image
                    break
                }
            }
        }
    }
    // MARK: ImagePickerManagerDelegate function
    func imagePickerGetImage(image: UIImage?) {
        self.imageView.image = image
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

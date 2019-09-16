//
//  ViewController.swift
//  ImagePickerManager
//
//  Created by Uran on 2018/7/5.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController , ImagePickerDelegate {

    @IBOutlet weak var showImageView: UIImageView!{
        didSet{
            showImageView.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.text?.removeAll()
        }
    }
    
    let imagePicker = ImagePicker.sharedInstance
    let waitView = WaitingView()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.pickerDelegate = self
        
        self.view.addSubview(waitView)
        self.waitView.setCoverConstraint(SuperView: self.view)
        self.waitView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cameraGetImage(_ sender: UIButton) {
        imagePicker.getImage(From: .camera)
    }
    @IBAction func  photoLibGetImage(_ sender : UIButton!) {
        imagePicker.getImage(From: .album)
    }
    
    func imagePickerGotImage(image: UIImage?, imageName: String?) {
        self.showImageView.image = image
        self.nameLabel.text = imageName
    }
    func imagePickerStartRequestAuth() {
        self.waitView.isHidden = false
    }
    func imagePickerFinishRequestAuth() {
        self.waitView.isHidden = true
    }
}


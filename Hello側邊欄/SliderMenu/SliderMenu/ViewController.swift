//
//  ViewController.swift
//  SliderMenu
//
//  Created by Uran on 2019/7/29.
//  Copyright © 2019 Uran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var animateSegmentControl: UISegmentedControl!
    @IBOutlet weak var blurSegmentControl: UISegmentedControl!
    @IBOutlet weak var menuAlphaSlider: UISlider!
    @IBOutlet weak var mainShowedAlphaSlider: UISlider!
    @IBOutlet weak var mainScaleSlider: UISlider!
    @IBOutlet weak var menuShadowSlider: UISlider!
    @IBOutlet weak var menuWidthSlider: UISlider!
    @IBOutlet weak var menuScaleSlider: UISlider!
    @IBOutlet weak var statusAlphaSlider: UISlider!
    
    //MARK: SideMenu
    fileprivate let sideControl = SideMenuManager.defaultManager
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSideMenu()
        // 取的 default 值
        self.updateUIInfo(SideMenuSettings())
        self.updateMenus()
    }
    //MARK:- IBAction
    @IBAction func showLeftSide(_ sender: UIBarButtonItem) {
        if let leftVC = self.sideControl.leftMenuNavigationController {
            self.present(leftVC, animated: true, completion: nil)
        }
    }
    @IBAction fileprivate func changeValue(_ control : UIControl){
        updateMenus()
    }
}

extension ViewController {
    
    /// 根據 SideMenuSettings 的預設值設定 ＵＩ
    fileprivate func updateUIInfo(_ settings : SideMenuSettings){
        let styles : [UIBlurEffect.Style] = [.dark , .light , .extraLight]
        var blurIndex = 0
        if let blurEffectStyle = settings.blurEffectStyle {
            blurIndex = styles.firstIndex(of: blurEffectStyle) ?? 0
        }
        self.blurSegmentControl.selectedSegmentIndex = blurIndex
        
        self.statusAlphaSlider.value = Float(settings.statusBarEndAlpha)
        NSLog("StatusBar Alpha 為 : \(settings.statusBarEndAlpha)")
        self.menuAlphaSlider.value = Float(settings.presentationStyle.menuStartAlpha)
        NSLog("側邊一開始的 Alpha : \(settings.presentationStyle.menuStartAlpha)")
        self.menuScaleSlider.value = Float(settings.presentationStyle.menuScaleFactor)
        NSLog("Side 顯示期間 Side 的縮放效果 : \(settings.presentationStyle.menuScaleFactor)")
        self.mainShowedAlphaSlider.value = Float(settings.presentationStyle.presentingEndAlpha)
        NSLog("Side 顯示後 主 View 的 Alpha : \(settings.presentationStyle.presentingEndAlpha)")
        self.mainScaleSlider.value = Float(settings.presentationStyle.presentingScaleFactor)
        NSLog("Side 顯示時 主View的縮放效果 : \(settings.presentationStyle.presentingScaleFactor)")
        self.menuWidthSlider.value = Float(settings.menuWidth / min(view.frame.width, view.frame.height))
        NSLog("Sider 寬比例 : \(settings.menuWidth / min(view.frame.width, view.frame.height))")
        self.menuShadowSlider.value = Float(settings.presentationStyle.onTopShadowOpacity)
        NSLog("主 view 與 Side 接合的陰影 : \(settings.presentationStyle.onTopShadowOpacity)")
    }
    /// 設定要顯示的 SideMenus
    fileprivate func setupSideMenu(){
        // 設定 Side Menu VC
        if let sideMenuNavigationVC = storyboard?.instantiateViewController(withIdentifier: "SideTableViewController") as? SideTableViewController {
            self.sideControl.leftMenuNavigationController = UISideMenuNavigationController(rootViewController: sideMenuNavigationVC)
        }
        
        sideControl.addScreenEdgePanGesturesToPresent(toView: self.view)
    }
    
    /// 更新 Side Menus 設定
    fileprivate func updateMenus() {
        let settings = self.createSideSettings()
        sideControl.leftMenuNavigationController?.settings = settings
        sideControl.rightMenuNavigationController?.settings = settings
    }
    /// 建立要使用的 Side menus 設定
    ///
    /// - Returns: Side menus 設定
    fileprivate func createSideSettings() -> SideMenuSettings{
        let presentationStyles : [SideMenuPresentationStyle] = [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn]
        let presentationStyle = presentationStyles[self.animateSegmentControl.selectedSegmentIndex]
        presentationStyle.backgroundColor = UIColor.yellow
        // 設定 陰影
        presentationStyle.onTopShadowOpacity = menuShadowSlider.value
        // 設定 動畫時的 Menu 畫面設定 Alpha 與 Scale
        presentationStyle.menuStartAlpha = CGFloat(menuAlphaSlider.value)
        presentationStyle.menuScaleFactor = CGFloat(menuScaleSlider.value)
        // 設定 主畫面動畫時的 Alpha 與 Scale
        presentationStyle.presentingEndAlpha = CGFloat(mainShowedAlphaSlider.value)
        presentationStyle.presentingScaleFactor = CGFloat(mainScaleSlider.value)
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = min(self.view.bounds.width, self.view.bounds.height) * CGFloat(menuWidthSlider.value)
        
         let styles:[UIBlurEffect.Style?] = [nil, .dark, .light, .extraLight]
        // 設定 背景
        settings.blurEffectStyle = styles[blurSegmentControl.selectedSegmentIndex]
        // 設定 Status Bar 得 Alpha
        settings.statusBarEndAlpha = CGFloat(statusAlphaSlider.value)
        return settings
    }
    
}





extension ViewController : UISideMenuNavigationControllerDelegate{
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        NSLog("Side Menu 將要顯示並使用動畫:\(animated)")
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        NSLog("Side Menu 已顯示並使用動畫:\(animated)")
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        NSLog("Side Menu 將要關閉並使用動畫:\(animated)")
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        NSLog("Side Menu 已關閉並使用動畫:\(animated)")
    }
}

//
//  ChatNaviViewController.swift
//  HelloFirebaseChat
//
//  Created by Uran on 2018/4/11.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class ChatNaviViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 若要經由 NavigationViewcontroller 傳值給下面的VC 就要寫在 viewdidload 中
//        if let vc = self.topViewController as? ChannelViewController{
//
//
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

}

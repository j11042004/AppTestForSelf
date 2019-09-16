//
//  TopViewControllerManager.h
//  HelloXib
//
//  Created by Uran on 2018/2/12.
//  Copyright © 2018年 Uran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopViewControllerManager : NSObject
+ (instancetype) sharedInstance;
/**
 取的最上層的 ViewController
 */
+(UIViewController *)topViewController;
/**
 取的最上層的 ViewController
 */
-(UIViewController *)topViewController;

@end

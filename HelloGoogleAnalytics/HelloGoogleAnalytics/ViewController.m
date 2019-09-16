//
//  ViewController.m
//  HelloGoogleAnalytics
//
//  Created by Uran on 2018/10/1.
//  Copyright © 2018年 Uran. All rights reserved.
//

#import "ViewController.h"
#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>
#import <GoogleAnalytics/GAIFields.h>

@interface ViewController ()
@property(nonatomic ,strong) NSString * trackKey ;
@property(nonatomic, strong) NSArray< UIColor *>* colors;
@property(nonatomic , assign) NSInteger index ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.trackKey = @"UA-126739995-1";
    self.colors = @[UIColor.redColor , UIColor.blueColor , UIColor.blackColor , UIColor.greenColor];
    self.view.backgroundColor = UIColor.redColor;
    self.index = 0;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:self.trackKey];
    // 設定當前頁面的代號或名字給 Analtics 知道
    [tracker set:kGAIScreenName value:@"EnterViewController"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

- (IBAction)open:(id)sender {
    self.index += 1;
    if (self.index >= self.colors.count) {
        self.index = 0;
    }
    UIColor * color = self.colors[self.index];
    self.view.backgroundColor = color;
    NSString * colorName = @"red";
    switch (self.index) {
        case 1:
            colorName = @"blue";
            break;
        case 2:
            colorName = @"black";
            break;
        case 3:
            colorName = @"green";
            break;
        default:
            break;
    }
    id<GAITracker> track = [[GAI sharedInstance] trackerWithTrackingId:self.trackKey];
    
    NSNumber * numValue = [NSNumber numberWithInteger:self.index];
    GAIDictionaryBuilder * gaiDict =  [GAIDictionaryBuilder createEventWithCategory:@"ButtonAction" action:@"ChangeNextColor" label:colorName value:numValue];
    [track send:gaiDict.build];
}
- (IBAction)close:(id)sender {
    self.index -= 1;
    if (self.index < 0) {
        self.index = self.colors.count-1;
    }
    UIColor * color = self.colors[self.index];
    self.view.backgroundColor = color;
    NSString * colorName = @"red";
    switch (self.index) {
        case 1:
            colorName = @"blue";
            break;
        case 2:
            colorName = @"black";
            break;
        case 3:
            colorName = @"green";
            break;
        default:
            break;
    }
    id<GAITracker> track = [[GAI sharedInstance] trackerWithTrackingId:self.trackKey];
    NSNumber * numValue = [NSNumber numberWithInteger:self.index];
    GAIDictionaryBuilder * gaiDict =  [GAIDictionaryBuilder createEventWithCategory:@"ButtonAction" action:@"ChangeLastColor" label:colorName value:numValue];
    [track send:gaiDict.build];
}
- (IBAction)sendError:(id)sender {
    id<GAITracker> track = [[GAI sharedInstance] trackerWithTrackingId:self.trackKey];
    
    GAIDictionaryBuilder * gaiDict =  [GAIDictionaryBuilder createEventWithCategory:@"ButtonAction" action:@"sendPlayerError" label:@"model:iPhone X,iOSVersion:12.1.3,bitrate:自動(720@3.1m),error:HTTP 404: File Not Found,carrierName:遠傳電信,netType :4g網路,appVersion:2.20.4,channelCode:cbch000066,user id:j11042004@gmail.com" value:nil];
    [track send:gaiDict.build];
}



@end

//
//  ViewController.m
//  HelloSwiftBridgeToObjC-Swift.h
//
//  Created by Uran on 2018/6/5.
//  Copyright © 2018年 Uran. All rights reserved.
//

#import "ViewController.h"
#import "HelloSwiftBridgeToObjC-Swift.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic , strong )HelloSwift * helloSwift;
@property (nonatomic ,strong ) YellowViewController * yellowVC ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle * bundle = [NSBundle bundleForClass:self.class];
    self.helloSwift = [HelloSwift shardInstance];
    self.yellowVC = [[YellowViewController alloc] initWithNibName:@"YellowViewController" bundle:bundle];
}

- (IBAction)saySwiftHello:(UIButton *)sender {
    NSString * hello = [self.helloSwift sayHello];
    if (self.textLabel.text.length == 0){
        self.textLabel.text = hello;
    }else{
        self.textLabel.text = @"";
    }
}
- (IBAction)showSwiftViewController:(id)sender {
    [self presentViewController:self.yellowVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

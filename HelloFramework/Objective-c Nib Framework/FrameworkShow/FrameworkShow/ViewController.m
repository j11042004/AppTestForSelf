//
//  ViewController.m
//  FrameworkShow
//
//  Created by Uran on 2018/2/12.
//  Copyright © 2018年 Uran. All rights reserved.
//

#import "ViewController.h"
#import <XibFrameWork/XibFrameWork.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (IBAction)show:(id)sender {
    [XibViewController showXibViewController];
    
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"XibBundle" ofType:@"bundle"];
//    NSBundle * bundle = [NSBundle bundleWithPath:path];
//    XibViewController * xbc = [[XibViewController alloc] initWithNibName:@"XibViewController" bundle:bundle];
//    [self presentViewController:xbc animated:YES completion:nil];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

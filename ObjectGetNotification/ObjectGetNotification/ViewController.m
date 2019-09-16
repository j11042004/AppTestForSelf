//
//  ViewController.m
//  ObjectGetNotification
//
//  Created by Uran on 2017/12/28.
//  Copyright © 2017年 Uran. All rights reserved.
//

#import "ViewController.h"
#import "CallNoteObject.h"
@interface ViewController ()<CallDelegate>
{
    NSNotificationCenter * notification;
    CallNoteObject * object;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    object = [CallNoteObject shared];
    
    
    
    notification = [NSNotificationCenter defaultCenter];
}
- (IBAction)object1Btn:(id)sender {
    [notification postNotificationName:@"getObject1" object:@"hello"];
}
- (IBAction)object2Btn:(id)sender {
    [notification postNotificationName:@"getObject2" object:@"hi"];
}

-(void)sendObject1:(NSString *)str1{
    NSLog(@"sendObject1 :%@",str1);
    
    
}
-(void)sendObject2:(NSString *)str2{
    NSLog(@"sendObject2 :%@",str2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

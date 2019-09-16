//
//  ViewController.m
//  MyCircleView
//
//  Created by 孙昊 on 2017/7/6.
//  Copyright © 2017年 sunhao. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (nonatomic,strong) CircleView *circleV;
@end

@implementation ViewController

- (void)viewDidLoad {
   [super viewDidLoad];
    _circleV = [[CircleView alloc] initWithWidth:15];
    _circleV.frame = CGRectMake(0, 0, self.showView.frame.size.width, self.showView.frame.size.height);
    [self.showView addSubview:_circleV];
    [_circleV circleWithProgress:0 Animate:YES];

}
- (IBAction)show:(id)sender {
    NSInteger text = [_textField.text integerValue];
    _textField.text = @"";
    if (!text || text < 0) {
        NSLog(@"text : %ld",(long)text);
        return;
    }
    //设置进度,是否有动画效果
    [_circleV circleWithProgress:text Animate:YES];
}
- (IBAction)close:(id)sender {
    [_circleV circleWithProgress:0 Animate:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

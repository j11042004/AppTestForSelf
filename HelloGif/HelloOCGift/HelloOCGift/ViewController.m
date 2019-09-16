//
//  ViewController.m
//  HelloOCGift
//
//  Created by Uran on 2018/3/2.
//  Copyright © 2018年 Uran. All rights reserved.
//

#import "ViewController.h"
#import "YYImage.h"
@interface ViewController (){
    YYAnimatedImageView * yyImgView;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *YYImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString * urlStr = @"https://media.giphy.com/media/QJHwM0zD4U4ek9Luz7/giphy.gif";
    NSURL * url = [NSURL URLWithString:urlStr];
    NSData * urlData = [NSData dataWithContentsOfURL:url];
    UIImage * image = [UIImage imageWithData:urlData];

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = image;
    
    // 使用 YYImage 套件
    
    YYImage * gifImage = [YYImage imageNamed:@"niconiconi"];
    YYImage * urlImage = [YYImage imageWithData:urlData];

    self.YYImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.YYImageView.image = urlImage;
    [self yyImage];
}
-(void)yyImage{
    YYImage * gifImage = [YYImage imageNamed:@"niconiconi"];

    yyImgView = [[YYAnimatedImageView alloc] initWithImage:gifImage];
    yyImgView.contentMode = UIViewContentModeScaleAspectFit;
    yyImgView.frame = self.imageView.frame;
    [self.view addSubview:yyImgView];
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    yyImgView.frame = self.imageView.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

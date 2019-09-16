//
//  HelloView.m
//  HelloXib
//
//  Created by Uran on 2018/2/12.
//  Copyright © 2018年 Uran. All rights reserved.
//

#import "HelloView.h"
#import "TopViewControllerManager.h"
#import "define.h"
@interface HelloView(){
    
}
@property (weak, nonatomic) IBOutlet UILabel *label;
@property(nonatomic,strong) TopViewControllerManager * topVCManager;

@end
@implementation HelloView

-(instancetype)init{
    self = [self init];
    if (self) {
        [self customerInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self customerInit];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customerInit];
    }
    return self;
}


-(void)customerInit{
    NSBundle * bundle = BundleSelf;
    UINib * nib = [UINib nibWithNibName:@"HelloView" bundle:bundle];
    UIView * helloView = (UIView *)[nib instantiateWithOwner:self options:nil].firstObject;
    if (helloView == nil){
        NSLog(@"helloView is nil");
    }
    helloView.frame = self.bounds;
    [self addSubview:helloView];
    
    _topVCManager = [TopViewControllerManager sharedInstance];
}

- (IBAction)showAlert:(UIButton *)sender {
    
    UIViewController * vc = [_topVCManager topViewController];
    NSLog(@"Hi");
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Hello" message:@"你好" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.label.text = alert.textFields.firstObject.text;
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [vc presentViewController:alert animated:YES completion:nil];
    
}


@end

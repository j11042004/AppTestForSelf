//
//  CusTableViewCell.m
//  HelloXib
//
//  Created by Uran on 2018/2/12.
//  Copyright © 2018年 Uran. All rights reserved.
//  Xib 上拉取 IBOutlet 與 IBAction 不能與 File's Owner 做連結

#import "CusTableViewCell.h"
#import "define.h"
@interface CusTableViewCell()

@end
@implementation CusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (IBAction)addText:(UIButton *)sender {
    NSString * text = self.showLabel.text;
    self.showLabel.text = [NSString stringWithFormat:@"%@ hello",text];
    NSLog(@"Hello");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

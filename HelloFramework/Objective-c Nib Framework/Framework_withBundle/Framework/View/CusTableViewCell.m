//
//  CusTableViewCell.m
//  HelloXib
//
//  Created by Uran on 2018/2/12.
//  Copyright © 2018年 Uran. All rights reserved.
//

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

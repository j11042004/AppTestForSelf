//
//  CusTableViewCell.h
//  HelloXib
//
//  Created by Uran on 2018/2/12.
//  Copyright © 2018年 Uran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusTableViewCell : UITableViewCell
@property(nonatomic,strong) NSString * showText;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@end

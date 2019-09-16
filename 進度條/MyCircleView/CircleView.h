//
//  CircleView.m
//  進度條
//
//
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView
-(instancetype)initWithWidth:(CGFloat)width ;
- (void)circleWithProgress:(NSInteger)progress Animate:(BOOL)animate;

@end

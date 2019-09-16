//
//  CircleView.m
//  進度條
//
//
//

#import "CircleView.h"

@interface CircleView ()
/**進度條的Label*/
@property (nonatomic,strong) UILabel *numbLb;
/**進度條未填滿的背景*/
@property (nonatomic,strong) CAShapeLayer *backgroundLine;
/**進度條填滿的顏色 Mask*/
@property (nonatomic,strong) CAShapeLayer *mainLine;
/**建立漸層色圖層*/
@property (nonatomic,strong) CAGradientLayer *grain;

// 進度條寬度
@property (nonatomic,assign) CGFloat strokelineWidth;
/**進度條初始數值*/
@property (nonatomic,assign) CGFloat progressFlag;
/**進度條數值*/
@property (nonatomic,assign) NSInteger progressValue;
/**Label 動畫的計時器*/
@property (nonatomic,strong) NSTimer *labelTimer;
@end
@implementation CircleView


#pragma mark - Public function
-(instancetype)initWithWidth:(CGFloat)width{
    self = [super init];
    if (width>= 0) {
        width = 15;
    }
    _strokelineWidth = width;
    return self;
}
/**
 進度條進度設定
 @param progress 進度條 進度設定
 @param animate 是否有動畫
 */
- (void)circleWithProgress:(NSInteger)progress Animate:(BOOL)animate{
    if (animate) {
        // 進度條 起始數字
        _progressFlag = 0;
        // 進度條終點數字
        _progressValue = progress;
        
        
        // 貝茲曲線建立圓形，起始與終點為 270 度
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.width/2 - _strokelineWidth startAngle:M_PI_2 endAngle:M_PI_2 + M_PI*2 clockwise:YES];
        // 設定線的貝茲曲線
        self.backgroundLine.path = path.CGPath;
        self.mainLine.path = path.CGPath;
        [self.grain setMask:_mainLine];
        
        // 動畫效果
        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        // 動畫執行時間
        pathAnima.duration = progress/100.0f;
        pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnima.toValue = [NSNumber numberWithFloat:progress/100.f];
        pathAnima.fillMode = kCAFillModeForwards;
        pathAnima.removedOnCompletion = NO;
        
        [_mainLine addAnimation:pathAnima forKey:@"strokeEndAnimation"];
        
        if (progress>0){
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _labelTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeNameLabelText) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] run];
            });
        }else{
            self.numbLb.attributedText = [self labelStytle:0];
        }
        
    }else{
        
        self.numbLb.attributedText = [self labelStytle:progress];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.width/2 - _strokelineWidth startAngle:M_PI_2 endAngle:M_PI_2 + M_PI*2 clockwise:YES];
        
        self.backgroundLine.path = path.CGPath;
        self.mainLine.path = path.CGPath;
        self.mainLine.strokeStart = 0.f;
        self.mainLine.strokeEnd = progress/100.f;
        [self.grain setMask:self.mainLine];
    }
}
#pragma mark - Private Function
/** 設定 進度條 % 的數值*/
-(NSMutableAttributedString*)labelStytle:(NSInteger)value{
    NSString* pace=[NSString stringWithFormat:@"%ld%@",value,@"%"];
    NSMutableAttributedString* pace1=[[NSMutableAttributedString alloc]initWithString:pace];
    [pace1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, pace.length-1)];
    [pace1 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(pace.length-1, 1)];
    NSRange titleRange = NSMakeRange(0, pace.length);
    // 設定 進度顯示 ％ 的顏色和值
    [pace1 addAttribute:NSForegroundColorAttributeName
                  value:[self colorWithHexString:@"#37b2f5"]
                  range:titleRange];
    return pace1;
}
/** 設定進度條中 Label 文字 更換 */
- (void)changeNameLabelText{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 設定進度條文字
        self.numbLb.attributedText = [self labelStytle:_progressFlag];
//        NSLog(@"_progressFlag:%f",_progressFlag);
    });
    
    if (_progressFlag >= _progressValue-1) {
        // 關閉計時器
        [_labelTimer invalidate];
        _labelTimer = nil;
    }
    _progressFlag += 1;
}


/**
 將色彩值轉成顏色
 @param colorStr 顏色色彩值
 @return UIColor
 */
- (UIColor *)colorWithHexString: (NSString *)colorStr
{
    // 將輸入的字串轉成色碼值
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // 轉成的字串應在 6~8 個字元
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // 用 NSRange 起始與間隔 取出 RGB
    NSRange range;
    // 間隔為 2
    range.length = 2;
    
    //r  起始為0
    range.location = 0;
    NSString *rString = [cString substringWithRange:range];
    //g 起始為2
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b 起始為4
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // 將 16 進位轉成 10 進位
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

#pragma mark - Lazy Load
- (UILabel *)numbLb {
    if(_numbLb == nil) {
        _numbLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _numbLb.center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
        _numbLb.textAlignment = NSTextAlignmentCenter;
        int fontNum = self.bounds.size.width/6;
        _numbLb.font = [UIFont boldSystemFontOfSize:fontNum];
        _numbLb.text = @"0%";
        [_numbLb setText:@"0%"];
        [self addSubview:_numbLb];
    }
    return _numbLb;
}
// 背景灰色的線條與齊圈起的範圍
- (CAShapeLayer *)backgroundLine {
    if(_backgroundLine == nil) {
        _backgroundLine = [[CAShapeLayer alloc] init];
        // _backgroundLine 所圍住區域的顏色
        _backgroundLine.fillColor = [UIColor clearColor].CGColor;
        // _backgroundLine 邊框的顏色
        _backgroundLine.strokeColor = [UIColor lightGrayColor].CGColor;
        // _backgroundLine 邊框的寬度
        _backgroundLine.lineWidth = _strokelineWidth;
        [self.layer addSublayer:_backgroundLine];
    }
    return _backgroundLine;
}

- (CAShapeLayer *)mainLine {
    if(_mainLine == nil) {
        _mainLine = [[CAShapeLayer alloc] init];
        _mainLine.fillColor = [UIColor clearColor].CGColor;
        _mainLine.strokeColor = [UIColor redColor].CGColor;
        _mainLine.lineWidth = _strokelineWidth;
        [self.layer addSublayer:_mainLine];
    }
    return _mainLine;
}


- (CAGradientLayer *)grain {
	if(_grain == nil) {
		_grain = [[CAGradientLayer alloc] init];
        _grain.frame = CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height);
//        [_grain setColors:[NSArray arrayWithObjects:
//                           (id)[[self colorWithHexString:@"f31414"] CGColor],
//                           (id)[[self colorWithHexString:@"f27200"] CGColor],
//                           (id)[[self colorWithHexString:@"ffff00"] CGColor],
//                           (id)[[self colorWithHexString:@"2bee22"] CGColor],
//                           (id)[[self colorWithHexString:@"32a7eb"] CGColor],
//                           nil]];
        id redColor = (id)[[UIColor redColor] CGColor];
        id orangeColor = (id)[[UIColor orangeColor] CGColor];
        id yellowColor = (id)[[UIColor yellowColor] CGColor];
        id greenColor = (id)[[UIColor greenColor] CGColor];
        id blueColor = (id)[[UIColor blueColor] CGColor];
        id purpleColor = (id)[[UIColor purpleColor] CGColor];

        NSArray * colors = @[redColor,orangeColor,yellowColor,greenColor,blueColor,purpleColor];
        // 設定所有漸層顏色
        [_grain setColors:colors];
        // 設定顏色的區間
        [_grain setLocations:@[@0, @0.25, @0.5, @0.75, @1]];
        [_grain setStartPoint:CGPointMake(0, 0)];
        [_grain setEndPoint:CGPointMake(1, 0)];
        _grain.type = kCAGradientLayerAxial;
        [self.layer addSublayer:_grain];
	}
	return _grain;
}


@end

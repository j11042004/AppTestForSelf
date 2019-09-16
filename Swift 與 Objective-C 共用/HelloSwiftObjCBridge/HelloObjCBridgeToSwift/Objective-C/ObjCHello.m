//
//  ObjCHello.m
//  HelloObjCBridgeToSwift
//
//  Created by Uran on 2018/6/5.
//  Copyright © 2018年 Uran. All rights reserved.
//

#import "ObjCHello.h"

@implementation ObjCHello

+(instancetype) sharedInstance{
    static ObjCHello * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ObjCHello alloc] init];
    });
    return instance;
}
@end

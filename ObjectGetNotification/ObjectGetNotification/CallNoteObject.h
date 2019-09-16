//
//  CallNoteObject.h
//  ObjectGetNotification
//
//  Created by Uran on 2017/12/28.
//  Copyright © 2017年 Uran. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CallDelegate <NSObject>
-(void) sendObject1:(NSString *) str1;
-(void) sendObject2:(NSString *) str2;
@end

@interface CallNoteObject : NSObject
+ (instancetype) shared;
@property(nonatomic,strong) id<CallDelegate> delegate;

+(void)sayHello;
@end

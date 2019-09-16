//
//  CallNoteObject.m
//  ObjectGetNotification
//
//  Created by Uran on 2017/12/28.
//  Copyright © 2017年 Uran. All rights reserved.
//

#import "CallNoteObject.h"

@implementation CallNoteObject
-(id)init {
    self = [super init];
    if (self) {
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getObject1:) name:@"getObject1" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getObject2:) name:@"getObject2" object:nil];
    }
    
    return self;
}

+ (instancetype) shared
{
    static CallNoteObject *shard = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shard = [[CallNoteObject alloc] init];
        
    });
    return shard;
}
+(void)sayHello{
    NSLog(@"static sayHello");
}


// notification func
-(void)getObject1:(NSNotification*)note{
    NSLog(@"event2:%@, object:%@", note, note.object);
    NSString * note1 = note.object;
    [self.delegate sendObject1:note1];
}
-(void)getObject2:(NSNotification*)note{
    NSLog(@"event2:%@, object:%@", note, note.object);
    NSString * note2 = note.object;
    [self.delegate sendObject2:note2];
}
@end

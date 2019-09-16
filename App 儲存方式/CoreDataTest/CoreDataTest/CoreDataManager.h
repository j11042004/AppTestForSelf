//
//  CoreDataManager.h
//  HelloMyCoreDataManager
//
//  Created by Uran on 2017/7/14.
//  Copyright © 2017年 Uran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataManager<ItemType> : NSObject

typedef void (^SaveComplete) (BOOL success);


-(instancetype _Nonnull ) initWithModel:(NSString *_Nullable)modelName
                             dbFileName:(NSString *_Nullable)dbFileName
                              dbPathURL:(NSURL *_Nullable)dbPathURL
                                sortKey:(NSString *_Nullable)sortKey
                             entityName:(NSString *_Nullable)entityName;

- (void)saveContextWithCompletion:(SaveComplete _Nonnull )completion;

-(NSInteger)count;

-(ItemType _Nullable ) createItem;
-(void) deleteItem:(ItemType _Nonnull ) item;
-(ItemType _Nonnull ) itemWithIndex:(NSInteger)index;

-(NSArray *_Nonnull) searchAtField:(NSString *_Nonnull) field
                forKeyWord:(NSString *_Nonnull) keyword;

@end

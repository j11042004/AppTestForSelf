//
//  CoreDataManager.m
//  HelloMyCoreDataManager
//
//  Created by Uran on 2017/7/14.
//  Copyright © 2017年 Uran. All rights reserved.
//

#import "CoreDataManager.h"
#import <UIKit/UIKit.h>


@interface CoreDataManager()<NSFetchedResultsControllerDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;



@end

@implementation CoreDataManager
{
    NSString * targetModelName;
    NSString * targetDBFileName;
    NSURL * targetDBPathURL;
    NSString * targetSortKey;
    NSString * targetEntityName;
    
    // 把自定義的block當成變數名
    SaveComplete saveCompletion;
}


-(instancetype) initWithModel:(NSString *)modelName
                   dbFileName:(NSString *)dbFileName
                    dbPathURL:(NSURL  * )dbPathURL
                      sortKey:(NSString *)sortKey
                   entityName:(NSString *)entityName{
    self = [super init];
    // Keep parameters as variables.
    targetModelName =modelName;
    targetDBFileName = dbFileName;
    targetDBPathURL = dbPathURL;
    targetSortKey = sortKey;
    targetEntityName = entityName;
    
    // USE Document as default place to store db dile;
    // 若傳入的dbPathURL是nil，則將Document目錄設為預設的位置
    if (dbPathURL == nil) {
        targetDBPathURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    }
    return self;
}


#pragma mark - Core Data stack
//==========================Core Data Kernel==============================
// 比對kent講義資料管理篇p25的圖
/* synthesize:
 只能放在@implementation中，定義這個@property對內有另一個名稱
*/
/*
 _ != self
 oc: self是指抓取物件，_是指referance，在arc幾乎相同，mrc完全不同
 arc 建立@property，會在compiler時，自動建立相對應的@synthesize
 以前有多少 @property 就要多少 @synthesize
 @synthesize 定義 @property 對外與對內的行為名稱
 @property 加readonly就要設  @synthesize
 */
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//Getterz: 寫法，managedObjectModel 會直接呼叫以他命名的方法，類似singleton

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    // 從Bundle找資料模型檔，xcode complier會把.xcdatamodeld轉成.momd
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:targetModelName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    // 改成自己的要存的檔名與路徑
    NSURL *storeURL = [targetDBPathURL URLByAppendingPathComponent:targetDBFileName];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    // NSSQLiteStoreType: Use SQLite，addPersistentStoreWithType: 盡量不要亂調，怕會遺失資料
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    // NSMainQueueConcurrencyType ：coreData資料處理時是否可以平行處理
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContextWithCompletion:(SaveComplete)completion {
    //NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (_managedObjectContext != nil) {
        NSError *error = nil;
        saveCompletion = completion;
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } else{
            completion(true);
            // 還原 saveCompletion
            saveCompletion = nil;
        }
    }else{
        completion(false);
    }
}

//============================Core Data Kernel ===========================

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:targetEntityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:targetSortKey ascending:true];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:targetEntityName];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

// Do something after Changed
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    if (saveCompletion != nil) {
        saveCompletion(true);
        saveCompletion = nil;
    }
}


//=======================Insert=Delete=Search=====================

-(NSManagedObject *) createItem{
   // Create New Item
    NSManagedObject *newItem = [NSEntityDescription insertNewObjectForEntityForName:targetEntityName inManagedObjectContext:self.managedObjectContext];
    
    return newItem;
}
-(void) deleteItem:(NSManagedObject *) item{
    // 何時存檔，等使用者做決定
    [self.managedObjectContext deleteObject:item];
    
}
-(NSManagedObject *) itemWithIndex:(NSInteger)index{
    // 要支援NSIndexPath indexPathForRow方法，要去import uikit，因為是定義在uikit
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

-(NSArray *) searchAtField:(NSString *) field
                forKeyWord:(NSString *) keyword{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:targetEntityName];
    NSString *format = [NSString stringWithFormat:@"%@ contains[cd] %%@",field];
    NSLog(@"field : %@ , %@",field,format);
    // @"%@ contains[cd] %%@" -> name contains[cd] %@
    // 搜尋name。[cd]不區分大小寫
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format,keyword];
    // predicateWithFormat 只能接收 %@ contains[cd] %%@ 中的%%@
    request.predicate = predicate;
    
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return result;
}



-(NSInteger)count{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    return [sectionInfo numberOfObjects];
}

@end

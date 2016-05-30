//
//  SqliteManager.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/5/30.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

//static FMDatabaseQueue *db;
@interface SqliteManager : NSObject
/** FMDatabaseQueue */
@property (strong, nonatomic) FMDatabaseQueue *queue;

/** 单例 */
+ (instancetype)manager;
@end

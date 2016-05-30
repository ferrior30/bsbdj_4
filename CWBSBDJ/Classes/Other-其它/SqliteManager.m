//
//  SqliteManager.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/5/30.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "SqliteManager.h"

@implementation SqliteManager
+ (instancetype)manager {
    static SqliteManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SqliteManager alloc] init];
    });
    return manager;
}

//- (instancetype)init {
//    @throw @"请调用单例方法+manager";
//}

- (FMDatabaseQueue *)queue {
    if (_queue == nil) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *fillPath = [path stringByAppendingPathComponent:@"topics.sqlite"];
        _queue = [FMDatabaseQueue databaseQueueWithPath:fillPath];
        
        [_queue inDatabase:^(FMDatabase *db) {
            // 0.数据库能否打开
            if (![db open]) { // 0.1不能打开
                CWLog(@"数据库表打不开");
                return ;
            }
            // 0.2 能打开，创建表
            /*
            CREATE TABLE "main"."<table_name>" (
                                                "name" TEXT,
                                                "int" integer NOT NULL,
                                                PRIMARY KEY("int")
                                                );
             */
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS T_TOPIC ('mainKey' integer Primary key, 'id' TEXT, 't' integer, 'type' TEXT, 'a' TEXT, 'topic' TEXT)"];
            [db executeUpdate:sql withArgumentsInArray:nil];
        }];
    }
    return _queue;
}
@end

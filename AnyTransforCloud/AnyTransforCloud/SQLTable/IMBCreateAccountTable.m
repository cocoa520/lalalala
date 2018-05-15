//
//  IMBCreateAccountTable.m
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/16.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBCreateAccountTable.h"
#import "NSString+Category.h"
#import "StringHelper.h"
#import "TempHelper.h"

@implementation IMBCreateAccountTable
@synthesize accountArray = _accountArray;

- (id)initWithPath:(NSString *)savePath {
    self = [super init];
    if (self) {
        if (savePath) {
            _savePath = [savePath retain];
        }else {
            _savePath = [[[TempHelper getAppiMobieConfigPath] stringByAppendingPathComponent:@"cloud"] retain];
        }
        _accountArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)openDB {
    _db = [[FMDatabase databaseWithPath:_savePath] retain];
    BOOL ret = [_db open];
    if (ret) {
        [_db setShouldCacheStatements:NO];
        [_db setTraceExecution:NO];
    }
    return ret;
}

- (void)closeDB {
    if (_db != nil) {
        [_db close];
        [_db release];
        _db = nil;
    }
}

- (BOOL)createAccountTable {
    NSString *createCmd = nil;
    createCmd = @"CREATE TABLE if not exists account (rowid INTEGER PRIMARY KEY AUTOINCREMENT,account_name TEXT,account_password TEXT,login_time INTEGER,is_reminder BOOLEAN)";//sql语句表示account不存在才创建；
    return [_db executeUpdate:createCmd];
}

- (void)insertData:(NSString *)account Password:(NSString *)password LoginTime:(long long)time isReminder:(BOOL)isReminder {
    NSString *insertCmd = [NSString stringWithFormat:@"insert into account (account_name,account_password,login_time,is_reminder) values ('%@','%@','%lld','%d')",account,password,time,isReminder];
    [_db executeUpdate:insertCmd];
}

- (void)createSqlite:(NSString *)account Password:(NSString *)password LoginTime:(long long)time isReminder:(BOOL)isReminder {
    if ([self openDB]) {
        //创建表account（不存在才创建）
        if ([self createAccountTable]) {
            //插入清理结果的数据
            [self insertData:account Password:password LoginTime:time isReminder:isReminder];
        }
        [self closeDB];
    }
}

- (void)updateSqlite:(NSString *)account Password:(NSString *)password LoginTime:(long long)time isReminder:(BOOL)isReminder {
    if ([self openDB]) {
        NSString *updateCmd = [NSString stringWithFormat:@"UPDATE account SET account_password = '%@',login_time = '%lld',is_reminder = '%d' WHERE account_name = '%@'",password,time,isReminder,account];
        [_db executeUpdate:updateCmd];
        [self closeDB];
    }
}

- (void)deleteSqlite:(NSString *)account {
    if ([self openDB]) {
        NSString *deleteCmd = [NSString stringWithFormat:@"DELETE FROM account WHERE account_name = '%@'",account];
        BOOL ret = [_db executeUpdate:deleteCmd];
        if (ret) {
            for (IMBAccountEntity *entity in _accountArray) {
                if ([entity.account isEqualToString:account]) {
                    [_accountArray removeObject:entity];
                    break;
                }
            }
        }
        [self closeDB];
    }
}

- (void)selectAccountDatail {
    [_accountArray removeAllObjects];
    if ([self openDB]) {
        NSString *selectCmd = @"select *from account ORDER BY login_time DESC";
        FMResultSet *rs = [_db executeQuery:selectCmd];
        while ([rs next]) {
            IMBAccountEntity *entity = [[IMBAccountEntity alloc] init];
            if (![rs columnIsNull:@"account_name"]) {
                entity.account = [rs stringForColumn:@"account_name"];
            }
            entity.loginTime = [rs longLongIntForColumn:@"login_time"];
            entity.isReminder = [rs boolForColumn:@"is_reminder"];
            if (entity.isReminder) {
                if (![rs columnIsNull:@"account_password"]) {
                    if (![StringHelper stringIsNilOrEmpty:entity.account]) {
                        NSString *password = [rs stringForColumn:@"account_password"];
                        if (![StringHelper stringIsNilOrEmpty:password]) {
                            NSString *DecStr = [password AES256DecryptWithKey:entity.account];
                            if (![StringHelper stringIsNilOrEmpty:DecStr]) {
                                entity.password = DecStr;
                                [_accountArray addObject:entity];
                            }
                        }else {
                            NSString *deleteCmd = [NSString stringWithFormat:@"DELETE FROM account WHERE rowid = %d",[rs intForColumn:@"rowid"]];
                            [_db executeUpdate:deleteCmd];
                        }
                    }else {
                        NSString *deleteCmd = [NSString stringWithFormat:@"DELETE FROM account WHERE rowid = %d",[rs intForColumn:@"rowid"]];
                        [_db executeUpdate:deleteCmd];
                    }
                }
            }else {
                [_accountArray addObject:entity];
            }
            [entity release];
        }
        [rs close];
        [self closeDB];
    }
}

- (void)dealloc {
    [_accountArray release], _accountArray = nil;
    [_savePath release], _savePath = nil;
    [super dealloc];
}

@end

@implementation IMBAccountEntity
@synthesize account = _account;
@synthesize password = _password;
@synthesize loginTime = _loginTime;
@synthesize isReminder = _isReminder;

- (id)init {
    self = [super init];
    if (self) {
        _account = @"";
        _password = @"";
        _loginTime = 0;
        _isReminder = NO;
    }
    return self;
}


@end

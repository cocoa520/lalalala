//
//  IMBCreateAccountTable.h
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/16.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface IMBCreateAccountTable : NSObject {
    NSString *_savePath;
    FMDatabase *_db;
    NSMutableArray *_accountArray;
}
/**保存的账号数组*/
@property (nonatomic, retain) NSMutableArray *accountArray;

/**
 *  初始化函数
 *
 *  @param savePath 数据库保存路径
 *
 *  @return self
 */
- (id)initWithPath:(NSString *)savePath;

/**
 *  创建数据库
 *
 *  @param account  保存的账号名
 *  @param password 保存的密码
 *  @param time     登录时间
 *  @param isReminder 是否是记住密码
 */
- (void)createSqlite:(NSString *)account Password:(NSString *)password LoginTime:(long long)time isReminder:(BOOL)isReminder;

/**
 *  查询登录过的账号
 */
- (void)selectAccountDatail;

/**
 *  更新数据
 *
 *  @param account  保存的账号名
 *  @param password 需要更新的密码
 *  @param time     需要更新的时间
 *  @param isReminder 是否是记住密码
 */
- (void)updateSqlite:(NSString *)account Password:(NSString *)password LoginTime:(long long)time isReminder:(BOOL)isReminder;

/**
 *  删除数据
 *
 *  @param account 保存的账号名
 */
- (void)deleteSqlite:(NSString *)account;

@end

@interface IMBAccountEntity : NSObject {
    NSString *_account;
    NSString *_password;
    long long _loginTime;
    BOOL _isReminder;
}

@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, assign) long long loginTime;
@property (nonatomic, assign) BOOL isReminder;

@end
//
//  IMBBoxManager.h
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBBaseManager.h"

@interface IMBBoxManager : IMBBaseManager

/**
 *  移动文件或者文件夹
 *
 *  @param newParent            目标目录ID号
 *  @param sourceIDAndName      源目录数组，包含 @{@"id": @{@"name": @"name.jpg", @"type": @YES/@NO}}
 *  @param success              成功回调
 *  @param fail                 失败回调
 */
- (void)moveToNewParent:(NSString *)newParent sourceParent:(NSArray *)parent;
@end

//
//  NSDictionary+Category.h
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Category)
+ (NSDictionary *)dictionaryFromData:(NSData *)data;
- (NSData *)toData;
-(NSMutableDictionary *)mutableDeepCopy;
@end

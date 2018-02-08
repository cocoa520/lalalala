//
//  MessageConversioniOS.h
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//
/**
 此类是实现message数据转换逻辑
 */
#import <Foundation/Foundation.h>
#import "DataConversion.h"
@class IMBAndroid;
@interface MessageConversioniOS : NSObject<DataConversion>
{
    IMBAndroid *_android;
}
@property (nonatomic,assign)IMBAndroid *android;
@end

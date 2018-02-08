//
//  ServiceKeySet.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import <Foundation/Foundation.h>
#import "Service.h"

@class Key;
@class KeyID;

@interface ServiceKeySet : NSObject {
@private
    NSMutableDictionary *                       _serviceKeys;
    NSString *                                  _name;
    NSString *                                  _ksID;
    BOOL                                        _isCompact;
}

- (NSString*)name;
- (NSString*)ksID;
- (BOOL)isCompact;

- (id)initWithServiceKeys:(NSDictionary*)serviceKeys withName:(NSString*)name withKsID:(NSString*)ksID withIsCompact:(BOOL)isCompact;

- (Key*)keyWithServiceEnum:(ServiceEnum)service;
- (Key*)keyWithService:(int)service;
- (Key*)keyWithKeyID:(KeyID*)keyID;

// 保存的是Key的实例对象
- (NSMutableDictionary*)services;
- (NSArray*)keys;

@end

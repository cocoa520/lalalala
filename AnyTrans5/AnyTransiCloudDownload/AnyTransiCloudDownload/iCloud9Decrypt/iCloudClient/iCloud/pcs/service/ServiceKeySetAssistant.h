//
//  ServiceKeySetAssistant.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Key;

@interface ServiceKeySetAssistant : NSObject

+ (NSMutableDictionary*)importPrivateKeys:(NSArray*)keys withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName withUseCompactKeys:(BOOL)useCompactKeys;
+ (NSMutableDictionary*)verifyKeys:(NSArray*)privateKeys withMasterKey:(Key*)masterKey;
+ (NSMutableArray*)untrustedKeys:(NSArray*)privateKeys;
+ (Key*)keyForService:(NSArray*)privateKeys withService:(int)service;
+ (NSMutableArray*)unreferencedKeys:(NSDictionary*)serviceKeyIDs withPrivateKeys:(NSDictionary*)privateKeys;
+ (NSMutableDictionary*)serviceKeys:(NSDictionary*)serviceKeyIDs withPrivateKeys:(NSDictionary*)privateKeys;
+ (NSMutableDictionary*)incongruentKeys:(NSDictionary*)serviceKeys;

@end

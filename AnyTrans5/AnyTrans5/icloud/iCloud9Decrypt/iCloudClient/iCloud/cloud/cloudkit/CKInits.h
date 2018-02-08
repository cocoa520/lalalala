//
//  CKInits.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class CKInit;
@class Account;

@interface CKInits : NSObject

+ (CKInit*)ckInitBackupd:(Account*)account;
+ (CKInit*)ckInit:(Account*)account withBundle:(NSString*)bundle withContainer:(NSString*)container;

@end

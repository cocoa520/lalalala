//
//  Accounts.h
//  
//
//  Created by Pallas on 4/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Account;
@class Auth;

@interface Accounts : NSObject {
@private
}

+ (Account*)accountWithAuth:(Auth*)auth;
+ (Account*)accountWithDictionary:(NSDictionary*)settings;

@end

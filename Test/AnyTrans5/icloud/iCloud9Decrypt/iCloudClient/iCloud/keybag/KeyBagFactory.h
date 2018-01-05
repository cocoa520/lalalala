//
//  KeyBagFactory.h
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class KeyBag;

@interface KeyBagFactory : NSObject

+ (KeyBag*)createWithData:(NSMutableData*)data withPasscode:(NSMutableData*)passcode;
+ (KeyBag*)createWithArray:(NSMutableArray*)list withPassCode:(NSMutableData*)passCode;

@end

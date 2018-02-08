//
//  SecureRandom.h
//  
//
//  Created by iMobie on 7/15/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface SecureRandom : NSObject

- (NSMutableData*)nextBytes:(int)bitCount;

@end

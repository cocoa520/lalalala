//
//  KeyBags.h
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class KeyBag;

@interface KeyBags : NSObject {
    NSMutableDictionary *                       _keyBags;
}

- (id)initWithDictionary:(NSDictionary*)keyBags;
- (id)initWithArray:(NSArray*)keyBags;
- (id)initWithKeybag:(KeyBag*)keyBag,...;

- (KeyBag*)keybag:(NSData*)uuid;
- (NSMutableArray*)getKeyBags;

@end

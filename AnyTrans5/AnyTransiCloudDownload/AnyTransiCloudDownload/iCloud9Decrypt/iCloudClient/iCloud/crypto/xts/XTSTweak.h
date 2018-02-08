//
//  XTSTweak.h
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BlockCipher;
@class KeyParameter;

@interface XTSTweak : NSObject {
@private
    BlockCipher *                       _cipher;
    NSMutableData *                     _tweak;
    Class                               _clazz;
    SEL                                 _selector;
}

+ (NSMutableData*)defaultTweakFunction:(int64_t)tweakValue;

- (id)initWithClazz:(Class)clazz withSelector:(SEL)selector;

- (XTSTweak*)init:(KeyParameter*)key;
- (XTSTweak*)reset:(int64_t)tweakValue;
- (NSMutableData*)value;
- (XTSTweak*)next;

@end

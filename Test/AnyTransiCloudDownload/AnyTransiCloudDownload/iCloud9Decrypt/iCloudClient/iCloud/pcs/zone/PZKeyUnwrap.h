//
//  PZKeyUnwrap.h
//
//
//  Created by JGehry on 8/2/16.
//
//
//  Complete

#import <Foundation/Foundation.h>

@interface PZKeyUnwrap : NSObject {
@private
    NSMutableData *                                 _label;
    int                                             _keyLength;
}

+ (PZKeyUnwrap*)instance;

- (id)initWithLabel:(NSMutableData*)label withKeyLength:(int)keyLength;

- (NSMutableData*)apply:(NSMutableData*)keyDerivationKey withWrappedKey:(NSMutableData*)wrappedKey;

@end

//
//  AeadParameters.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "AeadParameters.h"
#import "KeyParameter.h"

@interface AeadParameters ()

@property (nonatomic, readwrite, retain) NSMutableData *associatedText;
@property (nonatomic, readwrite, retain) NSMutableData *nonce;
@property (nonatomic, readwrite, retain) KeyParameter *key;
@property (nonatomic, readwrite, assign) int macSize;

@end

@implementation AeadParameters 
@synthesize associatedText = _associatedText;
@synthesize nonce = _nonce;
@synthesize key = _key;
@synthesize macSize = _macSize;

/**
 * Base constructor.
 *
 * @param key key to be used by underlying cipher
 * @param macSize macSize in bits
 * @param nonce nonce to be used
 */
- (id)initWithKey:(KeyParameter*)key withMacSize:(int)macSize withNonce:(NSMutableData*)nonce {
    if (self = [self initWithKey:key withMacSize:macSize withNonce:nonce withAssociatedText:nil]) {
        return self;
    } else {
        return nil;
    }
}

/**
 * Base constructor.
 *
 * @param key key to be used by underlying cipher
 * @param macSize macSize in bits
 * @param nonce nonce to be used
 * @param associatedText associated text, if any
 */
- (id)initWithKey:(KeyParameter*)key withMacSize:(int)macSize withNonce:(NSMutableData*)nonce withAssociatedText:(NSMutableData*)associatedText {
    if (self = [super init]) {
        [self setKey:key];
        [self setNonce:nonce];
        [self setMacSize:macSize];
        [self setAssociatedText:associatedText];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setAssociatedText:nil];
    [self setNonce:nil];
    [self setKey:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)getAssociatedText {
    return [self associatedText];
}

- (NSMutableData*)getNonce {
    return [self nonce];
}

@end

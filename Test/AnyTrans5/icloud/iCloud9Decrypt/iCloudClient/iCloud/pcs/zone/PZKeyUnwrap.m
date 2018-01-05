//
//  PZKeyUnwrap.m
//
//
//  Created by JGehry on 8/2/16.
//
//
//  Complete

#import "PZKeyUnwrap.h"
#import "Arrays.h"
#import "Sha256Digest.h"
#import "RFC3394Wrap.h"
#import "NISTKDF.h"
#import "Hex.h"

@interface PZKeyUnwrap ()

@property (nonatomic, readwrite, retain) NSMutableData *label;
@property (nonatomic, assign) int keyLength;

@end

@implementation PZKeyUnwrap
@synthesize label = _label;
@synthesize keyLength = _keyLength;

+ (PZKeyUnwrap*)instance {
    static PZKeyUnwrap *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[PZKeyUnwrap alloc] initWithLabel:[Hex decodeWithString:@"7772617070696E67206B65792077726170206D65"] withKeyLength:0x10];
        }
    }
    return _instance;
}

- (id)initWithLabel:(NSMutableData*)label withKeyLength:(int)keyLength {
    if (self = [super init]) {
        NSMutableData *tmpData = [Arrays copyOfWithData:label withNewLength:(int)[label length]];
        [self setLabel:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        [self setKeyLength:keyLength];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setLabel:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)apply:(NSMutableData*)keyDerivationKey withWrappedKey:(NSMutableData*)wrappedKey {
    Sha256Digest *sha256 = [[Sha256Digest alloc] init];
    NSMutableData *ctrHMac = [NISTKDF ctrHMac:keyDerivationKey withLabelData:[self label] withDigest:sha256 withKeyLengthBytes:self.keyLength];
    //NSLog(@"-- apply() - ctrHMac: 0x%@", [Hex toHexString:ctrHMac]);
    
    NSMutableData *key = [RFC3394Wrap unwrap:ctrHMac withWrappedKey:wrappedKey];
    //NSLog(@"-- apply() - key: 0x:%@", key != nil ? [Hex toHexString:key] : @"nil");
#if !__has_feature(objc_arc)
    if (sha256) [sha256 release]; sha256 = nil;
#endif
    
    return key;
}

@end

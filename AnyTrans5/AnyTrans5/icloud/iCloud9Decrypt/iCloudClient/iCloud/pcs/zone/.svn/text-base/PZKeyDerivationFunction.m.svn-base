//
//  PZKeyDerivationFunction.m
//
//
//  Created by JGehry on 8/2/16.
//
//
//  Complete

#import "PZKeyDerivationFunction.h"
#import "Arrays.h"
#import "NISTKDF.h"
#import "Sha256Digest.h"
#import "Hex.h"

@interface PZKeyDerivationFunction ()

@property (nonatomic, readwrite, retain) Digest *digest;
@property (nonatomic, readwrite, retain) NSMutableData *label;
@property (nonatomic, assign) int keyLength;

@end

@implementation PZKeyDerivationFunction
@synthesize digest = _digest;
@synthesize label = _label;
@synthesize keyLength = _keyLength;

+ (PZKeyDerivationFunction *)instance {
    static PZKeyDerivationFunction *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            Sha256Digest *sha256 = [[Sha256Digest alloc] init];
            _instance = [[PZKeyDerivationFunction alloc] initWithDigest:sha256 withLabel:[Hex decodeWithString:@"656E6372797074696F6E206B6579206B6579206D"] withKeyLength:0x10];
#if !__has_feature(objc_arc)
            if (sha256 != nil) [sha256 release]; sha256 = nil;
#endif
        }
    }
    return _instance;
}

- (id)initWithDigest:(Digest*)digest withLabel:(NSMutableData*)label withKeyLength:(int)keyLength {
    if (self = [super init]) {
        if (digest == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"digestSupplier" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setDigest:digest];
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
    [self setDigest:nil];
    [self setLabel:nil];
    [super dealloc];
#endif
}

- (NSMutableData *)apply:(NSMutableData *)keyDerivationKey {
    return [NISTKDF ctrHMac:keyDerivationKey withLabelData:[self label] withDigest:[self digest] withKeyLengthBytes:[self keyLength]];
}

@end

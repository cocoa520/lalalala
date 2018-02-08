//
//  PZAssistantLight.m
//
//
//  Created by JGehry on 8/2/16.
//
//
//  Complete

#import "PZAssistantLight.h"
#import "Arrays.h"
#import "ECAssistant.h"
#import "ECurves.h"
#import "ECCurvePoint.h"
#import "ECPublicKey.h"
#import "ECPublicKeyImportCompact.h"
#import "ECPrivateKeyEx.h"
#import "Hex.h"
#import "Key.h"
#import "RFC5869KDF.h"
#import "RFC3394Wrap.h"
#import "Sha256Digest.h"

@interface PZAssistantLight ()

@property (nonatomic, readwrite, retain) Digest *digest;
@property (nonatomic, readwrite, retain) NSString *curveName;
@property (nonatomic, readwrite, retain) NSMutableData *info;
@property (nonatomic, assign) int curveFieldLength;
@property (nonatomic, assign) int keyLength;

@end

@implementation PZAssistantLight
@synthesize digest = _digest;
@synthesize curveName = _curveName;
@synthesize info = _info;
@synthesize curveFieldLength = _curveFieldLength;
@synthesize keyLength = _keyLength;

+ (PZAssistantLight*)instance {
    static PZAssistantLight *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            Sha256Digest *sha256 = [[Sha256Digest alloc] init];
            _instance = [[PZAssistantLight alloc] initWithDigest:sha256 withCurveName:[ECurves defaultCurve] withInfo:[Hex decodeWithString:@"4561676C6544616E6365"] withKeyLength:0x10];
#if !__has_feature(objc_arc)
            if (sha256 != nil) [sha256 release]; sha256 = nil;
#endif
        }
    }
    return _instance;
}

- (id)initWithDigest:(Digest*)digest withCurveName:(NSString*)curveName withInfo:(NSMutableData*)info withKeyLength:(int)keyLength {
    if (self = [super init]) {
        if (digest == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"digest" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (curveName == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"curveName" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setDigest:digest];
        [self setCurveName:curveName];
        NSMutableData *tmpData = [Arrays copyOfWithData:info withNewLength:(int)[info length]];
        [self setInfo:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        [self setKeyLength:keyLength];
        self.curveFieldLength = [ECAssistant fieldLengthWithCurveName:curveName];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setDigest:nil];
    [self setCurveName:nil];
    [self setInfo:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)masterKey:(NSMutableData*)protectionInfoData withKeys:(NSMutableArray*)keys {
    if ((SignedByte)(((Byte*)(protectionInfoData.bytes))[0]) != -1) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"not a light object" userInfo:nil];
    }
    
    if (protectionInfoData.length < (self.curveFieldLength + 3)) {
        return nil;
    }
    
    NSMutableData *retData = nil;
    @autoreleasepool {
        NSMutableData *publicKey = [Arrays copyOfRangeWithByteArray:protectionInfoData withFrom:1 withTo:(1 + self.curveFieldLength)];
        NSMutableData *wrappedKey = [Arrays copyOfRangeWithByteArray:protectionInfoData withFrom:(1 + self.curveFieldLength) withTo:((int)(protectionInfoData.length) - 2)];
        id public = [[ECPublicKeyImportCompact instance] importKey:[self curveName] withData:publicKey];
        
        if (public != nil && [public isKindOfClass:[ECPublicKey class]]) {
            retData = [self unwrap:(ECPublicKey*)public withKeys:keys withWrappedKey:wrappedKey];
        }
#if !__has_feature(objc_arc)
        if (publicKey) [publicKey release]; publicKey = nil;
        if (wrappedKey) [wrappedKey release]; wrappedKey = nil;
#endif
        [retData retain];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)unwrap:(ECPublicKey*)otherPublicKey withKeys:(NSMutableArray*)keys withWrappedKey:(NSMutableData*)wrappedKey {
    NSMutableData *retData = nil;
    NSEnumerator *iterator = [keys objectEnumerator];
    Key *key = nil;
    @autoreleasepool {
        while (key = [iterator nextObject]) {
            @try {
                NSMutableData *tmpData = [self unwrap:otherPublicKey withMyPrivateKey:(ECPrivateKeyEx*)[key keyData] withDigest:[self digest] withWrappedKey:wrappedKey];
                if (tmpData != nil) {
                    retData = [tmpData retain];
                    break;
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@", [exception reason]);
            }
        }
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)unwrap:(ECPublicKey*)otherPublicKey withMyPrivateKey:(ECPrivateKeyEx*)myPrivateKey withDigest:(Digest*)digest withWrappedKey:(NSMutableData*)wrappedKey {
    NSMutableData *unwrapped = nil;
    @autoreleasepool {
        NSMutableData *S = [myPrivateKey agreement:otherPublicKey];
        NSMutableData *salt = [[[myPrivateKey publicKey] getPoint] xEncoded];
        Sha256Digest *sha256 = [[Sha256Digest alloc] init];
        NSMutableData *dk = [RFC5869KDF apply:S withSalt:salt withInfo:[self info] withDigest:sha256 withKeyLengthBytes:self.keyLength];
#if !__has_feature(objc_arc)
        if (sha256 != nil) [sha256 release]; sha256 = nil;
#endif
        unwrapped = [RFC3394Wrap unwrap:dk withWrappedKey:wrappedKey];
        [unwrapped retain];
    }
    return (unwrapped ? [unwrapped autorelease] : nil);
}

@end

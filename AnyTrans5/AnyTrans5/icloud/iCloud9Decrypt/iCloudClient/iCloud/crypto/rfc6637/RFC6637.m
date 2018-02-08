//
//  RFC6637.m
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import "RFC6637.h"
#import "ECCurve.h"
#import "CategoryExtend.h"
#import "Wrapper.h"
#import "RFC6637KDF.h"
#import "BigInteger.h"
#import "ECPoint.h"
#import "KeyParameter.h"
#import "ECNamedCurveTable.h"
#import "X9ECParameters.h"
#import "ECPointsCompact.h"
#import "Arrays.h"

@interface RFC6637 ()

@property (nonatomic, readwrite, retain) Wrapper *wrapperFactory;
@property (nonatomic, readwrite, retain) NSString *curveName;
@property (nonatomic, readwrite, assign) int symAlgIDKeyLength;
@property (nonatomic, readwrite, retain) RFC6637KDF *kdf;

@end

@implementation RFC6637
@synthesize wrapperFactory = _wrapperFactory;
@synthesize curveName = _curveName;
@synthesize symAlgIDKeyLength = _symAlgIDKeyLength;
@synthesize kdf = _kdf;

- (id)initWithWrapper:(Wrapper*)wrapperFactory withCurveName:(NSString*)curveName withSymAlgIDKeyLength:(int)symAlgIDKeyLength withKdf:(RFC6637KDF*)kdf {
    if (self = [super init]) {
        [self setWrapperFactory:wrapperFactory];
        [self setCurveName:curveName];
        [self setSymAlgIDKeyLength:symAlgIDKeyLength];
        [self setKdf:kdf];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_wrapperFactory != nil) [_wrapperFactory release]; _wrapperFactory = nil;
    if (_curveName != nil) [_curveName release]; _curveName = nil;
    if (_kdf != nil) [_kdf release]; _kdf = nil;
    [super dealloc];
#endif
}

- (NSMutableData*)unwrap:(NSMutableData*)data withFingerprint:(NSMutableData*)fingerprint withD:(BigInteger*)d {
    NSMutableData *finalize = nil;
    @autoreleasepool {
        @try {
            // TODO write verifcation/ exception handling code.
            DataStream *buffer = [DataStream wrapWithData:data];
            
            int wKeySize = ([buffer getShort] + 7) / 8;
            NSMutableData *wKey = [[NSMutableData alloc] initWithSize:wKeySize];
            [buffer getWithMutableData:wKey];
            
            int wrappedSize = (uint)[buffer get];
            NSMutableData *wrapped = [[NSMutableData alloc] initWithSize:wrappedSize];
            [buffer getWithMutableData:wrapped];
            
            ECPoint *Q = [self decodePoint:wKey];
            
            // ECDH assuming curve has a cofactor of 1
            ECPoint *S = [[Q multiply:d] normalize];
            
            NSMutableData *hash = [[self kdf] apply:S withFingerprint:fingerprint];
            
            NSMutableData *derivedKey = [Arrays copyOfWithData:hash withNewLength:self.symAlgIDKeyLength];
            
            Wrapper *wrapper =  [self wrapperFactory];
            KeyParameter *keyParameter = [[KeyParameter alloc] initWithKey:derivedKey];
            [wrapper init:NO withParameters:keyParameter];
            NSMutableData *unwrap = [wrapper unwrap:wrapped withInOff:0 withLength:(int)(wrapped.length)];
            
            finalize = [[RFC6637 finalize:unwrap] retain];
            
#if !__has_feature(objc_arc)
            if (wKey != nil) [wKey release]; wKey = nil;
            if (wrapped != nil) [wrapped release]; wrapped = nil;
            if (derivedKey != nil) [derivedKey release]; derivedKey = nil;
            if (keyParameter != nil) [keyParameter release]; keyParameter = nil;
#endif
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:[exception reason] userInfo:nil];
        }
    }
    return (finalize ? [finalize autorelease] : nil);
}

- (ECPoint*)decodePoint:(NSMutableData*)data {
    ECCurve *curve = [[ECNamedCurveTable getByName:[self curveName]] curve];
    int compactExportSize = ([curve fieldSize] + 7) / 8;
    
    ECPoint *retPoint = nil;
    @autoreleasepool {
        @try {
            retPoint = (data.length == compactExportSize ? [[ECPointsCompact decodeFPPoint:curve withData:data] retain] : [[curve decodePoint:data] retain]);
        }
        @catch (NSException *exception) {
        }
    }
    return [retPoint autorelease];
}

+ (NSMutableData*)finalize:(NSMutableData*)data {
    // TODO break up method to allow for easier testing
    // data = 1 byte sym_alg_id || decrypted bytes || 2 byte checksum || padding
    // Working backwards...
    int i = (int)(data.length) - 1;
    
    // Verify padding PKCS5
    int paddedBytes = (uint)(((Byte*)(data.bytes))[i]);
    
    if (paddedBytes > (int)(data.length) - 3) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"bad padding length" userInfo:nil];
    }
    
    if (paddedBytes > 0) {
        while (i-- > (int)(data.length) - paddedBytes) {
            if ((uint)(((Byte*)(data.bytes))[i]) != paddedBytes) {
                // TODO choose a more specific exception
                @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"bad padding" userInfo:nil];
            }
        }
    }
    
    // Expected checksum
    int checksum = (uint)(((Byte*)(data.bytes))[i--]);
    checksum += (uint)(((Byte*)(data.bytes))[i]) << 8;
    
    // Checksum decrypted data
    int t = 0;
    while (i-- > 1) {
        t += (uint)(((Byte*)(data.bytes))[i]);
    }
    
    if ((t & 0xFFFF) != checksum) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"bad checksum" userInfo:nil];
    }
    
    // Remove sym_alg_id + padding
    int dataLen = (int)(data.length) - paddedBytes - 3;
    NSMutableData *retData = [[[NSMutableData alloc] initWithSize:dataLen] autorelease];
    [retData copyFromIndex:0 withSource:data withSourceIndex:1 withLength:dataLen];
    return retData;
}

@end

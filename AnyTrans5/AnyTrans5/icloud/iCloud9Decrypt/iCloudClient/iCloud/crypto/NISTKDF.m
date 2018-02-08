//
//  NISTKDF.m
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import "NISTKDF.h"
#import "CategoryExtend.h"
#import "Digest.h"
#import "HMac.h"
#import "KDFCounterBytesGenerator.h"
#import "KDFCounterParameters.h"

@implementation NISTKDF

static int NISTKDF_R = 32;            // counter length in bits

+ (NSMutableData*)ctrHMac:(NSMutableData*)keyDerivationKey withLabelString:(NSString*)labelString withDigest:(Digest*)digest withKeyLengthBytes:(int)keyLengthBytes {
    return [NISTKDF ctrHMac:keyDerivationKey withLabelData:[labelString dataUsingEncoding:NSUTF8StringEncoding] withDigest:digest withKeyLengthBytes:keyLengthBytes];
}

// KDF in Counter Mode with an HMAC PRF
// TODO document exceptions
+ (NSMutableData*)ctrHMac:(NSMutableData*)keyDerivationKey withLabelData:(NSData*)label withDigest:(Digest*)digest withKeyLengthBytes:(int)keyLengthBytes {
    NSMutableData *derivedKey = [[[NSMutableData alloc] initWithSize:keyLengthBytes] autorelease];
    @autoreleasepool {
        @try {
            // fixedInputData = label || 0x00 || dkLen in bits as 4 bytes big endian
            DataStream *buffer = [[DataStream alloc] initWithAllocateSize:((int)(label.length) + 5)];
            [buffer putWithData:label];
            [buffer put:(Byte)0];
            [buffer putInt:(keyLengthBytes * 8)];
            NSMutableData *fixedInputData = [buffer toMutableData];
            
            HMac *hMac = [[HMac alloc] initWithDigest:digest];
            KDFCounterBytesGenerator *generator = [[KDFCounterBytesGenerator alloc] initWithPrf:hMac];
            KDFCounterParameters *kdfcp = [[KDFCounterParameters alloc] initWithKi:keyDerivationKey withFixedInputDataCounterSuffix:fixedInputData withR:NISTKDF_R];
            [generator init:kdfcp];
            [generator generateBytes:derivedKey withOutOff:0 withLength:(int)(derivedKey.length)];
#if !__has_feature(objc_arc)
            if (buffer != nil) [buffer release]; buffer = nil;
            if (hMac != nil) [hMac release]; hMac = nil;
            if (generator != nil) [generator release]; generator = nil;
            if (kdfcp != nil) [kdfcp release]; kdfcp = nil;
#endif
        }
        @catch (NSException *exception) {
        }
    }
    return derivedKey;
}

@end

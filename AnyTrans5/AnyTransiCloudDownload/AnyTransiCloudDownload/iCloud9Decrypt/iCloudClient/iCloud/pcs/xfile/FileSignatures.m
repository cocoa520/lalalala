//
//  FileSignatures.m
//
//
//  Created by JGehry on 8/8/16.
//
//
//  Complete

#import "FileSignatures.h"
#import "Arrays.h"
#import "CategoryExtend.h"
#import "Digest.h"
#import "DigestInputStream.h"
#import "FileDigestA.h"
#import "Hex.h"
#import "Sha1Digest.h"

@implementation FileSignatures

+ (FileDigestA*)ONE {
    return [[[FileDigestA alloc] init] autorelease];
}

+ (NSMutableData *)SALT_A {
    static NSMutableData *_SALT_A = nil;
    @synchronized(self) {
        if (!_SALT_A) {
            _SALT_A = [[Hex decodeWithString:@"636F6D2E6170706C652E58617474724F626A65637453616C7400636F6D2E6170706C652E446174614F626A65637453616C7400"] retain];
        }
    }
    return _SALT_A;
}

+ (DigestInputStream*)like:(Stream*)inputStream fileSignature:(NSMutableData*)fileSignature {
    NSNumber *optional = [self type:fileSignature];
    if (optional) {
        return [self of:inputStream type:(Type)[optional intValue]];
    } else {
        return nil;
    }
}

+ (DigestInputStream*)of:(Stream*)inputStream type:(Type)type {
    switch (type) {
        case A: {
            return [self typeA:inputStream];
        }
        default: {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"bad type: %d", type] userInfo:nil];
            break;
        }
    }
}

+ (NSNumber*)type:(NSMutableData*)fileSignature {
    if ([fileSignature length] == 0) {
        return nil;
    }
    switch ((((Byte *)[fileSignature bytes])[0]) & 0x7F) {
        case 0x01:
        case 0x02:
        case 0x0B: {
            return ((int)[fileSignature length] == 21) ? @(A): nil;
        }
        default: {
            return nil;
            break;
        }
    }
}

+ (FileDigestA*)typeWithFileSignature:(NSMutableData*)fileSignature {
    if ([fileSignature length] == 0) {
        return nil;
    }
    switch ((((Byte *)[fileSignature bytes])[0]) & 0x7F) {
        case 0x01:
        case 0x02:
        case 0x0B: {
            return ((int)[fileSignature length] == 21) ? [FileSignatures ONE]: nil;
        }
        default: {
            return nil;
            break;
        }
    }
}

+ (BOOL)compare:(DigestInputStream*)digestInputStream fileSignature:(NSMutableData*)fileSignature {
    NSMutableData *output = [self output:digestInputStream];
    NSData *aData = [Arrays copyOfRangeWithByteArray:output withFrom:0 withTo:(int)[output length]];
    NSData *bData= [Arrays copyOfRangeWithByteArray:fileSignature withFrom:1 withTo:(int)[fileSignature length]];
    BOOL equals = [Arrays areEqualWithByteArray:aData withB:bData];
#if !__has_feature(objc_arc)
    if (aData) [aData release]; aData = nil;
    if (bData) [bData release]; bData = nil;
#endif
    return equals;
}

+ (NSMutableData*)output:(DigestInputStream*)digestInputStream {
    Digest *digest = [digestInputStream getDigest];
    NSMutableData *outBytes = [[[NSMutableData alloc] initWithSize:[digest getDigestSize]] autorelease];
    [digest doFinal:outBytes withOutOff:0];
    return outBytes;
}

+ (DigestInputStream*)typeA:(Stream*)inputStream {
    Digest *digest = [[Sha1Digest alloc] init];
    [digest blockUpdate:[self SALT_A] withInOff:0 withLength:(int)([self SALT_A].length)];
    DigestInputStream *retStream = [[[DigestInputStream alloc] initWithStream:inputStream digest:digest] autorelease];
#if !__has_feature(objc_arc)
    if (digest) [digest release]; digest = nil;
#endif
    return retStream;
}

@end

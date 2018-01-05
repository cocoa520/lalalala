//
//  ASN1Dump.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Dump.h"
#import "ASN1Encodable.h"
#import "ASN1Set.h"
#import "ASN1Sequence.h"
#import "ASN1OctetString.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Boolean.h"
#import "ASN1Integer.h"
#import "ASN1UTCTime.h"
#import "ASN1GeneralizedTime.h"
#import "ASN1Enumerated.h"
#import "BERSequence.h"
#import "BERTaggedObject.h"
#import "BERSet.h"
#import "BEROctetString.h"
#import "BERApplicationSpecific.h"
#import "DERSequence.h"
#import "DERNull.h"
#import "DERBitString.h"
#import "DERIA5String.h"
#import "DERUTF8String.h"
#import "DERPrintableString.h"
#import "DERVisibleString.h"
#import "DERBMPString.h"
#import "DERT61String.h"
#import "DERGraphicString.h"
#import "DERVideotexString.h"
#import "DERApplicationSpecific.h"
#import "DERExternal.h"
#import "StringsEx.h"
#import "Hex.h"

@implementation ASN1Dump

+ (NSString *)TAB {
    static NSString *_TAB = nil;
    @synchronized(self) {
        if (!_TAB) {
            _TAB = [[NSString alloc] initWithString:@"    "];
        }
    }
    return _TAB;
}

+ (int)SAMPLE_SIZE {
    static int _SAMPLE_SIZE = 0;
    @synchronized(self) {
        if (!_SAMPLE_SIZE) {
            _SAMPLE_SIZE = 32;
        }
    }
    return _SAMPLE_SIZE;
}

+ (void)_dumpAsString:(NSString *)paramString paramBoolean:(BOOL)paramBoolean paramASN1Primitive:(ASN1Primitive *)paramASN1Primitive paramStringBuffer:(NSMutableString *)paramStringBuffer {
    NSString *str = nil;
    id localObject1;
    id localObject2;
    id localObject3;
    if ([paramASN1Primitive isKindOfClass:[ASN1Sequence class]]) {
        localObject1 = [((ASN1Sequence *)paramASN1Primitive) getObjects];
        localObject2 = [NSString stringWithFormat:@"%@    ", paramString];
        [paramStringBuffer appendString:paramString];
        if ([paramASN1Primitive isKindOfClass:[BERSequence class]]) {
            [paramStringBuffer appendString:@"BER Sequence"];
        }else if ([paramASN1Primitive isKindOfClass:[DERSequence class]]) {
            [paramStringBuffer appendString:@"DER Sequence"];
        }else {
            [paramStringBuffer appendString:@"Sequence"];
        }
        [paramStringBuffer appendString:str];
        while (localObject3 = [((NSEnumerator *)localObject1) nextObject]) {
            if ((!localObject3) || ([localObject3 isEqual:[DERNull INSTANCE]])) {
                [paramStringBuffer appendString:(NSString *)localObject2];
                [paramStringBuffer appendString:@"NULL"];
                [paramStringBuffer appendString:str];
            }else if ([localObject3 isKindOfClass:[ASN1Primitive class]]) {
                [self _dumpAsString:(NSString *)localObject2 paramBoolean:paramBoolean paramASN1Primitive:(ASN1Primitive *)localObject3 paramStringBuffer:paramStringBuffer];
            }else {
                [self _dumpAsString:(NSString *)localObject2 paramBoolean:paramBoolean paramASN1Primitive:[(ASN1Encodable *)localObject3 toASN1Primitive] paramStringBuffer:paramStringBuffer];
            }
        }
    }else if ([paramASN1Primitive isKindOfClass:[ASN1TaggedObject class]]) {
        localObject1 = [NSString stringWithFormat:@"%@    ", paramString];
        [paramStringBuffer appendString:paramString];
        if ([paramASN1Primitive isKindOfClass:[BERTaggedObject class]]) {
            [paramStringBuffer appendString:@"BER Tagged ["];
        }else {
            [paramStringBuffer appendString:@"Tagged ["];
        }
        localObject2 = (ASN1TaggedObject *)paramASN1Primitive;
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%d", [((ASN1TaggedObject *)localObject2) getTagNo]]];
        [paramStringBuffer appendString:@"]"];
        if (![((ASN1TaggedObject *)localObject2) isExplicit]) {
            [paramStringBuffer appendString:@" IMPLICIT "];
        }
        [paramStringBuffer appendString:str];
        if ([((ASN1TaggedObject *)localObject2) isEmpty]) {
            [paramStringBuffer appendString:(NSString *)localObject1];
            [paramStringBuffer appendString:@"EMPTY"];
            [paramStringBuffer appendString:str];
        }else {
            [self _dumpAsString:(NSString *)localObject1 paramBoolean:paramBoolean paramASN1Primitive:[((ASN1TaggedObject *)localObject2) getObject] paramStringBuffer:paramStringBuffer];
        }
    }else if ([paramASN1Primitive isKindOfClass:[ASN1Set class]]) {
        localObject1 = [((ASN1Set *)paramASN1Primitive) getObjects];
        localObject2 = [NSString stringWithFormat:@"%@    ", paramString];
        [paramStringBuffer appendString:paramString];
        if ([paramASN1Primitive isKindOfClass:[BERSet class]]) {
            [paramStringBuffer appendString:@"BER Set"];
        }else {
            [paramStringBuffer appendString:@"DER Set"];
        }
        [paramStringBuffer appendString:str];
        while (localObject3 = [((NSEnumerator *)localObject1) nextObject]) {
            if (!localObject3) {
                [paramStringBuffer appendString:(NSString *)localObject2];
                [paramStringBuffer appendString:@"NULL"];
                [paramStringBuffer appendString:str];
            }else if ([localObject3 isKindOfClass:[ASN1Primitive class]]) {
                [self _dumpAsString:(NSString *)localObject2 paramBoolean:paramBoolean paramASN1Primitive:(ASN1Primitive *)localObject3 paramStringBuffer:paramStringBuffer];
            }else {
                [self _dumpAsString:(NSString *)localObject2 paramBoolean:paramBoolean paramASN1Primitive:[((ASN1Encodable *)localObject3) toASN1Primitive] paramStringBuffer:paramStringBuffer];
            }
        }
    }else if ([paramASN1Primitive isKindOfClass:[ASN1OctetString class]]) {
        localObject1 = (ASN1OctetString *)paramASN1Primitive;
        if ([paramASN1Primitive isKindOfClass:[BEROctetString class]]) {
            [paramStringBuffer appendString:[NSString stringWithFormat:@"%@BER Constructed Octet String[%ud] ", paramString, [[((ASN1OctetString *)localObject1) getOctets] length]]];
        }else {
            [paramStringBuffer appendString:[NSString stringWithFormat:@"%@DER Octet String[%ud] ", paramString, [[((ASN1OctetString *)localObject1) getOctets] length]]];
        }
        if (paramBoolean) {
            [paramStringBuffer appendString:[self dumpBinaryDataAsString:paramString paramArrayOfByte:[((ASN1OctetString *)localObject1) getOctets]]];
        }else {
            [paramStringBuffer appendString:str];
        }
    }else if ([paramASN1Primitive isKindOfClass:[ASN1ObjectIdentifier class]]) {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@ObjectIdentifier(%@)%@", paramString, [((ASN1ObjectIdentifier *)paramASN1Primitive) getId], str]];
    }else if ([paramASN1Primitive isKindOfClass:[ASN1Boolean class]]) {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@Boolean(%d)%@", paramString, [((ASN1Boolean *)paramASN1Primitive) isTrue], str]];
    }else if ([paramASN1Primitive isKindOfClass:[ASN1Integer class]]) {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@Integer(%@)%@", paramString, [((ASN1Integer *)paramASN1Primitive) getValue], str]];
    }else if ([paramASN1Primitive isKindOfClass:[DERBitString class]]) {
        localObject1 = (DERBitString *)paramASN1Primitive;
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@DER Bit String[%ud, %d] ", paramString, [[((DERBitString *)localObject1) getBytes] length], [((DERBitString *)localObject1) getPadBits]]];
        if (paramBoolean) {
            [paramStringBuffer appendString:[self dumpBinaryDataAsString:paramString paramArrayOfByte:[((DERBitString *)localObject1) getBytes]]];
        }else {
            [paramStringBuffer appendString:str];
        }
    }else if ([paramASN1Primitive isKindOfClass:[DERIA5String class]]) {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@IA5String(%@) %@", paramString, [((DERIA5String *)paramASN1Primitive) getString], str]];
    }else if ([paramASN1Primitive isKindOfClass:[DERUTF8String class]]) {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@UTF8String(%@) %@", paramString, [((DERUTF8String *)paramASN1Primitive) getString], str]];
    }else if ([paramASN1Primitive isKindOfClass:[DERPrintableString class]]) {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@PrintableString(%@) %@", paramString, [((DERPrintableString *)paramASN1Primitive) getString], str]];
    }else if ([paramASN1Primitive isKindOfClass:[DERVisibleString class]]) {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@VisibleString(%@) %@", paramString, [((DERVisibleString *)paramASN1Primitive) getString], str]];
    }else if ([paramASN1Primitive isKindOfClass:[DERBMPString class]]) {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@BMPString(%@) %@", paramString, [((DERBMPString *)paramASN1Primitive) getString], str]];
    }else if ([paramASN1Primitive isKindOfClass:[DERT61String class]]) {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@T61String(%@) %@", paramString, [((DERT61String *)paramASN1Primitive) getString], str]];
    }else if ([paramASN1Primitive isKindOfClass:[DERGraphicString class]]) {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@GraphicString(%@) %@", paramString, [((DERGraphicString *)paramASN1Primitive) getString], str]];
    }else if ([paramASN1Primitive isKindOfClass:[DERVideotexString class]]) {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@VideotexString(%@) %@", paramString, [((DERVideotexString *)paramASN1Primitive) getString], str]];
    }else if ([paramASN1Primitive isKindOfClass:[ASN1UTCTime class]]) {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@UTCTime(%@) %@", paramString, [((ASN1UTCTime *)paramASN1Primitive) getTime], str]];
    }else if ([paramASN1Primitive isKindOfClass:[ASN1GeneralizedTime class]]) {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@GeneralizedTime(%@) %@", paramString, [((ASN1GeneralizedTime *)paramASN1Primitive) getTime], str]];
    }else if ([paramASN1Primitive isKindOfClass:[BERApplicationSpecific class]]) {
        [paramStringBuffer appendString:[self outputApplicationSpecific:@"BER" paramString2:paramString paramBoolean:paramBoolean paramASN1Primitive:paramASN1Primitive paramString3:str]];
    }else if ([paramASN1Primitive isKindOfClass:[DERApplicationSpecific class]]) {
        [paramStringBuffer appendString:[self outputApplicationSpecific:@"DER" paramString2:paramString paramBoolean:paramBoolean paramASN1Primitive:paramASN1Primitive paramString3:str]];
    }else if ([paramASN1Primitive isKindOfClass:[ASN1Enumerated class]]) {
        localObject1 = (ASN1Enumerated *)paramASN1Primitive;
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@DER Enumerated(%@)%@", paramString, [((ASN1Enumerated *)localObject1) getValue], str]];
    }else if ([paramASN1Primitive isKindOfClass:[DERExternal class]]) {
        localObject1 = (DERExternal *)paramASN1Primitive;
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@External %@", paramString, str]];
        localObject2 = [NSString stringWithFormat:@"%@    ", paramString];
        if ([((DERExternal *)localObject1) getDirectReference]) {
            [paramStringBuffer appendString:[NSString stringWithFormat:@"%@Direct Reference: %@%@", (NSString *)localObject2, [[((DERExternal *)localObject1) getDirectReference] getId], str]];
        }
        if ([((DERExternal *)localObject1) getIndirectReference]) {
            [paramStringBuffer appendString:[NSString stringWithFormat:@"%@Indirect Reference: %@%@", (NSString *)localObject2, [[((DERExternal *)localObject1) getIndirectReference] toString], str]];
        }
        if ([((DERExternal *)localObject1) getDataValueDescriptor]) {
            [self _dumpAsString:(NSString *)localObject2 paramBoolean:paramBoolean paramASN1Primitive:[((DERExternal *)localObject1) getDataValueDescriptor] paramStringBuffer:paramStringBuffer];
        }
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@Encoding: %d%@", (NSString *)localObject2, [((DERExternal *)localObject1) getEncoding], str]];
        [self _dumpAsString:(NSString *)localObject2 paramBoolean:paramBoolean paramASN1Primitive:[((DERExternal *)localObject1) getExternalContent] paramStringBuffer:paramStringBuffer];
    }else {
        [paramStringBuffer appendString:[NSString stringWithFormat:@"%@%@%@", paramString, paramASN1Primitive, str]];
    }
}

+ (NSString *)outputApplicationSpecific:(NSString *)paramString1 paramString2:(NSString *)paramString2 paramBoolean:(BOOL)paramBoolean paramASN1Primitive:(ASN1Primitive *)paramASN1Primitive paramString3:(NSString *)paramString3 {
    ASN1ApplicationSpecific *localASN1ApplicationSpecific = [ASN1ApplicationSpecific getInstance:paramASN1Primitive];
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] init] autorelease];
    if ([localASN1ApplicationSpecific isConstructed]) {
        @try {
            ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:[localASN1ApplicationSpecific getObject:16]];
            [localStringBuffer appendString:[NSString stringWithFormat:@"%@%@ ApplicationSpecific[%d]%@", paramString2, paramString1, [localASN1ApplicationSpecific getApplicationTag], paramString3]];
            NSEnumerator *localEnumeration = [localASN1Sequence getObjects];
            ASN1Primitive *primitive = nil;
            while (primitive = [localEnumeration nextObject]) {
                [self _dumpAsString:[NSString stringWithFormat:@"%@    ", paramString2] paramBoolean:paramBoolean paramASN1Primitive:primitive paramStringBuffer:localStringBuffer];
            }
        }
        @catch (NSException *exception) {
            [localStringBuffer appendString:exception.description];
        }
        return [NSString stringWithFormat:@"%@", localStringBuffer.description];
    }
    return [NSString stringWithFormat:@"%@%@ ApplicationSpecific[%d] (%@)%@", paramString2, paramString1, [localASN1ApplicationSpecific getApplicationTag], [StringsEx fromByteArray:[Hex decodeWithByteArray:[localASN1ApplicationSpecific getContents]]], paramString3];
}

+ (NSString *)dumpAsString:(id)paramObject {
    return [self dumpAsString:paramObject paramBoolean:false];
}

+ (NSString *)dumpAsString:(id)paramObject paramBoolean:(BOOL)paramBoolean {
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] init] autorelease];
    if ([paramObject isKindOfClass:[ASN1Primitive class]]) {
        [self _dumpAsString:@"" paramBoolean:paramBoolean paramASN1Primitive:(ASN1Primitive *)paramObject paramStringBuffer:localStringBuffer];
    }else if ([paramObject isKindOfClass:[ASN1Encodable class]]) {
        [self _dumpAsString:@"" paramBoolean:paramBoolean paramASN1Primitive:[((ASN1Encodable *)paramObject) toASN1Primitive] paramStringBuffer:localStringBuffer];
    }else {
        return [NSString stringWithFormat:@"unknown object type %@", [paramObject toString]];
    }
    return [NSString stringWithFormat:@"%@", localStringBuffer.description];
}

+ (NSString *)dumpBinaryDataAsString:(NSString *)paramString paramArrayOfByte:(NSMutableData *)paramArrayOfByte {
    NSString *str = nil;
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] init] autorelease];
    paramString = [NSString stringWithFormat:@"%@    ", paramString];
    [localStringBuffer appendString:str];
    for (int i = 0; i < paramArrayOfByte.length; i += 32) {
        if (paramArrayOfByte.length - i > 32) {
            [localStringBuffer appendString:paramString];
            NSString *strss = [[NSString alloc] initWithData:[Hex encode:paramArrayOfByte withOff:i withLength:32] encoding:NSUTF8StringEncoding];
            [localStringBuffer appendString:strss];
            [localStringBuffer appendString:@"    "];
            [localStringBuffer appendString:[self calculateAscString:paramArrayOfByte paramInt1:i paramInt2:32]];
            [localStringBuffer appendString:str];
#if !__has_feature(objc_arc)
    if (strss) [strss release]; strss = nil;
#endif
        }else {
            [localStringBuffer appendString:paramString];
            NSString *strss = [[NSString alloc] initWithData:[Hex encode:paramArrayOfByte withOff:i withLength:((int)[paramArrayOfByte length] - i)] encoding:NSUTF8StringEncoding];
            [localStringBuffer appendString:strss];
            for (int j = (int)paramArrayOfByte.length - i; j != 32; j++) {
                [localStringBuffer appendString:@"  "];
            }
            [localStringBuffer appendString:@"    "];
            [localStringBuffer appendString:[self calculateAscString:paramArrayOfByte paramInt1:i paramInt2:(int)paramArrayOfByte.length - i]];
            [localStringBuffer appendString:str];
#if !__has_feature(objc_arc)
            if (strss) [strss release]; strss = nil;
#endif
        }
    }
    return [NSString stringWithFormat:@"%@", localStringBuffer.description];
}

+ (NSString *)calculateAscString:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2 {
    NSMutableString *localStringBuffer = [[NSMutableString alloc] init];
    for (int i = paramInt1; i != paramInt1 + paramInt2; i++) {
        if ((((Byte *)[paramArrayOfByte bytes])[i] >= 32) && (((Byte *)[paramArrayOfByte bytes])[i] <= 126)) {
            [localStringBuffer appendString:[NSString stringWithFormat:@"%c", ((Byte *)[paramArrayOfByte bytes])[i]]];
        }
    }
    NSString *returnStr = [NSString stringWithFormat:@"%@", localStringBuffer.description];
#if !__has_feature(objc_arc)
    if (localStringBuffer) [localStringBuffer release]; localStringBuffer = nil;
#endif
    return returnStr;
}

@end

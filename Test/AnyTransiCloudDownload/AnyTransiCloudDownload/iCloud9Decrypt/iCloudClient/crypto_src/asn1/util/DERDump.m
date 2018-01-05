//
//  DERDump.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERDump.h"

@implementation DERDump

+ (NSString *)dumpAsStringParamASN1Primitive:(ASN1Primitive *)paramASN1Primitive {
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] init] autorelease];
    [self _dumpAsString:@"" paramBoolean:false paramASN1Primitive:paramASN1Primitive paramStringBuffer:localStringBuffer];
    return [NSString stringWithFormat:@"%@", localStringBuffer.description];
}

+ (NSString *)dumpAsStringParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] init] autorelease];
    [self _dumpAsString:@"" paramBoolean:false paramASN1Primitive:[paramASN1Encodable toASN1Primitive] paramStringBuffer:localStringBuffer];
    return [NSString stringWithFormat:@"%@", localStringBuffer.description];
}

@end

//
//  DEROutputStream.m
//  crypto
//
//  Created by JGehry on 5/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DEROutputStream.h"

@implementation DEROutputStream

- (instancetype)initDERParamOutputStream:(Stream *)paramOutputStream
{
    if (self = [super initASN1OutputStream:paramOutputStream]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)writeObject:(ASN1Encodable *)paramASN1Encodable {
    if (paramASN1Encodable) {
        [[[paramASN1Encodable toASN1Primitive] toDERObject] encode:self];
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"null object detected" userInfo:nil];
    }
}

- (ASN1OutputStream *)getDERSubStream {
    return self;
}

- (ASN1OutputStream *)getDLSubStream {
    return self;
}

@end

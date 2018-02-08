//
//  DLOutputStream.m
//  crypto
//
//  Created by JGehry on 5/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DLOutputStream.h"

@implementation DLOutputStream

- (instancetype)initDLParamOutputStream:(Stream *)paramOutputStream
{
    self = [super init];
    if (self) {
        [super initASN1OutputStream:paramOutputStream];
    }
    return self;
}

- (void)writeObject:(ASN1Encodable *)paramASN1Encodable {
    if (paramASN1Encodable) {
        [[[paramASN1Encodable toASN1Primitive] toDLObject] encode:self];
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"null object detected" userInfo:nil];
    }
}

@end

//
//  CRLNumber.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CRLNumber.h"
#import "ASN1Integer.h"

@interface CRLNumber ()

@property (nonatomic, readwrite, retain) BigInteger *number;

@end

@implementation CRLNumber
@synthesize number = _number;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_number) {
        [_number release];
        _number = nil;
    }
    [super dealloc];
#endif
}

+ (CRLNumber *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CRLNumber class]]) {
        return (CRLNumber *)paramObject;
    }
    if (paramObject) {
        return [[[CRLNumber alloc] initParamBigInteger:[[ASN1Integer getInstance:paramObject] getValue]] autorelease];
    }
    return nil;
}

- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        self.number = paramBigInteger;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BigInteger *)getCRLNumber {
    return self.number;
}

- (ASN1Primitive *)toASN1Primitive {
    return [[[ASN1Integer alloc] initBI:self.number] autorelease];
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"CRLNumber: %@", [self getCRLNumber]];
}

@end

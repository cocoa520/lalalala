//
//  CompleteRevocationRefs.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CompleteRevocationRefs.h"
#import "DERSequence.h"
#import "CrlOcspRef.h"

@interface CompleteRevocationRefs ()

@property (nonatomic, readwrite, retain) ASN1Sequence *crlOcspRefs;

@end

@implementation CompleteRevocationRefs
@synthesize crlOcspRefs = _crlOcspRefs;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_crlOcspRefs) {
        [_crlOcspRefs release];
        _crlOcspRefs = nil;
    }
    [super dealloc];
#endif
}

+ (CompleteRevocationRefs *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CompleteRevocationRefs class]]) {
        return (CompleteRevocationRefs *)paramObject;
    }
    if (paramObject) {
        return [[[CompleteRevocationRefs alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            [CrlOcspRef getInstance:localObject];
        }
        self.crlOcspRefs = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfCrlOcspRef:(NSMutableArray *)paramArrayOfCrlOcspRef
{
    if (self = [super init]) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:paramArrayOfCrlOcspRef];
        self.crlOcspRefs = sequence;
#if !__has_feature(objc_arc)
    if (sequence) [sequence release]; sequence = nil;
#endif
        
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableArray *)getCrlOcspRefs {
    NSMutableArray *arrayOfCrlOcspRef = [[[NSMutableArray alloc] initWithSize:(int)[self.crlOcspRefs size]] autorelease];
    for (int i = 0; i < arrayOfCrlOcspRef.count; i++) {
        arrayOfCrlOcspRef[i] = [CrlOcspRef getInstance:[self.crlOcspRefs getObjectAt:i]];
    }
    return arrayOfCrlOcspRef;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.crlOcspRefs;
}

@end

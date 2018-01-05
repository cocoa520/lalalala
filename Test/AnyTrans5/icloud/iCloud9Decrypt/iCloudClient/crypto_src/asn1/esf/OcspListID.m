//
//  OcspListID.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OcspListID.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "OcspResponsesID.h"

@interface OcspListID ()

@property (nonatomic, readwrite, retain) ASN1Sequence *ocspResponses;

@end

@implementation OcspListID
@synthesize ocspResponses = _ocspResponses;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_ocspResponses) {
        [_ocspResponses release];
        _ocspResponses = nil;
    }
    [super dealloc];
#endif
}

+ (OcspListID *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OcspListID class]]) {
        return (OcspListID *)paramObject;
    }
    if (paramObject) {
        return [[[OcspListID alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        if ([paramASN1Sequence size] != 1) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.ocspResponses = (ASN1Sequence *)[paramASN1Sequence getObjectAt:0];
        NSEnumerator *localEnumeration = [self.ocspResponses getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            [OcspResponsesID getInstance:localObject];
        }
    }
    return self;
}

- (instancetype)initParamArrayOfOcspResponsesID:(NSMutableArray *)paramArrayOfOcspResponsesID
{
    self = [super init];
    if (self) {
        self.ocspResponses = [[[DERSequence alloc] initDERparamArrayOfASN1Encodable:paramArrayOfOcspResponsesID] autorelease];
    }
    return self;
}

- (NSMutableArray *)getOcspResponses {
    NSMutableArray *arrayOfOcspResponsesID = [[[NSMutableArray alloc] initWithSize:(int)[self.ocspResponses size]] autorelease];
    for (int i = 0; i < arrayOfOcspResponsesID.count; i++) {
        arrayOfOcspResponsesID[i] = [OcspResponsesID getInstance:[self.ocspResponses getObjectAt:i]];
    }
    return arrayOfOcspResponsesID;
}

- (ASN1Primitive *)toASN1Primitive {
    return [[[DERSequence alloc] initDERParamASN1Encodable:self.ocspResponses] autorelease];
}

@end

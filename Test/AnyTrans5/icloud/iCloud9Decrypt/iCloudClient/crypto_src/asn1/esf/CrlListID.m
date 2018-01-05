//
//  CrlListID.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CrlListID.h"
#import "CrlValidatedID.h"
#import "DERSequence.h"

@interface CrlListID ()

@property (nonatomic, readwrite, retain) ASN1Sequence *crls;

@end

@implementation CrlListID
@synthesize crls = _crls;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_crls) {
        [_crls release];
        _crls = nil;
    }
    [super dealloc];
#endif
}

+ (CrlListID *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CrlListID class]]) {
        return (CrlListID *)paramObject;
    }
    if (paramObject) {
        return [[[CrlListID alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.crls = (ASN1Sequence *)[paramASN1Sequence getObjectAt:0];
        NSEnumerator *localEnumeration = [self.crls getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            [CrlValidatedID getInstance:localObject];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfCrlValidatedID:(NSMutableArray *)paramArrayOfCrlValidatedID
{
    if (self = [super init]) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:paramArrayOfCrlValidatedID];
        self.crls = sequence;
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

- (NSMutableArray *)getCrls {
    NSMutableArray *arrayOfCrlValidatedID = [[[NSMutableArray alloc] initWithSize:(int)[self.crls size]] autorelease];
    for (int i = 0; i < arrayOfCrlValidatedID.count; i++) {
        arrayOfCrlValidatedID[i] = [CrlValidatedID getInstance:[self.crls getObjectAt:i]];
    }
    return arrayOfCrlValidatedID;
}

- (ASN1Primitive *)toASN1Primitive {
    return [[[DERSequence alloc] initDERParamASN1Encodable:self.crls] autorelease];
}

@end

//
//  MacData.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DigestInfo.h"
#import "BigInteger.h"

@interface MacData : ASN1Object {
    DigestInfo *_digInfo;
    NSMutableData *_salt;
    BigInteger *_iterationCount;
}

@property (nonatomic, readwrite, retain) DigestInfo *digInfo;
@property (nonatomic, readwrite, retain) NSMutableData *salt;
@property (nonatomic, readwrite, retain) BigInteger *iterationCount;

+ (MacData *)getInstance:(id)paramObject;
- (instancetype)initParamDigestInfo:(DigestInfo *)paramDigestInfo paramArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt;
- (DigestInfo *)getMac;
- (NSMutableData *)getSalt;
- (BigInteger *)getIterationCount;
- (ASN1Primitive *)toASN1Primitive;

@end

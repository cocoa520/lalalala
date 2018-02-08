//
//  CscaMasterList.h
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"

@interface CscaMasterList : ASN1Object {
@private
    ASN1Integer *_version;
    NSMutableArray *_certList;
}

+ (CscaMasterList *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfCertificate:(NSMutableArray *)paramArrayOfCertificate;
- (int)getVersion;
- (NSMutableArray *)getCertStructs;
- (ASN1Primitive *)toASN1Primitive;

@end

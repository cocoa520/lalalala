//
//  LDSSecurityObject.h
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ICAOObjectIdentifiers.h"
#import "ASN1Integer.h"
#import "AlgorithmIdentifier.h"
#import "LDSVersionInfo.h"

@interface LDSSecurityObject : ICAOObjectIdentifiers {
@private
    ASN1Integer *_version;
    AlgorithmIdentifier *_digestAlgorithmIdentifier;
    NSMutableArray *_datagroupHash;
    LDSVersionInfo *_versionInfo;
}

+ (LDSSecurityObject *)getInstance:(id)paramObject;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfDataGroupHash:(NSMutableArray *)paramArrayOfDataGroupHash;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfDataGroupHash:(NSMutableArray *)paramArrayOfDataGroupHash paramLDSVersionInfo:(LDSVersionInfo *)paramLDSVersionInfo;
- (int)getVersion;
- (AlgorithmIdentifier *)getDigestAlgorithmIdentifier;
- (NSMutableArray *)getDatagroupHash;
- (LDSVersionInfo *)getVersionInfo;
- (ASN1Primitive *)toASN1Primitive;

@end

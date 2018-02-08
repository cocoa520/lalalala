//
//  DVCSErrorNotice.h
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "PKIStatusInfo.h"
#import "GeneralName.h"

@interface DVCSErrorNotice : ASN1Object {
@private
    PKIStatusInfo *_transactionStatus;
    GeneralName *_transactionIdentifier;
}

+ (DVCSErrorNotice *)getInstance:(id)paramObject;
+ (DVCSErrorNotice *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo;
- (instancetype)initParamPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo paramGeneralName:(GeneralName *)paramGeneralName;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;
- (PKIStatusInfo *)getTransactionStatus;
- (GeneralName *)getTransactionIdentifier;

@end

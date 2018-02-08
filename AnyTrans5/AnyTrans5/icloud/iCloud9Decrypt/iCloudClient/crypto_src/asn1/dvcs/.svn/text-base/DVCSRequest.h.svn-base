//
//  DVCSRequest.h
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DVCSRequestInformation.h"
#import "DataDVCS.h"
#import "GeneralName.h"
#import "ASN1TaggedObject.h"

@interface DVCSRequest : ASN1Object {
@private
    DVCSRequestInformation *_requestInformation;
    DataDVCS *_data;
    GeneralName *_transactionIdentifier;
}

+ (DVCSRequest *)getInstance:(id)paramObject;
+ (DVCSRequest *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initparamDVCSRequestInformation:(DVCSRequestInformation *)paramDVCSRequestInformation paramData:(DataDVCS *)paramData;
- (instancetype)initparamDVCSRequestInformation:(DVCSRequestInformation *)paramDVCSRequestInformation paramData:(DataDVCS *)paramData paramGeneralName:(GeneralName *)paramGeneralName;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;
- (DataDVCS *)getData;
- (DVCSRequestInformation *)getRequestInformation;
- (GeneralName *)getTransactionIdentifier;

@end

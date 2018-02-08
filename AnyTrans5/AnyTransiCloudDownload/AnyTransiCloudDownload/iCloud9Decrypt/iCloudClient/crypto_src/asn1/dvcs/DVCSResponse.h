//
//  DVCSResponse.h
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "DVCSCertInfo.h"
#import "DVCSErrorNotice.h"
#import "ASN1TaggedObject.h"

@interface DVCSResponse : ASN1Choice {
@private
    DVCSCertInfo *_dvCertInfo;
    DVCSErrorNotice *_dvErrorNote;
}

+ (DVCSResponse *)getInstance:(id)paramObject;
+ (DVCSResponse *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamDVCSCertInfo:(DVCSCertInfo *)paramDVCSCertInfo;
- (instancetype)initParamDVCSErrorNotice:(DVCSErrorNotice *)paramDVCSErrorNotice;
- (DVCSCertInfo *)getCertInfo;
- (DVCSErrorNotice *)getErrorNotice;

@end

//
//  NoticeReference.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DisplayText.h"
#import "ASN1Sequence.h"

@interface NoticeReference : ASN1Object {
@private
    DisplayText *_organization;
    ASN1Sequence *_noticeNumbers;
}

+ (NoticeReference *)getInstance:(id)paramObject;
- (instancetype)initParamString:(NSString *)paramString paramVector:(NSMutableArray *)paramVector;
- (instancetype)initParamString:(NSString *)paramString paramASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector;
- (instancetype)initpParamDisplayText:(DisplayText *)paramDisplayText paramASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector;
- (DisplayText *)getOrganization;
- (NSMutableArray *)getNoticeNumbers;
- (ASN1Primitive *)toASN1Primitive;

@end

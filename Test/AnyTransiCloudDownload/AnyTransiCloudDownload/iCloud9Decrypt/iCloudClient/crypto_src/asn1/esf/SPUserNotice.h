//
//  SPUserNotice.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "NoticeReference.h"
#import "DisplayText.h"

@interface SPUserNotice : ASN1Object {
@private
    NoticeReference *_noticeRef;
    DisplayText *_explicitText;
}

+ (SPUserNotice *)getInstance:(id)paramObject;
- (instancetype)initParamNoticeReference:(NoticeReference *)paramNoticeReference paramDisplayText:(DisplayText *)paramDisplayText;
- (NoticeReference *)getNoticeRef;
- (DisplayText *)getExplicitText;
- (ASN1Primitive *)toASN1Primitive;

@end

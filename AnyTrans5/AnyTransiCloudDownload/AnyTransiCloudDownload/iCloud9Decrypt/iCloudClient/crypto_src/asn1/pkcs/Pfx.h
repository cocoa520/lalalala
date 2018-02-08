//
//  Pfx.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKCSObjectIdentifiers.h"
#import "ContentInfoPKCS.h"
#import "MacData.h"

@interface Pfx : PKCSObjectIdentifiers {
@private
    ContentInfoPKCS *_contentInfo;
    MacData *_macData;
}

+ (Pfx *)getInstance:(id)paramObject;
- (instancetype)initParamContentInfo:(ContentInfoPKCS *)paramContentInfo paramMacData:(MacData *)paramMacData;
- (ContentInfoPKCS *)getAuthSafe;
- (MacData *)getMacData;
- (ASN1Primitive *)toASN1Primitive;

@end

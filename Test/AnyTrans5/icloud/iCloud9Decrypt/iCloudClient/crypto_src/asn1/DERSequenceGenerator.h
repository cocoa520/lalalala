//
//  DERSequenceGenerator.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERGenerator.h"
#import "ASN1Encodable.h"
#import "ASN1Primitive.h"
#import "CategoryExtend.h"

@interface DERSequenceGenerator : DERGenerator {
@private
    Stream *_bOut;
}

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream;
- (instancetype)initParamOutputStream:(Stream *)paramOutputStream paramInt:(int)paramInt paramBoolean:(BOOL)paramBoolean;
- (void)addObject:(ASN1Encodable *)paramASN1Encodable;
- (Stream *)getRawOutputStream;

@end

//
//  BERSequenceGenerator.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BERGenerator.h"
#import "ASN1Encodable.h"

@interface BERSequenceGenerator : BERGenerator

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream;
- (instancetype)initParamOutputStream:(Stream *)paramOutputStream paramInt:(int)paramInt paramBoolean:(BOOL)paramBoolean;
- (void)addObject:(ASN1Encodable *)paramASN1Encodable;
- (void)close;

@end

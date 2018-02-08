//
//  DERGenerator.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Generator.h"
#import "CategoryExtend.h"

@interface DERGenerator : ASN1Generator {
@private
    BOOL _tagged;
    BOOL _isExplicit;
    int _tagNo;
}

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream;
- (instancetype)initParamOutputStream:(Stream *)paramOutputStream paramInt:(int)paramInt paramBoolean:(BOOL)paramBoolean;
- (void)writeDEREncoded:(Stream *)paramOutputStream paramInt:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (void)writeDEREncoded:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayOfByte;

@end

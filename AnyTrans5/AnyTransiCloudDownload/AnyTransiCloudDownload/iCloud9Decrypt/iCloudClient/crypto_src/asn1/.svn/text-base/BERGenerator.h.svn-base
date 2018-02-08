//
//  BERGenerator.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Generator.h"

@interface BERGenerator : ASN1Generator {
@private
    BOOL _tagged;
    BOOL _isExplicit;
    int _tagNo;
}

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream;
- (instancetype)initParamOutputStream:(Stream *)paramOutputStream paramInt:(int)paramInt paramBoolean:(BOOL)paramBoolean;
- (Stream *)getRawOutputStream;
- (void)writeBERHeader:(int)paramInt;
- (void)writeBEREnd;

@end

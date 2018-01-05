//
//  ASN1StreamParser.h
//  crypto
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1Encodable.h"
#import "ASN1EncodableVector.h"
#import "ASN1Primitive.h"
#import "CategoryExtend.h"

@interface ASN1StreamParser : Stream {
@private
    Stream *_iN;
    int _limit;
    NSMutableArray *_tmpBuffers;
}

- (instancetype)initParamInputStream:(Stream *)paramInputStream;
- (instancetype)initParamInputStream:(Stream *)paramInputStream paramInt:(int)paramInt;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (ASN1Encodable *)readIndef:(int)paramInt;
- (ASN1Encodable *)readImplicit:(BOOL)paramBoolean paramInt:(int)paramInt;
- (ASN1Primitive *)readTaggedObject:(BOOL)paramBoolean paramInt:(int)paramInt;
- (ASN1Encodable *)readObject;
- (ASN1EncodableVector *)readVector;

@end

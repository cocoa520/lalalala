//
//  ASN1EncodableVector.h
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1Encodable.h"

@interface ASN1EncodableVector : NSObject {
    NSMutableArray *_vector;
}

@property (nonatomic, readwrite, retain) NSMutableArray *vector;

- (instancetype)init;
- (void)add:(ASN1Encodable *)paramASN1Encodable;
- (void)addAll:(ASN1EncodableVector *)paramASN1EncodableVector;
- (ASN1Encodable *)get:(int)paramInt;
- (NSUInteger)size;

@end

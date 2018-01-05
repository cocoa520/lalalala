//
//  BERFactory.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BERSequence.h"
#import "BERSet.h"

@interface BERFactory : NSObject

+ (BERSequence *)EMPTY_SEQUENCE;
+ (BERSet *)EMPTY_SET;
+ (BERSequence *)createSequence:(ASN1EncodableVector *)paramASN1EncodableVector;
+ (BERSet *)createSet:(ASN1EncodableVector *)paramASN1EncodableVector;

@end

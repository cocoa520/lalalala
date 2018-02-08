//
//  Target.h
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "GeneralName.h"

@interface Target : ASN1Choice {
@private
    GeneralName *_targName;
    GeneralName *_targGroup;
}

+ (Target *)getInstance:(id)paramObject;
- (instancetype)initParamInt:(int)paramInt paramGeneralName:(GeneralName *)paramGeneralName;
- (GeneralName *)getTargetGroup;
- (GeneralName *)getTargetName;
- (ASN1Primitive *)toASN1Primitive;

@end

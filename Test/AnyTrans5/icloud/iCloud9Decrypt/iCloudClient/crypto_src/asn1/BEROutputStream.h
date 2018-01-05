//
//  BEROutputStream.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DEROutputStream.h"

@interface BEROutputStream : DEROutputStream

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream;
- (void)writeObject:(id)paramObject;

@end

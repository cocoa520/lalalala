//
//  StreamUtil.h
//  crypto
//
//  Created by JGehry on 5/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryExtend.h"

@interface StreamUtil : NSObject

+ (int)findLimit:(Stream *)paramInputStream;
+ (int)calculateBodyLength:(int)paramInt;
+ (int)calculateTagLength:(int)paramInt;
+ (NSMutableData *)readAll:(Stream *)paramInputStream;

@end

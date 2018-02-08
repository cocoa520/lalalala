//
//  NameConstraintValidator.h
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralName.h"
#import "GeneralSubtree.h"

@interface NameConstraintValidator : NSObject

- (void)checkPermitted:(GeneralName *)paramGeneralName;
- (void)checkExcluded:(GeneralName *)paramGeneralName;
- (void)intersectPermittedSubtree:(GeneralSubtree *)paramGeneralSubtree;
- (void)intersectPermittedSubtreeArrayOf:(NSMutableArray *)paramArrayOfGeneralSubtree;
- (void)intersectEmptyPermittedSubtree:(int)paramInt;
- (void)addExcludedSubtree:(GeneralSubtree *)paramGeneralSubtree;

@end

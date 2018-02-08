//
//  PKIXNameConstraintValidator.h
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "NameConstraintValidator.h"

@interface PKIXNameConstraintValidator : NameConstraintValidator {
@private
    NSSet *_excludedSubtreesDN;
    NSSet *_excludedSubtreesDNS;
    NSSet *_excludedSubtreesEmail;
    NSSet *_excludedSubtreesURI;
    NSSet *_excludedSubtreesIP;
    NSSet *_permittedSubtreesDN;
    NSSet *_permittedSubtreesDNS;
    NSSet *_permittedSubtreesEmail;
    NSSet *_permittedSubtreesURI;
    NSSet *_permittedSubtreesIP;
}

- (void)checkPermitted:(GeneralName *)paramGeneralName;
- (void)checkExcluded:(GeneralName *)paramGeneralName;
- (void)intersectPermittedSubtree:(GeneralSubtree *)paramGeneralSubtree;
- (void)intersectPermittedSubtreeArrayOf:(NSMutableArray *)paramArrayOfGeneralSubtree;
- (void)intersectEmptyPermittedSubtree:(int)paramInt;
- (void)addExcludedSubtree:(GeneralSubtree *)paramGeneralSubtree;
- (NSString *)toString;

@end

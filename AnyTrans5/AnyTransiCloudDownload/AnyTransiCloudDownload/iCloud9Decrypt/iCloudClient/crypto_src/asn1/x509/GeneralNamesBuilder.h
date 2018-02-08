//
//  GeneralNamesBuilder.h
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralName.h"
#import "GeneralNames.h"

@interface GeneralNamesBuilder : NSObject {
@private
    NSMutableArray *_names;
}

- (GeneralNamesBuilder *)addNames:(GeneralNames *)paramGeneralNames;
- (GeneralNamesBuilder *)addName:(GeneralName *)paramGeneralName;
- (GeneralNames *)build;

@end

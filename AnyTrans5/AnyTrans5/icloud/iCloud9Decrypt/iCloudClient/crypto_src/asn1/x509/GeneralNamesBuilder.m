//
//  GeneralNamesBuilder.m
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "GeneralNamesBuilder.h"

@interface GeneralNamesBuilder ()

@property (nonatomic, readwrite, retain) NSMutableArray *names;

@end

@implementation GeneralNamesBuilder
@synthesize names = _names;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_names) {
        [_names release];
        _names = nil;
    }
    [super dealloc];
#endif
}

- (void)setNames:(NSMutableArray *)names {
    if (_names != names) {
        _names = [[[NSMutableArray alloc] init] autorelease];
    }
}

- (GeneralNamesBuilder *)addNames:(GeneralNames *)paramGeneralNames {
    NSMutableArray *arrayOfGeneralName = [paramGeneralNames getNames];
    for (int i = 0; i != arrayOfGeneralName.count; i++) {
        [self.names addObject:arrayOfGeneralName[i]];
    }
    return self;
}

- (GeneralNamesBuilder *)addName:(GeneralName *)paramGeneralName {
    [self.names addObject:paramGeneralName];
    return self;
}

- (GeneralNames *)build {
    NSMutableArray *arrayOfGeneralName = [[NSMutableArray alloc] initWithSize:(int)[self.names count]];
    for (int i = 0; i != arrayOfGeneralName.count; i++) {
        arrayOfGeneralName[i] = (GeneralName *)[self.names objectAtIndex:i];
    }
    GeneralNames *general = [[[GeneralNames alloc] initParamArrayOfGeneralName:arrayOfGeneralName] autorelease];
#if !__has_feature(objc_arc)
    if (arrayOfGeneralName) [arrayOfGeneralName release]; arrayOfGeneralName = nil;
#endif
    return general;
}

@end

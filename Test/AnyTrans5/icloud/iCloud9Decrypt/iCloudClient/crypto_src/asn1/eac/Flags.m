//
//  Flags.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Flags.h"
#import "StringJoiner.h"
#import "BigInteger.h"

@implementation Flags
@synthesize value = _value;

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initParamInt:(int)paramInt
{
    self = [super init];
    if (self) {
        self.value = paramInt;
    }
    return self;
}

- (void)set:(int)paramInt {
    self.value |= paramInt;
}

- (BOOL)isSet:(int)paramInt {
    return (self.value & paramInt) != 0;
}

- (int)getFlags {
    return self.value;
}

- (NSString *)decode:(NSMutableDictionary *)paramHashtable {
    StringJoiner *localStringJoiner = [[[StringJoiner alloc] initParamString:@" "] autorelease];
    NSEnumerator *localEnumeration = [paramHashtable keyEnumerator];
    BigInteger *localInteger = nil;
    while (localInteger = [localEnumeration nextObject]) {
        if ([self isSet:[localInteger intValue]]) {
            [localStringJoiner add:(NSString *)[paramHashtable objectForKey:localInteger]];
        }
    }
    return [localStringJoiner toString];
}

@end

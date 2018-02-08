//
//  PrimeField.m
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "PrimeField.h"
#import "BigInteger.h"

@interface PrimeField ()

@property (nonatomic, readwrite, retain) BigInteger *characteristic;

@end

@implementation PrimeField
@synthesize characteristic = _characteristic;

- (id)initWithBigInteger:(BigInteger*)characteristic {
    if (self = [super init]) {
        [self setCharacteristic:characteristic];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setCharacteristic:nil];
    [super dealloc];
#endif
}

- (int)dimension {
    return 1;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (object != nil && [object isKindOfClass:[PrimeField class]]) {
        PrimeField *other = (PrimeField*)object;
        return [self.characteristic isEqual:other.characteristic];
    } else {
        return NO;
    }
}

- (NSUInteger)hash {
    return [self.characteristic hash];
}

@end

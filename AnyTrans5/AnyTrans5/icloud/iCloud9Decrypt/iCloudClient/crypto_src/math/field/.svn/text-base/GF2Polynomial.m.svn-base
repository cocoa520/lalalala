//
//  GF2Polynomial.m
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "GF2Polynomial.h"
#import "CategoryExtend.h"
#import "Arrays.h"

@interface GF2Polynomial ()

@property (nonatomic, readwrite, retain) NSMutableArray *exponents;

@end

@implementation GF2Polynomial
@synthesize exponents = _exponents;

- (id)initWithExponents:(NSMutableArray*)exponents {
    if (self = [super init]) {
        NSMutableArray *tmpArray = [exponents clone];
        [self setExponents:tmpArray];
#if !__has_feature(objc_arc)
        if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setExponents:nil];
    [super dealloc];
#endif
}

- (int)degree {
    return [self.exponents[self.exponents.count - 1] intValue];
}

- (NSMutableArray*)getExponentsPresent {
    return [[self.exponents clone] autorelease];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (object != nil && [object isKindOfClass:[GF2Polynomial class]]) {
        GF2Polynomial *other = (GF2Polynomial*)object;
        return [Arrays areEqualWithIntArray:self.exponents withB:other.exponents];
    } else {
        return NO;
    }
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithIntArray:self.exponents];
}

@end

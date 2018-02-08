//
//  WNafPreCompInfo.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "WNafPreCompInfo.h"
#import "ECPoint.h"

@interface WNafPreCompInfo ()

@property (nonatomic, readwrite, retain) NSMutableArray *m_preComp;
@property (nonatomic, readwrite, retain) NSMutableArray *m_preCompNeg;
@property (nonatomic, readwrite, retain) ECPoint *m_twice;

@end

@implementation WNafPreCompInfo
@synthesize m_preComp = _m_preComp;
@synthesize m_preCompNeg = _m_preCompNeg;
@synthesize m_twice = _m_twice;

- (id)init {
    if (self = [super init]) {
        [self setM_preComp:nil];
        [self setM_preCompNeg:nil];
        [self setM_twice:nil];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setM_preComp:nil];
    [self setM_preCompNeg:nil];
    [self setM_twice:nil];
    [super dealloc];
#endif
}

- (NSMutableArray*)preComp {
    return [self m_preComp];
}

- (void)setPreComp:(NSMutableArray*)preComp {
    [self setM_preComp:preComp];
}

- (NSMutableArray*)preCompNeg {
    return [self m_preCompNeg];
}

- (void)setPreCompNeg:(NSMutableArray*)preCompNeg {
    [self setM_preCompNeg:preCompNeg];
}

- (ECPoint*)twice {
    return [self m_twice];
}

- (void)setTwice:(ECPoint*)twice {
    [self setM_twice:twice];
}

@end

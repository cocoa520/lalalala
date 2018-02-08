//
//  FixedPointPreCompInfo.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "FixedPointPreCompInfo.h"

@interface FixedPointPreCompInfo ()

@property (nonatomic, readwrite, retain) NSMutableArray *m_preComp;
@property (nonatomic, readwrite, assign) int m_width;

@end

@implementation FixedPointPreCompInfo
@synthesize m_preComp = _m_preComp;
@synthesize m_width = _m_width;

- (id)init {
    if (self = [super init]) {
        [self setM_width:-1];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setM_preComp:nil];
    [super dealloc];
#endif
}

- (NSMutableArray*)preComp {
    return self.m_preComp;
}

- (void)setPreComp:(NSMutableArray*)preComp {
    [self setM_preComp:preComp];
}

- (int)width {
    return self.m_width;
}

- (void)setWidth:(int)width {
    [self setM_width:width];
}

@end

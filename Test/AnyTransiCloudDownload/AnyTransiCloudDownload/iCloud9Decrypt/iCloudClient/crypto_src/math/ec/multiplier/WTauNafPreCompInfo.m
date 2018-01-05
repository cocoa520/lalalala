//
//  WTauNafPreCompInfo.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "WTauNafPreCompInfo.h"

@interface WTauNafPreCompInfo ()

@property (nonatomic, readwrite, retain) NSMutableArray *m_preComp;

@end

@implementation WTauNafPreCompInfo
@synthesize m_preComp = _m_preComp;

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
    [self setPreComp:preComp];
}

@end

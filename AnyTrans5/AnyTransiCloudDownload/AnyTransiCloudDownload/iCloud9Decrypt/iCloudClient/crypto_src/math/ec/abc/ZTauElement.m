//
//  ZTauElement.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "ZTauElement.h"
#import "BigInteger.h"

@interface ZTauElement ()

@property (nonatomic, readwrite, retain) BigInteger *u;
@property (nonatomic, readwrite, retain) BigInteger *v;

@end

@implementation ZTauElement
@synthesize u = _u;
@synthesize v = _v;

/**
 * Constructor for an element <code>&#955;</code> of
 * <code><b>Z</b>[&#964;]</code>.
 * @param u The &quot;real&quot; part of <code>&#955;</code>.
 * @param v The &quot;<code>&#964;</code>-adic&quot; part of
 * <code>&#955;</code>.
 */
- (id)initWithU:(BigInteger*)u withV:(BigInteger*)v {
    if (self = [super init]) {
        [self setU:u];
        [self setV:v];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setU:nil];
    [self setV:nil];
    [super dealloc];
#endif
}

@end

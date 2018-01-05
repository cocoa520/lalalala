//
//  GlvEndomorphism.h
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "ECEndomorphism.h"

@class BigInteger;

@interface GlvEndomorphism : ECEndomorphism

- (NSMutableArray*)decomposeScalar:(BigInteger*)k;

@end

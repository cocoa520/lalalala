//
//  ECDomainParameters.h
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;
@class ECCurve;
@class ECPoint;

@interface ECDomainParameters : NSObject {
@private
    ECCurve *                           _curve;
    NSMutableData *                     _seed;
    ECPoint *                           _g;
    BigInteger *                        _n;
    BigInteger *                        _h;
}

@property (nonatomic, readwrite, retain) ECCurve *curve;
@property (nonatomic, readwrite, retain) NSMutableData *seed;
@property (nonatomic, readwrite, retain) ECPoint *g;
@property (nonatomic, readwrite, retain) BigInteger *n;
@property (nonatomic, readwrite, retain) BigInteger *h;

- (id)initWithCurve:(ECCurve*)curve withG:(ECPoint*)g withN:(BigInteger*)n;
- (id)initWithCurve:(ECCurve*)curve withG:(ECPoint*)g withN:(BigInteger*)n withH:(BigInteger*)h;
- (id)initWithCurve:(ECCurve*)curve withG:(ECPoint*)g withN:(BigInteger*)n withH:(BigInteger*)h withSeed:(NSMutableData*)seed;

- (NSMutableData*)getSeed;

- (BOOL)equalsWithOther:(ECDomainParameters*)other;

@end

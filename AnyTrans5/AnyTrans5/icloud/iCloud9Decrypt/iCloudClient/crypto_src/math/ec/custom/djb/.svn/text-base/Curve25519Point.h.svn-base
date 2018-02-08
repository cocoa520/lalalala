//
//  Curve25519Point.h
//  
//
//  Created by Pallas on 5/25/16.
//
//  Complete

#import "ECPoint.h"

@class Curve25519FieldElement;

@interface Curve25519Point : AbstractFpPoint

/**
 * Create a point which encodes with point compression.
 *
 * @param curve the curve to use
 * @param x affine x co-ordinate
 * @param y affine y co-ordinate
 *
 * @deprecated Use ECCurve.CreatePoint to construct points
 */
- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y;

// NSMutableArray == uint[]
- (Curve25519FieldElement*)calculateJacobianModifiedW:(Curve25519FieldElement*)z withUintArray:(NSMutableArray*)ZSquared;
- (Curve25519FieldElement*)getJacobianModifiedW;
- (Curve25519Point*)twiceJacobianModified:(BOOL)calculateW;

@end

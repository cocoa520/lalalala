//
//  SecP521R1Point.h
//  
//
//  Created by Pallas on 5/31/16.
//
// Complete

#import "ECPoint.h"

@interface SecP521R1Point : AbstractFpPoint

/**
 * Create a point which encodes with point compression.
 *
 * @param curve
 *            the curve to use
 * @param x
 *            affine x co-ordinate
 * @param y
 *            affine y co-ordinate
 *
 * @deprecated Use ECCurve.createPoint to construct points
 */
- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y;

@end
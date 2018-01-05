//
//  SecP160R2Point.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECPoint.h"

@interface SecP160R2Point : AbstractFpPoint

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
 * @deprecated Use ECCurve.CreatePoint to construct points
 */
- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y;

@end

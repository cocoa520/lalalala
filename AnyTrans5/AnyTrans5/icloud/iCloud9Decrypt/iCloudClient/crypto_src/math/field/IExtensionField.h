//
//  IExtensionField.h
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "IFiniteField.h"

@interface IExtensionField : IFiniteField

- (IFiniteField*)subfield;
- (int)degree;

@end
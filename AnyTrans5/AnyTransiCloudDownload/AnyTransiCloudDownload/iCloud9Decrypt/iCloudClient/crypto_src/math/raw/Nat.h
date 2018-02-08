//
//  Nat.h
//  
//
//  Created by Pallas on 5/9/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;

@interface Nat : NSObject

// x, y, z == uint[]
+ (uint)add:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// z == uint[]
+ (uint)add33At:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZpos:(int)zPos;
// z == uint[]
+ (uint)add33At:(int)len withX:(uint)x withZ:(NSMutableArray *)z withZoff:(int)zOff withZpos:(int)zPos;
// z == uint[]
+ (uint)add33To:(int)len withX:(uint)x withZ:(NSMutableArray*)z;
// z == uint[]
+ (uint)add33To:(int)len withX:(uint)x withZ:(NSMutableArray *)z withZoff:(int)zOff;
// x, y, z == uint[]
+ (uint)addBothTo:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// x, y, z == uint[]
+ (uint)addBothTo:(int)len withX:(NSMutableArray *)x withXoff:(int)xOff withY:(NSMutableArray *)y withYoff:(int)yOff withZ:(NSMutableArray *)z withZoff:(int)zOff;
// z == uint[]
+ (uint)addDWordAt:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z withZpos:(int)zPos;
// z == uint[]
+ (uint)addDWordAt:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z withZoff:(int)zOff withZpos:(int)zPos;
// z == uint[]
+ (uint)addDWordTo:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z;
// z == uint[]
- (uint)addDWordTo:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z withZoff:(int)zOff;
// x, z == uint[]
+ (uint)addTo:(int)len withX:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// x, z == uint[]
+ (uint)addTo:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withZ:(NSMutableArray*)z withZoff:(int)zOff;
// z == uint[]
+ (uint)addWordAt:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZpos:(int)zPos;
// z == uint[]
+ (uint)addWordAt:(int)len withX:(uint)x withZ:(NSMutableArray *)z withZoff:(int)zOff withZpos:(int)zPos;
// z == uint[]
+ (uint)addWordTo:(int)len withX:(uint)x withZ:(NSMutableArray*)z;
// z == uint[]
+ (uint)addWordTo:(int)len withX:(uint)x withZ:(NSMutableArray *)z withZoff:(int)zOff;
// x, z == uint[]
+ (void)copy:(int)len withX:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// x == uint[], return == uint[]
+ (NSMutableArray*)copy:(int)len withX:(NSMutableArray *)x;
// return == uint[]
+ (NSMutableArray*)create:(int)len;
// return == uint64_t[]
+ (NSMutableArray*)create64:(int)len;
// x == uint[]
+ (int)dec:(int)len withZ:(NSMutableArray*)z;
// x, z == uint[]
+ (int)dec:(int)len withX:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// z == uint[]
+ (int)decAt:(int)len withZ:(NSMutableArray*)z withZpos:(int)zPos;
// z == uint[]
+ (int)decAt:(int)len withZ:(NSMutableArray *)z withZoff:(int)zOff withZpos:(int)zPos;
// x, y == uint[]
+ (BOOL)eq:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y;
// return == uint[]
+ (NSMutableArray*)fromBigInteger:(int)bits withX:(BigInteger*)x;
// x == uint[]
+ (uint)getBit:(NSMutableArray*)x withBit:(int)bit;
// x, y == uint[]
+ (BOOL)gte:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y;
// z == uint[]
+ (uint)inc:(int)len withZ:(NSMutableArray*)z;
// x, z == uint[]
+ (uint)inc:(int)len withX:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// z == uint[]
+ (uint)incAt:(int)len withZ:(NSMutableArray*)z withZpos:(int)zPos;
// z == uint[]
+ (uint)incAt:(int)len withZ:(NSMutableArray*)z withZoff:(int)zOff withZpos:(int)zPos;
// x == uint[]
+ (BOOL)isOne:(int)len withX:(NSMutableArray*)x;
// x == uint[]
+ (BOOL)isZero:(int)len withX:(NSMutableArray*)x;
// x, y, zz == uint[]
+ (void)mul:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz;
// x, y, zz == uint[]
+ (void)mul:(int)len withX:(NSMutableArray *)x withXoff:(int)xOff withY:(NSMutableArray *)y withYoff:(int)yOff withZZ:(NSMutableArray *)zz withZZoff:(int)zzOff;
// x, y, z == uint[]
+ (uint)mul31BothAdd:(int)len withA:(uint)a withX:(NSMutableArray*)x withB:(uint)b withY:(NSMutableArray*)y withZ:(NSMutableArray*)z withZoff:(int)zOff;
// y, z == uint[]
+ (uint)mulWord:(int)len withX:(uint)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// y, z == uint[]
+ (uint)mulWord:(int)len withX:(uint)x withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff;
// y, z == uint[]
+ (uint)mulWordAddTo:(int)len withX:(uint)x withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff;
// z == uint[]
+ (uint)mulWordDwordAddAt:(int)len withX:(uint)x withY:(uint64_t)y withZ:(NSMutableArray*)z withZpos:(int)zPos;
// z == uint[]
+ (uint)shiftDownBit:(int)len withZ:(NSMutableArray*)z withC:(uint)c;
// z == uint[]
+ (uint)shiftDownBit:(int)len withZ:(NSMutableArray*)z withZoff:(int)zOff withC:(uint)c;
// x, z == uint[]
+ (uint)shiftDownBit:(int)len withX:(NSMutableArray*)x withC:(uint)c withZ:(NSMutableArray*)z;
// x, z == uint[]
+ (uint)shiftDownBit:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withC:(uint)c withZ:(NSMutableArray*)z withZoff:(int)zOff;
// z == uint[]
+ (uint)shiftDownBits:(int)len withZ:(NSMutableArray*)z withBits:(int)bits withC:(uint)c;
// z == uint[]
+ (uint)shiftDownBits:(int)len withZ:(NSMutableArray*)z withZoff:(int)zOff withBits:(int)bits withC:(uint)c;
// x, z == uint[]
+ (uint)shiftDownBits:(int)len withX:(NSMutableArray*)x withBits:(int)bits withC:(uint)c withZ:(NSMutableArray*)z;
// x, z == uint[]
+ (uint)shiftDownBits:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withBits:(int)bits withC:(uint)c withZ:(NSMutableArray *)z withZoff:(int)zOff;
// z == uint[]
+ (uint)shiftDownWord:(int)len withZ:(NSMutableArray*)z withC:(uint)c;
// z == uint[]
+ (uint)shiftUpBit:(int)len withZ:(NSMutableArray*)z withC:(uint)c;
// z == uint[]
+ (uint)shiftUpBit:(int)len withZ:(NSMutableArray*)z withZoff:(int)zOff withC:(uint)c;
// x, z == uint[]
+ (uint)shiftUpBit:(int)len withX:(NSMutableArray *)x withC:(uint)c withZ:(NSMutableArray*)z;
// x, z == uint[]
+ (uint)shiftUpBit:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withC:(uint)c withZ:(NSMutableArray*)z withZoff:(int)zOff;
// x, z == uint64_t[]
+ (uint64_t)shiftUpBit64:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withC:(uint64_t)c withZ:(NSMutableArray*)z withZoff:(int)zOff;
// z == uint[]
+ (uint)shiftUpBits:(int)len withZ:(NSMutableArray*)z withBits:(int)bits withC:(uint)c;
// z == uint[]
+ (uint)shiftUpBits:(int)len withZ:(NSMutableArray*)z withZoff:(int)zOff withBits:(int)bits withC:(uint)c;
// z == uint64_t[]
+ (uint64_t)shiftUpBits64:(int)len withZ:(NSMutableArray*)z withZoff:(int)zOff withBits:(int)bits withC:(uint64_t)c;
// x, z == uint[]
+ (uint)shiftUpBits:(int)len withX:(NSMutableArray*)x withBits:(int)bits withC:(uint)c withZ:(NSMutableArray*)z;
// x, z == uint[]
+ (uint)shiftUpBits:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withBits:(int)bits withC:(uint)c withZ:(NSMutableArray *)z withZoff:(int)zOff;
// x, z == uint64_t[]
+ (uint64_t)shiftUpBits64:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withBits:(int)bits withC:(uint64_t)c withZ:(NSMutableArray*)z withZoff:(int)zOff;
// x, zz == uint[]
+ (void)square:(int)len withX:(NSMutableArray*)x withZZ:(NSMutableArray*)zz;
// x, zz == uint[]
+ (void)square:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withZZ:(NSMutableArray*)zz withZZoff:(int)zzOff;
// x, z == uint[]
+ (uint)squareWordAdd:(NSMutableArray*)x withXpos:(int)xPos withZ:(NSMutableArray*)z;
// x, z == uint[]
+ (uint)squareWordAdd:(NSMutableArray*)x withXoff:(int)xOff withXpos:(int)xPos withZ:(NSMutableArray*)z withZoff:(int)zOff;
// x, y, z == uint[]
+ (int)sub:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// x, y, z == uint[]
+ (int)sub:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff;
// z == uint[]
+ (int)sub33At:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZpos:(int)zPos;
// z == uint[]
+ (int)sub33At:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZoff:(int)zOff withZpos:(int)zPos;
// z == uint[]
+ (int)sub33From:(int)len withX:(uint)x withZ:(NSMutableArray*)z;
// z == uint[]
+ (int)sub33From:(int)len withX:(uint)x withZ:(NSMutableArray *)z withZoff:(int)zOff;
// x, y, z == uint[]
+ (int)subBothFrom:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// x, y, z == uint[]
+ (int)subBothFrom:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff;
// z == uint[]
+ (int)subDWordAt:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z withZpos:(int)zPos;
// z == uint[]
+ (int)subDWordAt:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z withZoff:(int)zOff withZpos:(int)zPos;
// z == uint[]
+ (int)subDWordFrom:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z;
// z == uint[]
+ (int)subDWordFrom:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z withZoff:(int)zOff;
// x, z == uint[]
+ (int)subFrom:(int)len withX:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// x, z == uint[]
+ (int)subFrom:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withZ:(NSMutableArray*)z withZoff:(int)zOff;
// z == uint[]
+ (int)subWordAt:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZpos:(int)zPos;
// z == uint[]
+ (int)subWordAt:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZoff:(int)zOff withZpos:(int)zPos;
// z == uint[]
+ (int)subWordFrom:(int)len withX:(uint)x withZ:(NSMutableArray*)z;
// z == uint[]
+ (int)subWordFrom:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZoff:(int)zOff;
// x == uint[]
+ (BigInteger*)toBigInteger:(int)len withX:(NSMutableArray*)x;
// z == uint[]
+ (void)zero:(int)len withZ:(NSMutableArray*)z;

@end

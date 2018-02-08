//
//  BigInteger.h
//  
//
//  Created by Pallas on 4/27/16.
//
//

#import <Foundation/Foundation.h>

#define MAX_LENGTH 1024

typedef unsigned long long ulong;

@interface BigInteger : NSNumber {
@public
    int                                 _dataLength;
    uint                                data[MAX_LENGTH];
}

@property (nonatomic, readwrite, assign) int dataLength;

-(id)init;
-(id)initWithInt:(int)value;
-(id)initWithLong:(long)value;
-(id)initWithULong:(ulong)value;
-(id)initWithBigInt:(BigInteger *)value;
-(id)initWithUIntArray:(uint *)value withSize:(int)size;
-(id)initWithString:(NSString *)value andRadix:(int)radix;
-(id)initWithSignum:(int)signum withData:(NSData*)magnitude;

+(BigInteger *)create;
+(BigInteger *)createFromInt:(int)value;
+(BigInteger *)createFromLong:(long)value;
+(BigInteger *)createFromULong:(ulong)value;
+(BigInteger *)createFromBigInt:(BigInteger *)value;
+(BigInteger *)createFromString:(NSString *)value andRadix:(int)radix;

-(BigInteger *)add:(BigInteger *)bi2;
-(BigInteger *)subtract:(BigInteger *)bi2;
-(BigInteger *)multiply:(BigInteger *)bi2;
-(BigInteger *)divide:(BigInteger *)bi2;

-(BigInteger *)negate;
-(BigInteger *)not;
-(BigInteger *)shiftLeft:(int)shiftVal;
-(BigInteger *)shiftRight:(int)shiftVal;
-(BigInteger *)mod:(BigInteger *)bi2;
-(BigInteger *)and:(BigInteger *)bi2;
-(BigInteger *)or:(BigInteger *)bi2;
-(BigInteger *)xOr:(BigInteger *)bi2;

-(BOOL)equals:(BigInteger *)bi;
-(BOOL)greaterThan:(BigInteger *)bi2;
-(BOOL)lessThan:(BigInteger *)bi2;
-(BOOL)lessThanOrEqualTo:(BigInteger *)bi2;
-(BOOL)greaterThanOrEqualTo:(BigInteger *)bi2;

//***********************************************************************
// Returns the lowest 4 bytes of the BigInteger as an int.
//***********************************************************************
-(int)intValue;

//***********************************************************************
// Returns the absolute value
//***********************************************************************
-(BigInteger *)abs;

-(BigInteger *)sqrt;
-(BigInteger *)gcd:(BigInteger *)bi;

-(uint *)getData;
-(uint)getDataAtIndex:(int)index;
-(void)setData:(uint)value atIndex:(int)index;

//***********************************************************************
// Returns the position of the most significant bit in the BigInteger.
//
// Eg.  The result is 0, if the value of BigInteger is 0...0000 0000
//      The result is 1, if the value of BigInteger is 0...0000 0001
//      The result is 2, if the value of BigInteger is 0...0000 0010
//      The result is 2, if the value of BigInteger is 0...0000 0011
//
//***********************************************************************
-(int)bitCount;

//***********************************************************************
// Returns a string representing the BigInteger in sign-and-magnitude
// format in the specified radix.
//
// Example
// -------
// If the value of BigInteger is -255 in base 10, then
// [self toStringWithRadix:16] returns "-FF"
//
//***********************************************************************
-(NSString *)toStringWithRadix:(int)radix;

//***********************************************************************
// Modulo Exponentiation
//***********************************************************************
-(BigInteger *)modPow:(BigInteger *)exp withMod:(BigInteger *)mod;

//***********************************************************************
// Populates "this" with the specified amount of random bits
//***********************************************************************
-(void)getRandomBits:(int)bits;

//***********************************************************************
// Generates a positive BigInteger that is probably prime.
//***********************************************************************
+(BigInteger *)generatePseudoPrimeWithBits:(int)bits andConfidence:(int)confidence;

+(BigInteger *)generateNumberWithBits:(int)bits;


//***********************************************************************
// Determines whether this BigInteger is probably prime using a
// combination of base 2 strong pseudoprime test and Lucas strong
// pseudoprime test.
//
// The sequence of the primality test is as follows,
//
// 1) Trial divisions are carried out using prime numbers below 2000.
//    if any of the primes divides this BigInteger, then it is not prime.
//
// 2) Perform base 2 strong pseudoprime test.  If this BigInteger is a
//    base 2 strong pseudoprime, proceed on to the next step.
//
// 3) Perform strong Lucas pseudoprime test.
//
// Returns True if this BigInteger is both a base 2 strong pseudoprime
// and a strong Lucas pseudoprime.
//
// For a detailed discussion of this primality test, see [6].
//
//***********************************************************************
-(BOOL)isProbablePrime;

//***********************************************************************
// Determines whether a number is probably prime, using the Rabin-Miller's
// test.  Before applying the test, the number is tested for divisibility
// by primes < 2000
//
// Returns true if number is probably prime.
//***********************************************************************
-(BOOL)isProbablePrimeWithConfidence:(int)confidence;

//***********************************************************************
// Performs the calculation of the kth term in the Lucas Sequence.
// For details of the algorithm, see reference [9].
//
// k must be odd.  i.e LSB == 1
//***********************************************************************
+(NSMutableArray *)lucasSequence:(BigInteger *)P andQ:(BigInteger *)Q andk:(BigInteger *)k andn:(BigInteger *)n andConstant:(BigInteger *)constant ands:(int)s;

//***********************************************************************
// Probabilistic prime test based on Rabin-Miller's
//
// for any p > 0 with p - 1 = 2^s * t
//
// p is probably prime (strong pseudoprime) if for any a < p,
// 1) a^t mod p = 1 or
// 2) a^((2^j)*t) mod p = p-1 for some 0 <= j <= s-1
//
// Otherwise, p is composite.
//
// Returns
// -------
// True if "this" is a strong pseudoprime to randomly chosen
// bases.  The number of chosen bases is given by the "confidence"
// parameter.
//
// False if "this" is definitely NOT prime.
//
//***********************************************************************
-(BOOL)rabinMillerTestWithConfidence:(int)confidence;

//***********************************************************************
// Fast calculation of modular reduction using Barrett's reduction.
// Requires x < b^(2k), where b is the base.  In this case, base is
// 2^32 (uint).
//
// Reference [4]
//***********************************************************************
+(BigInteger *)barrettReduction:(BigInteger *)x andN:(BigInteger *)n andConstant:(BigInteger *)constant;

+(void)singleByteDivide:(BigInteger *)bi1 bi2:(BigInteger *)bi2 outQuotient:(BigInteger *)outQuotient outRemainder:(BigInteger *)outRemainder;
+(void)multiByteDivide:(BigInteger *)bi1 bi2:(BigInteger *)bi2 outQuotient:(BigInteger *)outQuotient outRemainder:(BigInteger *)outRemainder;

+(int)shiftLeft:(uint *)buffer withSizeOf:(int)bufferSize bits:(int)shiftVal;
+(int)shiftRight:(uint *)buffer withSizeOf:(int)bufferSize bits:(int)shiftVal;

+(BOOL)lucasStrongTest:(BigInteger *)thisVal;
+(int)jacobi:(BigInteger *)a andB:(BigInteger *)b;

// Hashing

-(NSString *)sha256;
-(NSString *)sha512;

-(NSString *)sha256:(NSString *)input;
-(NSString *)sha512:(NSString *)input;

@end

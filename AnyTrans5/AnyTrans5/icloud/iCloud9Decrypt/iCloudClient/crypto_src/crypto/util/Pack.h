//
//  Pack.h
//  
//
//  Created by Pallas on 5/9/16.
//
//  complete

#import <Foundation/Foundation.h>

@interface Pack : NSObject

// bs == byte[]
+ (void)UInt16_To_BE:(ushort)n withBs:(NSMutableData*)bs;
// bs == byte[]
+ (void)UInt16_To_BE:(ushort)n withBs:(NSMutableData*)bs withOff:(int)off;
// bs == byte[]
+ (ushort)BE_To_UInt16:(NSMutableData*)bs;
// bs == byte[]
+ (ushort)BE_To_UInt16:(NSMutableData*)bs withOff:(int)off;
// return == byte[]
+ (NSMutableData*)UInt32_To_BE:(uint)n;
// bs == byte[]
+ (void)UInt32_To_BE:(uint)n withBs:(NSMutableData*)bs;
// bs == byte[]
+ (void)UInt32_To_BE:(uint)n withBs:(NSMutableData*)bs withOff:(int)off;
// ns == uint[], return ==  byte[]
+ (NSMutableData*)UInt32_To_BE_Array:(NSMutableArray*)ns;
// ns == uint[], bs ==  byte[]
+ (void)UInt32_To_BE_Array:(NSMutableArray*)ns withBs:(NSMutableData*)bs withOff:(int)off;
// bs ==  byte[]
+ (uint)BE_To_UInt32:(NSMutableData*)bs;
// bs ==  byte[]
+ (uint)BE_To_UInt32:(NSMutableData*)bs withOff:(int)off;
// bs ==  byte[], ns == uint[]
+ (void)BE_To_UInt32:(NSMutableData*)bs withOff:(int)off withNs:(NSMutableArray*)ns;
// return == byte[]
+ (NSMutableData*)UInt64_To_BE:(uint64_t)n;
// bs == byte[]
+ (void)UInt64_To_BE:(uint64_t)n withBs:(NSMutableData*)bs;
// bs == byte[]
+ (void)UInt64_To_BE:(uint64_t)n withBs:(NSMutableData*)bs withOff:(int)off;
// return ==  byte[], ns == uint64_t[]
+ (NSMutableData*)UInt64_To_BE_Array:(NSMutableArray*)ns;
// ns == uint64_t[], bs ==  byte[]
+ (void)UInt64_To_BE_Array:(NSMutableArray*)ns withBs:(NSMutableData*)bs withOff:(int)off;
// bs ==  byte[]
+ (uint64_t)BE_To_UInt64:(NSMutableData*)bs;
// bs ==  byte[]
+ (uint64_t)BE_To_UInt64:(NSMutableData*)bs withOff:(int)off;
// bs ==  byte[], ns == uint64_t[]
+ (void)BE_To_UInt64:(NSMutableData*)bs withOff:(int)off withNs:(NSMutableArray*)ns;

// bs ==  byte[]
+ (void)UInt16_To_LE:(ushort)n withBs:(NSMutableData*)bs;
// bs ==  byte[]
+ (void)UInt16_To_LE:(ushort)n withBs:(NSMutableData*)bs withOff:(int)off;
// bs ==  byte[]
+ (ushort)LE_To_UInt16:(NSMutableData*)bs;
// bs ==  byte[]
+ (ushort)LE_To_UInt16:(NSMutableData*)bs withOff:(int)off;
// return ==  byte[]
+ (NSMutableData*)UInt32_To_LE:(uint)n;
// bs ==  byte[]
+ (void)UInt32_To_LE:(uint)n withBs:(NSMutableData*)bs;
// bs ==  byte[]
+ (void)UInt32_To_LE:(uint)n withBs:(NSMutableData*)bs withOff:(int)off;
// ns ==  uint[]
+ (NSMutableData*)UInt32_To_LE_Array:(NSMutableArray*)ns;
// ns ==  uint[], bs == byte[]
+ (void)UInt32_To_LE_Array:(NSMutableArray*)ns withBs:(NSMutableData*)bs withOff:(int)off;
// bs == byte[]
+ (uint)LE_To_UInt32:(NSMutableData*)bs;
// bs == byte[]
+ (uint)LE_To_UInt32:(NSMutableData*)bs withOff:(int)off;
// bs == byte[], ns == uint[]
+ (void)LE_To_UInt32:(NSMutableData*)bs withOff:(int)off withNs:(NSMutableArray*)ns;
// bs == byte[], ns == uint[]
+ (void)LE_To_UInt32:(NSMutableData*)bs withBoff:(int)bOff withNs:(NSMutableArray*)ns withNoff:(int)nOff withCount:(int)count;
// return == byte[]
+ (NSMutableData*)UInt64_To_LE:(uint64_t)n;
// bs == byte[]
+ (void)UInt64_To_LE:(uint64_t)n withBs:(NSMutableData*)bs;
// bs == byte[]
+ (void)UInt64_To_LE:(uint64_t)n withBs:(NSMutableData*)bs withOff:(int)off;
// bs == byte[]
+ (uint64_t)LE_To_UInt64:(NSMutableData*)bs;
// bs == byte[]
+ (uint64_t)LE_To_UInt64:(NSMutableData*)bs withOff:(int)off;
// bs == byte[]
+ (int)LE_To_Int:(NSMutableData*)bs withOff:(int)off;
// bs == byte[], ns == int[]
+ (void)LE_To_Int:(NSMutableData*)bs withOff:(int)off withNs:(NSMutableArray*)ns;
// return == byte[]
+ (NSMutableData*)Int_To_LE:(int)n;
// bs == byte[]
+ (void)Int_To_LE:(int)n withBs:(NSMutableData*)bs withOff:(int)off;
// return == byte[], ns == int[]
+ (NSMutableData*)Int_To_LE_IntArray:(NSMutableArray*)ns;
// return == byte[], ns == int[]
+ (void)Int_To_LE_IntArray:(NSMutableArray*)ns withBs:(NSMutableData*)bs withOff:(int)off;
// bs == byte[]
+ (int64_t)LE_To_Int64:(NSMutableData*)bs withOff:(int)off;
// bs == byte[], ns == long[]
+ (void)LE_To_Int64:(NSMutableData*)bs withOff:(int)off withNs:(NSMutableArray*)ns;
// return == byte[]
+ (NSMutableData*)Int64_To_LE:(int64_t)n;
// bs == byte[]
+ (void)Int64_To_LE:(int64_t)n withBs:(NSMutableData*)bs withOff:(int)off;
// return == byte[], ns == long[]
+ (NSMutableData*)Int64_To_LE_Int64Array:(NSMutableArray*)ns;
// ns == long[], bs == byte[]
+ (void)Int64_To_LE_Int64Array:(NSMutableArray*)ns withBs:(NSMutableData*)bs withOff:(int)off;

@end

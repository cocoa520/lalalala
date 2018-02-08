//
//  Hex.m
//  
//
//  Created by Pallas on 5/30/16.
//
//

#import "Hex.h"
#import "CategoryExtend.h"
#import "HexEncoder.h"
#import "StringsEx.h"

@implementation Hex

+ (Encoder*)encoder {
    static Encoder *_encoder = nil;
    @synchronized(self) {
        if (_encoder == nil) {
            _encoder = [[HexEncoder alloc] init];
        }
    }
    return _encoder;
}

- (id)init {
    if (self = [super init]) {
        return self;
    } else {
        return nil;
    }
}

+ (NSString*)toHexString:(NSMutableData*)data {
    return [Hex toHexString:data withOff:0 withLength:(int)(data.length)];
}

+ (NSString*)toHexString:(NSMutableData*)data withOff:(int)off withLength:(int)length {
    NSMutableData *hex = [Hex encode:data withOff:off withLength:length];
    return [StringsEx fromAsciiByteArray:hex];
}

/**
 * encode the input data producing a Hex encoded byte array.
 *
 * @return a byte array containing the Hex encoded data.
 */
+ (NSMutableData*)encode:(NSMutableData*)data {
    return [Hex encode:data withOff:0 withLength:(int)(data.length)];
}

/**
 * encode the input data producing a Hex encoded byte array.
 *
 * @return a byte array containing the Hex encoded data.
 */
+ (NSMutableData*)encode:(NSMutableData*)data withOff:(int)off withLength:(int)length {
    DataStream *bOut = [[[DataStream alloc] initWithAllocateSize:(length * 2)] autorelease];
    
    [[Hex encoder] encode:data withOff:off withLength:length withOutStream:bOut];
    
    return [bOut toMutableData];
}

/**
 * Hex encode the byte data writing it to the given output stream.
 *
 * @return the number of bytes produced.
 */
+ (int)encode:(NSMutableData*)data withOutStream:(DataStream*)outStream {
    return [[Hex encoder] encode:data withOff:0 withLength:(int)(data.length) withOutStream:outStream];
}

/**
 * Hex encode the byte data writing it to the given output stream.
 *
 * @return the number of bytes produced.
 */
+ (int)encode:(NSMutableData*)data withOff:(int)off withLength:(int)length withOutStream:(DataStream*)outStream {
    return [[Hex encoder] encode:data withOff:off withLength:length withOutStream:outStream];
}

/**
 * decode the Hex encoded input data. It is assumed the input data is valid.
 *
 * @return a byte array representing the decoded data.
 */
+ (NSMutableData*)decodeWithByteArray:(NSMutableData*)data {
    DataStream *bOut = [[[DataStream alloc] initWithAllocateSize:(((int)(data.length) + 1) / 2)] autorelease];
    
    [[Hex encoder] decode:data withOff:0 withLength:(int)(data.length) withOutStream:bOut];
    
    return [bOut toMutableData];
}

/**
 * decode the Hex encoded string data - whitespace will be ignored.
 *
 * @return a byte array representing the decoded data.
 */
+ (NSMutableData*)decodeWithString:(NSString*)data {
    DataStream *bOut = [[[DataStream alloc] initWithAllocateSize:(((int)(data.length) + 1) / 2)] autorelease];
    
    [[Hex encoder] decodeString:data withOutStream:bOut];
    
    return [bOut toMutableData];
}

/**
 * decode the Hex encoded string data writing it to the given output stream,
 * whitespace characters will be ignored.
 *
 * @return the number of bytes produced.
 */
+ (int)decode:(NSString*)data withOutStream:(DataStream*)outStream {
    return [[Hex encoder] decodeString:data withOutStream:outStream];
}

@end

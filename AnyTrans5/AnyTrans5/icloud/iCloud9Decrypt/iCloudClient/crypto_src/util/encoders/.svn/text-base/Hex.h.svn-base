//
//  Hex.h
//  
//
//  Created by Pallas on 5/30/16.
//
//

#import <Foundation/Foundation.h>

@class DataStream;

@interface Hex : NSObject

+ (NSString*)toHexString:(NSMutableData*)data;
+ (NSString*)toHexString:(NSMutableData*)data withOff:(int)off withLength:(int)length;
/**
 * encode the input data producing a Hex encoded byte array.
 *
 * @return a byte array containing the Hex encoded data.
 */
+ (NSMutableData*)encode:(NSMutableData*)data;
/**
 * encode the input data producing a Hex encoded byte array.
 *
 * @return a byte array containing the Hex encoded data.
 */
+ (NSMutableData*)encode:(NSMutableData*)data withOff:(int)off withLength:(int)length;
/**
 * Hex encode the byte data writing it to the given output stream.
 *
 * @return the number of bytes produced.
 */
+ (int)encode:(NSMutableData*)data withOutStream:(DataStream*)outStream;
/**
 * Hex encode the byte data writing it to the given output stream.
 *
 * @return the number of bytes produced.
 */
+ (int)encode:(NSMutableData*)data withOff:(int)off withLength:(int)length withOutStream:(DataStream*)outStream;
/**
 * decode the Hex encoded input data. It is assumed the input data is valid.
 *
 * @return a byte array representing the decoded data.
 */
+ (NSMutableData*)decodeWithByteArray:(NSMutableData*)data;
/**
 * decode the Hex encoded string data - whitespace will be ignored.
 *
 * @return a byte array representing the decoded data.
 */
+ (NSMutableData*)decodeWithString:(NSString*)data;
/**
 * decode the Hex encoded string data writing it to the given output stream,
 * whitespace characters will be ignored.
 *
 * @return the number of bytes produced.
 */
+ (int)decode:(NSString*)data withOutStream:(DataStream*)outStream;

@end

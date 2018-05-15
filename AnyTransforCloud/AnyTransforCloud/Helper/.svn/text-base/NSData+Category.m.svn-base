//
//  NSData+Category.m
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "NSData+Category.h"
#import <zlib.h>
#include <sys/stat.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (Category)

- (NSData *)AES256EncryptWithKey:(NSString *)key
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero( keyPtr, sizeof( keyPtr ) ); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof( keyPtr ) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted );
    if( cryptStatus == kCCSuccess )
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free( buffer ); //free the buffer
    return nil;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero( keyPtr, sizeof( keyPtr ) ); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof( keyPtr ) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted );
    
    if( cryptStatus == kCCSuccess )
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free( buffer ); //free the buffer
    return nil;
}

// Returns range [start, null byte), or (NSNotFound, 0).
- (NSRange) rangeOfNullTerminatedBytesFrom:(int)start
{
	const Byte *pdata = [self bytes];
	int len = (int)[self length];
	if (start < len)
	{
		const Byte *end = memchr (pdata + start, 0x00, len - start);
		if (end != NULL) return NSMakeRange (start, end - (pdata + start));
	}
	return NSMakeRange (NSNotFound, 0);
}

+ (NSData *) dataWithBase32String:(NSString *)encoded
{
	/* First valid character that can be indexed in decode lookup table */
	static int charDigitsBase = '2';
    
	/* Lookup table used to decode() characters in encoded strings */
	static int charDigits[] =
	{	26,27,28,29,30,31,-1,-1,-1,-1,-1,-1,-1,-1 //   23456789:;<=>?
		,-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14 // @ABCDEFGHIJKLMNO
		,15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1 // PQRSTUVWXYZ[\]^_
		,-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14 // `abcdefghijklmno
		,15,16,17,18,19,20,21,22,23,24,25                // pqrstuvwxyz
	};
    
	if (! [encoded canBeConvertedToEncoding:NSASCIIStringEncoding]) return nil;
	const char *chars = [encoded cStringUsingEncoding:NSASCIIStringEncoding]; // avoids using characterAtIndex.
	int charsLen = (int)[encoded lengthOfBytesUsingEncoding:NSASCIIStringEncoding];
    
	// Note that the code below could detect non canonical Base32 length within the loop. However canonical Base32 length can be tested before entering the loop.
	// A canonical Base32 length modulo 8 cannot be:
	// 1 (aborts discarding 5 bits at STEP n=0 which produces no byte),
	// 3 (aborts discarding 7 bits at STEP n=2 which produces no byte),
	// 6 (aborts discarding 6 bits at STEP n=1 which produces no byte).
	switch (charsLen & 7) { // test the length of last subblock
		case 1: //  5 bits in subblock:  0 useful bits but 5 discarded
		case 3: // 15 bits in subblock:  8 useful bits but 7 discarded
		case 6: // 30 bits in subblock: 24 useful bits but 6 discarded
			return nil; // non-canonical length
	}
	int charDigitsLen = sizeof(charDigits);
	int bytesLen = (charsLen * 5) >> 3;
	Byte bytes[bytesLen];
	int bytesOffset = 0, charsOffset = 0;
	// Also the code below does test that other discarded bits
	// (1 to 4 bits at end) are effectively 0.
	while (charsLen > 0)
	{
		int digit, lastDigit;
		// STEP n = 0: Read the 1st Char in a 8-Chars subblock
		// Leave 5 bits, asserting there's another encoding Char
		if ((digit = (int)chars[charsOffset] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		lastDigit = digit << 3;
		// STEP n = 5: Read the 2nd Char in a 8-Chars subblock
		// Insert 3 bits, leave 2 bits, possibly trailing if no more Char
		if ((digit = (int)chars[charsOffset + 1] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		bytes[bytesOffset] = (Byte)((digit >> 2) | lastDigit);
		lastDigit = (digit & 3) << 6;
		if (charsLen == 2) {
			if (lastDigit != 0) return nil; // non-canonical end
			break; // discard the 2 trailing null bits
		}
		// STEP n = 2: Read the 3rd Char in a 8-Chars subblock
		// Leave 7 bits, asserting there's another encoding Char
		if ((digit = (int)chars[charsOffset + 2] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		lastDigit |= (Byte)(digit << 1);
		// STEP n = 7: Read the 4th Char in a 8-chars Subblock
		// Insert 1 bit, leave 4 bits, possibly trailing if no more Char
		if ((digit = (int)chars[charsOffset + 3] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		bytes[bytesOffset + 1] = (Byte)((digit >> 4) | lastDigit);
		lastDigit = (Byte)((digit & 15) << 4);
		if (charsLen == 4) {
			if (lastDigit != 0) return nil; // non-canonical end
			break; // discard the 4 trailing null bits
		}
		// STEP n = 4: Read the 5th Char in a 8-Chars subblock
		// Insert 4 bits, leave 1 bit, possibly trailing if no more Char
		if ((digit = (int)chars[charsOffset + 4] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		bytes[bytesOffset + 2] = (Byte)((digit >> 1) | lastDigit);
		lastDigit = (Byte)((digit & 1) << 7);
		if (charsLen == 5) {
			if (lastDigit != 0) return nil; // non-canonical end
			break; // discard the 1 trailing null bit
		}
		// STEP n = 1: Read the 6th Char in a 8-Chars subblock
		// Leave 6 bits, asserting there's another encoding Char
		if ((digit = (int)chars[charsOffset + 5] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		lastDigit |= (Byte)(digit << 2);
		// STEP n = 6: Read the 7th Char in a 8-Chars subblock
		// Insert 2 bits, leave 3 bits, possibly trailing if no more Char
		if ((digit = (int)chars[charsOffset + 6] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		bytes[bytesOffset + 3] = (Byte)((digit >> 3) | lastDigit);
		lastDigit = (Byte)((digit & 7) << 5);
		if (charsLen == 7) {
			if (lastDigit != 0) return nil; // non-canonical end
			break; // discard the 3 trailing null bits
		}
		// STEP n = 3: Read the 8th Char in a 8-Chars subblock
		// Insert 5 bits, leave 0 bit, next encoding Char may not exist
		if ((digit = (int)chars[charsOffset + 7] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		bytes[bytesOffset + 4] = (Byte)(digit | lastDigit);
		//// This point is always reached for chars.length multiple of 8
		charsOffset += 8;
		bytesOffset += 5;
		charsLen -= 8;
	}
	// On loop exit, discard the n trailing null bits
	return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

- (NSString *) base32String
{
	/* Lookup table used to canonically encode() groups of data bits */
	static char canonicalChars[] =
	{	'A','B','C','D','E','F','G','H','I','J','K','L','M' // 00..12
		,'N','O','P','Q','R','S','T','U','V','W','X','Y','Z' // 13..25
		,'2','3','4','5','6','7'                             // 26..31
	};
	const Byte *bytes = [self bytes];
	int bytesOffset = 0, bytesLen = (int)[self length];
	int charsOffset = 0, charsLen = ((bytesLen << 3) + 4) / 5;
	char chars[charsLen];
	while (bytesLen != 0) {
		int digit, lastDigit;
		// INVARIANTS FOR EACH STEP n in [0..5[; digit in [0..31[;
		// The remaining n bits are already aligned on top positions
		// of the 5 least bits of digit, the other bits are 0.
		////// STEP n = 0: insert new 5 bits, leave 3 bits
		digit = bytes[bytesOffset] & 255;
		chars[charsOffset] = canonicalChars[digit >> 3];
		lastDigit = (digit & 7) << 2;
		if (bytesLen == 1) { // put the last 3 bits
			chars[charsOffset + 1] = canonicalChars[lastDigit];
			break;
		}
		////// STEP n = 3: insert 2 new bits, then 5 bits, leave 1 bit
		digit = bytes[bytesOffset + 1] & 255;
		chars[charsOffset + 1] = canonicalChars[(digit >> 6) | lastDigit];
		chars[charsOffset + 2] = canonicalChars[(digit >> 1) & 31];
		lastDigit = (digit & 1) << 4;
		if (bytesLen == 2) { // put the last 1 bit
			chars[charsOffset + 3] = canonicalChars[lastDigit];
			break;
		}
		////// STEP n = 1: insert 4 new bits, leave 4 bit
		digit = bytes[bytesOffset + 2] & 255;
		chars[charsOffset + 3] = canonicalChars[(digit >> 4) | lastDigit];
		lastDigit = (digit & 15) << 1;
		if (bytesLen == 3) { // put the last 1 bits
			chars[charsOffset + 4] = canonicalChars[lastDigit];
			break;
		}
		////// STEP n = 4: insert 1 new bit, then 5 bits, leave 2 bits
		digit = bytes[bytesOffset + 3] & 255;
		chars[charsOffset + 4] = canonicalChars[(digit >> 7) | lastDigit];
		chars[charsOffset + 5] = canonicalChars[(digit >> 2) & 31];
		lastDigit = (digit & 3) << 3;
		if (bytesLen == 4) { // put the last 2 bits
			chars[charsOffset + 6] = canonicalChars[lastDigit];
			break;
		}
		////// STEP n = 2: insert 3 new bits, then 5 bits, leave 0 bit
		digit = bytes[bytesOffset + 4] & 255;
		chars[charsOffset + 6] = canonicalChars[(digit >> 5) | lastDigit];
		chars[charsOffset + 7] = canonicalChars[digit & 31];
		//// This point is always reached for bytes.length multiple of 5
		bytesOffset += 5;
		charsOffset += 8;
		bytesLen -= 5;
	}
    return [NSString stringWithCString:chars encoding:NSUTF8StringEncoding];
    //	return [NSString stringWithCString:chars length:sizeof(chars)];
}

#define FinishBlock(X)  (*code_ptr = (X),   code_ptr = dst++,   code = 0x01)

- (NSData *) encodeCOBS
{
	if ([self length] == 0) return self;
    
	NSMutableData *encoded = [NSMutableData dataWithLength:([self length] + [self length] / 254 + 1)];
	unsigned char *dst = [encoded mutableBytes];
	const unsigned char *ptr = [self bytes];
	unsigned long length = [self length];
	const unsigned char *end = ptr + length;
	unsigned char *code_ptr = dst++;
	unsigned char code = 0x01;
	while (ptr < end)
	{
		if (*ptr == 0) FinishBlock(code);
		else
		{
			*dst++ = *ptr;
			code++;
			if (code == 0xFF) FinishBlock(code);
		}
		ptr++;
	}
	FinishBlock(code);
    
	[encoded setLength:((Byte *)dst - (Byte *)[encoded mutableBytes])];
	return [NSData dataWithData:encoded];
}

- (NSData *) decodeCOBS
{
	if ([self length] == 0) return self;
    
	const Byte *ptr = [self bytes];
	unsigned length = (unsigned)[self length];
	NSMutableData *decoded = [NSMutableData dataWithLength:length];
	Byte *dst = [decoded mutableBytes];
	Byte *basedst = dst;
    
	const unsigned char *end = ptr + length;
	while (ptr < end)
	{
		int i, code = *ptr++;
		for (i=1; i<code; i++) *dst++ = *ptr++;
		if (code < 0xFF) *dst++ = 0;
	}
    
	[decoded setLength:(dst - basedst)];
	return [NSData dataWithData:decoded];
}

- (BOOL)bytesEqual:(NSData*)data {
    BOOL ret = NO;
    if (self == nil && data == nil) {
        ret = YES;
    } else if (self != nil && data != nil) {
        if (data.length != data.length) {
            ret = NO;
        } else {
            if (strcmp(self.bytes, data.bytes) == 0) {
                ret = YES;
            } else {
                ret = NO;
            }
        }
    } else {
        ret = NO;
    }
    return ret;
}

- (NSString*)dataToHex {
    NSMutableString *hexString = [[NSMutableString alloc] init];
    uint8_t *bytes = (uint8_t*)self.bytes;
    int length = (int)self.length;
    for (int i = 0; i < length; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%02X", bytes[i]&0x00FF]];
    }
    return hexString;
}


- (NSData*)sha1 {
    if (!self) {
        return nil;
    }
    Byte *buffer;
    if (!(buffer = malloc(CC_SHA1_DIGEST_LENGTH))) {
        return nil;
    }
    CC_SHA1(self.bytes, (CC_LONG)self.length, buffer);
    
    NSData *output = nil;
    output = [NSData dataWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
    free(buffer);
    return output;
}

//int转化为NSData
+(NSData *)intToBytes:(long int)value{
    NSData *result;
    Byte byte[4];
    unsigned long int uintValue = (unsigned long int)value;
    for (int i=0; i<4; i++) {
        int offest = (4 - 1 -i)*8;
        byte[i] = (Byte)((uintValue >> offest)&0xff);
    }
    result = [NSData dataWithBytes:byte length:4];
    return result;
}
@end

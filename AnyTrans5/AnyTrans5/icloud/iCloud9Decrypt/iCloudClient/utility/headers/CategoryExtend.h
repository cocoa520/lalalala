//
//  CategoryExtend.h
//
//  Created by Pallas on 3/19/15.
//  Copyright (c) 2015 Pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Appkit/Appkit.h>
#import <objc/runtime.h>

union {
    char    c[1];
    int8_t int8;
} sint_8;

union {
    char    c[1];
    UInt8 uint8;
} uint_8;

union {
    char    c[2];
    short short16;
} short_16;

union {
    char    c[2];
    ushort ushort16;
} ushort_16;

union {
    char    c[4];
    int32_t int32;
} sint_32;

union {
    char    c[4];
    uint32  uint32;
} uint_32;

union {
    char    c[8];
    int64_t int64;
} sint_64;

union {
    char    c[8];
    uint64_t uint64;
} uint_64;

union {
    char    c[8];
    long long64;
} slong_64;

union {
    char    c[8];
    unsigned long ulong64;
} ulong_64;

union {
    char   c[8];
    double double64;
} double_64;

union {
    char    c[4];
    float float32;
} float_32;

typedef enum {
    UNKNOWN = 'unkn',
    ISBLOCK = 'blck',
    ISCHAR = 'char',
    ISDIR = 'dire',
    ISFIFO = 'fifo',
    ISREG = 'regu',
    ISLINK = 'link',
    ISSOCK = 'sock'
} PATHTYPE;

typedef enum FileAccess {
    OpenRead = O_RDONLY,
    OpenWrite = O_WRONLY,
    OpenReadWrite = O_RDWR,
    OpenAccmode = O_ACCMODE
} FileAccessEnum;

typedef enum SeekOrigin {
    Begin = 0,
    Current = 1,
    End = 2
} SeekOriginEnum;

@interface Base64Codec : NSObject
+(NSData *)dataFromBase64String:(NSString *)base64String;
+(NSString *)base64StringFromData:(NSData *)data;

@end

@interface NSObject (ExtendTool)
- (NSData*)jsonString;
+ (void)checkNotNull:(id)object withName:(NSString*)name;

@end

@interface BitConverter : NSObject

// 若处理器是Big_Endian的，则返回NO；若是Little_Endian的，则返回YES。
+ (BOOL)isLitte_Endian;
// 将字符串翻转，返回的内容需要进行free操作
+ (Byte*)reverseBytes:(Byte*)inArray offset:(int)offset count:(int)count;

@end

@interface BigEndianBitConverter : BitConverter

+ (int8_t)bigEndianToInt8:(Byte *)inArray byteLength:(int)byteLength;
+ (uint8_t)bigEndianToUInt8:(Byte *)inArray byteLength:(int)byteLength;
+ (int16_t)bigEndianToInt16:(Byte *)inArray byteLength:(int)byteLength;
+ (uint16_t)bigEndianToUInt16:(Byte *)inArray byteLength:(int)byteLength;
+ (int32_t)bigEndianToInt32:(Byte *)inArray byteLength:(int)byteLength;
+ (uint32_t)bigEndianToUInt32:(Byte *)inArray byteLength:(int)byteLength;
+ (int64_t)bigEndianToInt64:(Byte *)inArray byteLength:(int)byteLength;
+ (uint64_t)bigEndianToUInt64:(Byte *)inArray byteLength:(int)byteLength;
+ (long)bigEndianToLong64:(Byte *)inArray byteLength:(int)byteLength;
+ (unsigned long)bigEndianToULong64:(Byte *)inArray byteLength:(int)byteLength;
+ (double)bigEndianToDouble64:(Byte *)inArray byteLength:(int)byteLength;
+ (float)bigEndianToFloat32:(Byte *)inArray byteLength:(int)byteLength;
+ (NSMutableData*)bigEndianBytes:(Byte *)inArray byteLength:(int)byteLength;

@end

@interface LittleEndianBitConverter : BitConverter

+ (int8_t)littleEndianToInt8:(Byte *)inArray byteLength:(int)byteLength;
+ (uint8_t)littleEndianToUInt8:(Byte *)inArray byteLength:(int)byteLength;
+ (int16_t)littleEndianToInt16:(Byte *)inArray byteLength:(int)byteLength;
+ (uint16_t)littleEndianToUInt16:(Byte *)inArray byteLength:(int)byteLength;
+ (int32_t)littleEndianToInt32:(Byte *)inArray byteLength:(int)byteLength;
+ (uint32_t)littleEndianToUInt32:(Byte *)inArray byteLength:(int)byteLength;
+ (int64_t)littleEndianToInt64:(Byte *)inArray byteLength:(int)byteLength;
+ (uint64_t)littleEndianToUInt64:(Byte *)inArray byteLength:(int)byteLength;
+ (long)littleEndianToLong64:(Byte *)inArray byteLength:(int)byteLength;
+ (unsigned long)littleEndianToULong64:(Byte *)inArray byteLength:(int)byteLength;
+ (double)littleEndianToDouble64:(Byte *)inArray byteLength:(int)byteLength;
+ (float)littleEndianToFloat32:(Byte *)inArray byteLength:(int)byteLength;
+ (NSMutableData*)littleEndianBytes:(Byte *)inArray byteLength:(int)byteLength;

@end

@interface NSNumber (ExtendTool)

- (NSString *)binaryString;

@end

@interface NSString (ExtendTool)

+ (NSString*)getAppSupportPath;
- (NSString*)getParentDirectory;
- (NSMutableData*)hexToBytes;
+ (NSString*)dataToHex:(NSData*)data;
+ (NSString*)bytesToHex:(uint8_t*)bytes length:(int)length;
+ (NSString*)intToHex:(int)intValue;
+ (NSString*)decimalTOBinary:(int)intValue backLength:(int)length;
+ (NSString*)getBinaryByhex:(NSString*)hex;
+ (BOOL)isNilOrEmpty:(NSString*)string;
+ (NSString*)generateGUID;
- (NSString*)stringOfIndex:(int)index;
- (BOOL)isGreaterThan:(NSString*)verStr;
- (BOOL)isGreaterThanOrEqual:(NSString*)verStr;
- (BOOL)isLessThan:(NSString*)verStr;
- (BOOL)isLessThanOrEqual:(NSString*)verStr;
- (BOOL)isMajorEqual:(NSString*)verStr;
- (BOOL)contains:(NSString *)value;
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options;
- (BOOL)containsString:(NSString *)string;
- (BOOL)startWithString:(NSString *)string options:(NSStringCompareOptions)options;
- (BOOL)startWithString:(NSString *)string;
- (NSRange)rangeOfString:(NSString*)subString atOccurrence:(int)occurrence;
- (PATHTYPE)typeOfPath;
- (NSData*)sha1;
- (NSString*)md5;
- (NSString*)sha1Hex;
+ (NSString*)MD5FromData:(NSData *)data;
- (NSString*)AES256EncryptWithKey:(NSString *)key;
- (NSString*)AES256DecryptWithKey:(NSString *)key;
- (NSData*)toDataByEncoding:(NSStringEncoding)encoding;
- (NSString*)base64String;
+ (NSString*)stringFromBase64String:(NSString*)base64String;
- (BOOL)isAlias;
- (id)jsonValue;

@end

@interface NSData (ExtendTool)

- (BOOL)bytesEqual:(NSData*)data;
- (NSData*)sha1;
- (NSMutableData*)sha256;
+ (NSData*)MD5Digest:(NSData*)input;
- (NSData*)MD5Digest;
- (NSDictionary*)dataToDictionary;
- (NSMutableDictionary*)dataToMutableDictionary;
- (NSArray *)dataToArray;
- (NSMutableArray *)dataToMutableArray;
- (NSString*)dataToHex;
+ (NSData*)dataWithHexString:(NSString*)hexString;
- (NSData*)AES256EncryptWithKey:(NSString *)key;
- (NSData*)AES256DecryptWithKey:(NSString *)key;
- (NSMutableData*)AES128EncryptWithKey:(NSString*)key iv:(NSString*)iv;
- (NSMutableData*)AES128DecryptWithKey:(NSString*)key iv:(NSString*)iv;
- (NSMutableData*)AES256EncryptWithKey:(Byte*)key withIV:(Byte*)iv;
- (NSMutableData*)AES256DecryptWithKey:(Byte*)key withIV:(Byte*)iv withPadding:(BOOL)padding;
- (NSMutableData*)aes_wrap_key:(Byte*)kek withKekLength:(int)kekLength;
- (NSMutableData*)aes_unwrap_key:(Byte*)kek withKekLength:(int)kekLength;
+ (NSData*)dataWithBase64String:(NSString*)base64String;
+ (NSData*)dataWithBase64EncodedString:(NSString *)string;
- (id)initWithBase64EncodedString:(NSString *)string;
- (NSString*)base64String;
- (NSString*)base64Encoding;
- (NSString*)base64EncodingWithLineLength:(NSUInteger)lineLength;
- (BOOL)hasPrefixBytes:(const void *)prefix length:(NSUInteger)length;
- (BOOL)hasSuffixBytes:(const void *)suffix length:(NSUInteger)length;
- (NSString*)detectImageSuffix;
- (NSRange)rangeOfNullTerminatedBytesFrom:(int)start;
//+ (NSData*)dataWithBase32String:(NSString *)encoded;
//- (NSString*)base32String;
//- (NSData*)encodeCOBS;
//- (NSData*)decodeCOBS;
//- (NSData*)zlibInflate;
//- (NSData*)zlibDeflate;
//- (NSData*)gzipData;
//- (NSData*)ungzipData;
- (id)jsonDataToArrayOrNSDictionary;

@end

@interface NSMutableData (ExtendTool)

@property (nonatomic, readwrite, assign) int fixedSize;
@property (nonatomic, readwrite, assign) int limit;
@property (nonatomic, readwrite, assign) int mark;
@property (nonatomic, readwrite, assign) int position;

- (id)initWithSize:(int)size;
- (int)copyFromIndex:(int)index withSource:(NSMutableData*)source withSourceIndex:(int)sourceIndex withLength:(int)length;
- (int)clearFromIndex:(int)index withLength:(int)length;
- (int32_t)toInt32WithStartIndex:(int)startIndex;
- (int64_t)toInt64WithStartIndex:(int)startIndex;
- (BOOL)checkIndex:(int)index;
- (BOOL)checkIndex:(int)index withSizeOfType:(int)sizeOfType;
- (BOOL)checkGetBounds:(int)bytesPerElement withLength:(int)length withOffset:(int)offset withCount:(int)count;
- (BOOL)checkPutBounds:(int)bytesPerElement withLength:(int)length withOffset:(int)offset withCount:(int)count;
- (BOOL)checkStartEndRemaining:(int)start withEnd:(int)end;
- (void)clear;
- (void)flip;
- (BOOL)hasRemaining;
- (void)markPosition;
- (long)remaining;
- (void)reset;
- (void)rewind;
+ (NSMutableData*)nextBytes:(int)bitCount;

@end

typedef enum ByteOrder {
    BIG_ENDIAN_EX = 'bige',
    LITTLE_ENDIAN_EX = 'ltle'
} ByteOrderEnum;

@interface DataStream : NSObject  {
@private
    NSMutableData *                     _stream;
    ByteOrderEnum                       _order;
}

@property (nonatomic, readwrite, assign) ByteOrderEnum order;

- (id)initWithAllocateSize:(int)allocateSize;
- (id)initFromData:(NSMutableData*)data;

+ (DataStream*)wrapWithData:(NSMutableData*)data;
+ (DataStream*)wrapWithData:(NSMutableData*)data withStart:(int)start withByteCount:(int)byteCount;

- (NSMutableData*)toMutableData;

- (int)position;
- (void)setPosition:(int)pos;
- (int)remaining;
- (BOOL)hasRemaining;
- (int)limit;
- (void)setLimit:(int)limit;
- (int)mark;
- (void)setMark:(int)mark;
- (void)rewind;

- (Byte)get;
- (int)getWithMutableData:(NSMutableData*)dst;
- (int)getWithMutableData:(NSMutableData*)dst withDstOffset:(int)dstOffset withByteCount:(int)byteCount;
- (int)getWithMutableData:(NSMutableData*)dst withFromIndex:(int)index withByteCount:(int)byteCount;
- (int)getWithMutableData:(NSMutableData*)dst withDstOffset:(int)dstOffset withFromIndex:(int)index withByteCount:(int)byteCount;
- (Byte)getFromIndex:(int)index;
- (char)getChar;
- (char)getChar:(int)index;
- (double)getDouble;
- (double)getDouble:(int)index;
- (float)getFloat;
- (float)getFloat:(int)index;
- (int)getInt;
- (int)getInt:(int)index;
- (long)getLong;
- (long)getLong:(int)index;
- (short)getShort;
- (short)getShort:(int)index;

- (BOOL)put:(Byte)b;
- (BOOL)putByte:(int)index withB:(Byte)b;
- (BOOL)putWithData:(NSData*)src;
- (BOOL)putWithData:(NSData*)src withSrcOffset:(int)srcOffset withByteCount:(int)byteCount;
- (BOOL)putWithDataStream:(DataStream*)src;
- (BOOL)putChar:(char)value;
- (BOOL)putChar:(int)index withValue:(char)value;
- (BOOL)putDouble:(double)value;
- (BOOL)putDouble:(int)index withValue:(double)value;
- (BOOL)putFloat:(float)value;
- (BOOL)putFloat:(int)index withValue:(float)value;
- (BOOL)putInt:(int)value;
- (BOOL)putInt:(int)index withValue:(int)value;
- (BOOL)putLong:(long)value;
- (BOOL)putLong:(int)index withValue:(long)value;
- (BOOL)putShort:(short)value;
- (BOOL)putShort:(int)index withValue:(short)value;

@end

@interface NSDictionary (ExtendTool)

- (NSMutableDictionary *)mutableDeepCopy;
- (NSData*)dictionaryToData;
- (NSString*)toJson;

@end

@interface NSMutableDictionary (ExtendTool)

- (NSData*)mutableDictionaryToData;

@end

@interface NSDate (ExtendTool)

+ (NSDate*)UtcSinceDate;
- (NSDate*)UtcToLocalDate;
- (NSDate*)localToUtcDate;
- (NSDate*)toLocalTime;
- (NSDate*)toGlobalTime;
+ (NSDate*)getDateTimeFromTimeStamp2001:(double)timeStamp;

@end

@interface NSArray (ExtendTool)

- (NSMutableData*)fillToNSMutableData;
- (NSMutableArray*)clone;

@end

@interface NSMutableArray (ExtendTool)

@property (nonatomic, readwrite, assign) int fixedSize;

- (id)initWithSize:(int)size;

- (int)copyFromIndex:(int)index withSource:(NSMutableArray*)source withSourceIndex:(int)sourceIndex withLength:(int)length;
- (int)clearFromIndex:(int)index withLength:(int)length;
- (NSMutableData*)fillToNSMutableData;
- (NSMutableArray*)clone;

@end

@interface NSFileHandle (ExtendTool)

@property (nonatomic, readonly, assign) FileAccessEnum accessMode;

- (id)initWithPath:(NSString*)path withAccess:(FileAccessEnum)access;
+ (id)openPath:(NSString*)path withAccess:(FileAccessEnum)access;

- (void)flush;
- (uint64_t)seek:(uint64_t)offset withOrigin:(SeekOriginEnum)origin;

- (BOOL)canRead;
- (BOOL)canSeek;
- (BOOL)canWrite;

- (uint64_t)length;
- (void)setLength:(uint64_t)value;
- (uint64_t)position;
- (void)setPosition:(uint64_t)position;
- (uint64_t)available;

- (int)readByte;
- (int)read:(NSMutableData*)buffer withOffset:(int)offset withCount:(int)count;
- (void)writeByte:(Byte)value;
- (void)write:(NSMutableData*)buffer withOffset:(int)offset withCount:(int)count;

- (long)transferTo:(NSFileHandle*)destination;

@end

@interface Stream : NSObject

- (int)read;
- (int)read:(NSMutableData*)buffer;
- (int)read:(NSMutableData*)buffer withOff:(int)offset withLen:(int)count;
+ (int)readFully:(Stream*)inStream withBuf:(NSMutableData*)buf;
+ (int)readFully:(Stream*)inStream withBuf:(NSMutableData*)buf withOffset:(int)offset withLength:(int)length;
- (void)writeWithByte:(int)b;
- (void)write:(NSMutableData*)buffer;
- (void)write:(NSMutableData*)buffer withOffset:(int)offset withCount:(int)count;
- (int64_t)skip:(int64_t)n;
- (int)available;
- (void)mark:(int)readlimit;
- (void)reset;
- (BOOL)markSupported;
- (void)close;

@end

@interface MemoryStreamEx : Stream {
@private
    NSMutableData               *_stream;
    int                                     _offsetInStream;
}

+ (id)memoryStreamEx;
- (id)initWithData:(NSMutableData*)data;
- (NSMutableData*)availableData;
- (int)seek:(int)offset withOrigin:(SeekOriginEnum)origin;
- (int)length;
- (void)setLength:(int)value;
- (int)position;
- (void)setPosition:(int)position;
- (long)remaining;
- (BOOL)canRead;
- (BOOL)canSeek;
- (BOOL)canWrite;

@end

@interface NSColor (ExtendTool)

- (CGColorRef)toCGColor;
+ (NSColor*)colorFromCGColor:(CGColorRef)CGColor;

@end

typedef enum {
    IMBImageResizeCrop,
    IMBImageResizeCropStart,
    IMBImageResizeCropEnd,
    IMBImageResizeScale
} IMBImageResizingMethod;

@interface NSImage (ExtendTool)

- (void)drawInRect:(NSRect)dstRect operation:(NSCompositingOperation)op fraction:(float)delta method:(IMBImageResizingMethod)resizeMethod;
- (NSImage *)imageToFitSize:(NSSize)size method:(IMBImageResizingMethod)resizeMethod;
- (NSImage *)imageToFitRect:(NSRect)rect method:(IMBImageResizingMethod)resizeMethod;
- (NSImage *)imageCroppedToFitSize:(NSSize)size;
- (NSImage *)imageScaledToFitSize:(NSSize)size;
- (NSImage *) imageFromRect: (NSRect) rect;

@end
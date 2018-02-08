//
//  HexEncoder.m
//  
//
//  Created by Pallas on 5/30/16.
//
//  Complete

#import "HexEncoder.h"
#import "CategoryExtend.h"
#import "Arrays.h"

@interface HexEncoder ()

@property (nonatomic, readwrite, retain) NSMutableData *encodingTable;
@property (nonatomic, readwrite, retain) NSMutableData *decodingTable;

@end

@implementation HexEncoder
@synthesize encodingTable = _encodingTable;
@synthesize decodingTable = _decodingTable;

- (id)init {
    if (self = [super init]) {
        NSMutableData *tmpData = [@[@((Byte)'0'), @((Byte)'1'), @((Byte)'2'), @((Byte)'3'), @((Byte)'4'), @((Byte)'5'), @((Byte)'6'), @((Byte)'7'), @((Byte)'8'), @((Byte)'9'), @((Byte)'a'), @((Byte)'b'), @((Byte)'c'), @((Byte)'d'), @((Byte)'e'), @((Byte)'f')] fillToNSMutableData];
        [self setEncodingTable:tmpData];
        tmpData = [[NSMutableData alloc] initWithSize:128];
        [self setDecodingTable:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        [self initialiseDecodingTable];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_encodingTable != nil) [_encodingTable release]; _encodingTable = nil;
    if (_decodingTable != nil) [_decodingTable release]; _decodingTable = nil;
    [super dealloc];
#endif
}

- (void)initialiseDecodingTable {
    [Arrays fillWithByteArray:self.decodingTable withB:((Byte)0xff)];
    for (int i = 0; i < self.encodingTable.length; i++){
        ((Byte*)(self.decodingTable.bytes))[((Byte*)(self.encodingTable.bytes))[i]] = (Byte)i;
    }
    
    ((Byte*)(self.decodingTable.bytes))['A'] = ((Byte*)(self.decodingTable.bytes))['a'];
    ((Byte*)(self.decodingTable.bytes))['B'] = ((Byte*)(self.decodingTable.bytes))['b'];
    ((Byte*)(self.decodingTable.bytes))['C'] = ((Byte*)(self.decodingTable.bytes))['c'];
    ((Byte*)(self.decodingTable.bytes))['D'] = ((Byte*)(self.decodingTable.bytes))['d'];
    ((Byte*)(self.decodingTable.bytes))['E'] = ((Byte*)(self.decodingTable.bytes))['e'];
    ((Byte*)(self.decodingTable.bytes))['F'] = ((Byte*)(self.decodingTable.bytes))['f'];
}

/**
 * encode the input data producing a Hex output stream.
 *
 * @return the number of bytes produced.
 */
- (int)encode:(NSMutableData*)data withOff:(int)off withLength:(int)length withOutStream:(DataStream*)outStream {
    for (int i = off; i < (off + length); i++) {
        int v = ((Byte*)(data.bytes))[i];
        
        [outStream put:(((Byte*)(self.encodingTable.bytes))[(v >> 4)])];
        [outStream put:(((Byte*)(self.encodingTable.bytes))[(v & 0xf)])];
    }
    
    return length * 2;
}

+ (BOOL)ignore:(unichar)c {
    return c == '\n' || c == '\r' || c == '\t' || c == ' ';
}

/**
 * decode the Hex encoded byte data writing it to the given output stream,
 * whitespace characters will be ignored.
 *
 * @return the number of bytes produced.
 */
- (int)decode:(NSMutableData*)data withOff:(int)off withLength:(int)length withOutStream:(DataStream*)outStream {
    Byte b1, b2;
    int outLen = 0;
    int end = off + length;
    
    while (end > off) {
        if (![HexEncoder ignore:(unichar)(((Byte*)(data.bytes))[end - 1])]) {
            break;
        }
        
        end--;
    }
    
    int i = off;
    while (i < end) {
        while (i < end && [HexEncoder ignore:(ushort)(((Byte*)(data.bytes))[i])]) {
            i++;
        }
        
        b1 = ((Byte*)(self.decodingTable.bytes))[((Byte*)(data.bytes))[i++]];
        
        while (i < end && [HexEncoder ignore:(ushort)(((Byte*)(data.bytes))[i])]) {
            i++;
        }
        
        b2 = ((Byte*)(self.decodingTable.bytes))[((Byte*)(data.bytes))[i++]];
        
        if ((b1 | b2) >= 0x80) {
            @throw [NSException exceptionWithName:@"IO" reason:@"invalid characters encountered in Hex data" userInfo:nil];
        }
        
        [outStream put:(Byte)((b1 << 4) | b2)];
        
        outLen++;
    }
    
    return outLen;
}

/**
 * decode the Hex encoded string data writing it to the given output stream,
 * whitespace characters will be ignored.
 *
 * @return the number of bytes produced.
 */
- (int)decodeString:(NSString*)data withOutStream:(DataStream *)outStream {
    Byte    b1, b2;
    int     length = 0;
    
    int     end = (int)(data.length);
    
    while (end > 0) {
        if (![HexEncoder ignore:[data characterAtIndex:(end - 1)]]) {
            break;
        }
        end--;
    }
    
    int i = 0;
    while (i < end) {
        while (i < end && [HexEncoder ignore:[data characterAtIndex:i]]) {
            i++;
        }
        
        b1 = ((Byte*)(self.decodingTable.bytes))[[data characterAtIndex:(i++)]];
        
        while (i < end && [HexEncoder ignore:[data characterAtIndex:i]]) {
            i++;
        }
        
        b2 = ((Byte*)(self.decodingTable.bytes))[[data characterAtIndex:(i++)]];
        
        if ((b1 | b2) >= 0x80) {
            @throw [NSException exceptionWithName:@"IO" reason:@"invalid characters encountered in Hex data" userInfo:nil];
        }
        
        [outStream put:(Byte)((b1 << 4) | b2)];
        
        length++;
    }
    
    return length;
}

@end

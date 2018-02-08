//
//  StringsEx.m
//  
//
//  Created by Pallas on 5/30/16.
//
//  Complete

#import "StringsEx.h"
#import "CategoryExtend.h"

@implementation StringsEx

+ (BOOL)isOneOf:(NSString*)s withCandidates:(NSString*)candidates,... {
    //定义一个指向个数可变的参数列表指针;
    va_list argList;
    id arg;
    if (candidates) {
        //va_start 得到第一个可变参数地址
        va_start(argList, candidates);
        if (s == candidates) {
            va_end(argList);     //置空
            return YES;
        }
        //va_arg 指向下一个参数地址
        while((arg = va_arg(argList, id))) {
            if (arg){
                if (s == arg) {
                    va_end(argList);     //置空
                    return YES;
                }
            }  
        }  
        //置空  
        va_end(argList);
    }
    return NO;
}

+ (NSString*)fromByteArray:(NSData*)bs {
    int size = (int)(bs.length);
    NSMutableString *cs = [[[NSMutableString alloc] initWithCapacity:size] autorelease];
    for (int i = 0; i < size; ++i) {
        [cs appendFormat:@"%C", (unichar)(((Byte*)(bs.bytes))[i])];
    }
    return cs;
}

// NSMutableArray == unichar[]
+ (NSMutableData*)toByteArrayWithUnicharArray:(NSMutableArray*)cs {
    NSMutableData *bs = [[[NSMutableData alloc] initWithSize:(int)(cs.count)] autorelease];
    for (int i = 0; i < bs.length; ++i) {
        ((Byte*)(bs.bytes))[i] = [cs[i] unsignedCharValue];
    }
    return bs;
}

+ (NSMutableData*)toByteArrayWithString:(NSString*)s {
    NSMutableData *bs = [[[NSMutableData alloc] initWithSize:(int)[s length]] autorelease];
    for (int i = 0; i < bs.length; ++i) {
        ((Byte*)(bs.bytes))[i] = (Byte)[s characterAtIndex:i];
    }
    return bs;
}

+ (NSString*)fromAsciiByteArray:(NSData*)bytes {
    return [[[NSString alloc] initWithData:bytes encoding:NSASCIIStringEncoding] autorelease];
}

// NSMutableArray == unichar[]
+ (NSMutableData*)toAsciiByteArrayWithUnicharArray:(NSMutableArray*)cs {
    int size = (int)(cs.count);
    NSMutableString *str = [[[NSMutableString alloc] initWithCapacity:size] autorelease];
    for (int i = 0; i < size; ++i) {
        [str appendFormat:@"%C", [cs[i] unsignedShortValue]];
    }
    return [[[str dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] mutableCopy] autorelease];
}

+ (NSMutableData*)toAsciiByteArrayWithString:(NSString*)s {
    return [[[s dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] mutableCopy] autorelease];
}

+ (NSString*)fromUtf8ByteArray:(NSData*)bytes {
    return [[[NSString alloc] initWithData:bytes encoding:NSUTF8StringEncoding] autorelease];
}

// NSMutableArray == unichar[]
+ (NSMutableData*)toUtf8ByteArrayWithUnicharArray:(NSMutableArray*)cs {
    int size = (int)(cs.count);
    NSMutableString *str = [[[NSMutableString alloc] initWithCapacity:size] autorelease];
    for (int i = 0; i < size; ++i) {
        [str appendFormat:@"%C", [cs[i] unsignedShortValue]];
    }
    return [[[str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] mutableCopy] autorelease];
}

+ (NSMutableData*)toUtf8ByteArrayWithString:(NSString*)s {
    return [[[s dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] mutableCopy] autorelease];
}

@end

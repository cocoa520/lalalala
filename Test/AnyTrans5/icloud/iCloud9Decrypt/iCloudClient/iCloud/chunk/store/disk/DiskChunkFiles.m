//
//  DiskChunkFiles.m
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "DiskChunkFiles.h"
#import "CategoryExtend.h"
#import "Hex.h"

@implementation DiskChunkFiles

static int DiskChunkFiles_SUBSPLIT = 3;

+ (NSString*)filename:(NSData*)chunkChecksum {
    return [DiskChunkFiles filename:chunkChecksum withSubSplit:DiskChunkFiles_SUBSPLIT];
}

+ (NSString*)filename:(NSData*)chunkChecksum withSubSplit:(int)subSplit {
    NSString *filename = [NSString dataToHex:chunkChecksum];
    
    return filename.length < subSplit ? filename : [DiskChunkFiles subSplit:filename withSubSplit:subSplit];
}

+ (NSString*)subSplit:(NSString*)fileName withSubSplit:(int)subSplit {
    NSString *path = @"";
    for (int i = 0; i < subSplit; i++) {
        path = [path stringByAppendingPathComponent:[fileName substringWithRange:NSMakeRange(i, 1)]];
    }
    NSString *subPath = [path stringByAppendingPathComponent:[fileName substringFromIndex:subSplit]];
    
    return [DiskChunkFiles normalize:subPath];
}

+ (NSString*)normalize:(NSString*)filePath {
    if (filePath == nil || [filePath isEqualToString:@""]) {
        return @"";
    }
    
    NSArray *splits = [filePath componentsSeparatedByString:@"/"];
    NSString *newPath = @"";
    for (NSString *name in splits) {
        if ([name isEqualToString:@"."] || [name isEqualToString:@".."] || [name isEqualToString:@""]) {
            continue;
        }
        newPath = [newPath stringByAppendingPathComponent:[DiskChunkFiles replaceSpecialChar:name]];
    }
    return newPath;
}

+ (NSString*)replaceSpecialChar:(NSString*)validateString {
    if (![NSString isNilOrEmpty:validateString]) {
        validateString = [validateString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"/" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@":" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"*" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"?" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"<" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@">" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"|" withString:@""];
        validateString = [validateString stringByReplacingOccurrencesOfString:@"%" withString:@""];
    }
    return validateString;
}

@end

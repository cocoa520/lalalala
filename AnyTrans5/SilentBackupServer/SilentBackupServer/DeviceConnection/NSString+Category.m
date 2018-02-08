//
//  NSString+Category.m
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "NSString+Category.h"
#include <sys/stat.h>
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Category)
#pragma mark - 字符串比较
- (BOOL)isVersionAscending:(NSString*)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedAscending);
}

- (BOOL)isVersionAscendingEqual:(NSString*)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedAscending) || ([self compare:verStr options:NSNumericSearch] == NSOrderedSame);
}

- (BOOL)isVersionLessEqual:(NSString *)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedAscending) || ([self compare:verStr options:NSNumericSearch] == NSOrderedSame);
}

- (BOOL)isVersionLess:(NSString *)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedAscending);
}

- (BOOL)isVersionMajorEqual:(NSString *)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedDescending) || ([self compare:verStr options:NSNumericSearch] == NSOrderedSame);
}

- (BOOL)isVersionEqual:(NSString *)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return  ([self compare:verStr options:NSNumericSearch] == NSOrderedSame);
}

- (BOOL)isVersionMajor:(NSString *)verStr {
    if (verStr == nil || [verStr isEqualToString:@""]) {
        return NO;
    }
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedDescending);
}


- (BOOL)isNilOrEmpty {
    if (self == nil || [self isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isNilOrEmpty:(NSString*)string {
    BOOL ret = NO;
    if (string == nil || [string isEqualToString:@""]) {
        ret = YES;
    }
    return ret;
}

- (BOOL)contains:(NSString *)value {
    if (value == nil || [value isEqualToString:@""]) {
        return NO;
    }
    if ([self rangeOfString:value].location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

// stringByResolvingSymlinksAndAliases
//
// Tries to make a standardized, absolute path from the current string,
// resolving any aliases or symlinks in the path.
//
// returns the fully resolved path (if possible) or nil (if resolution fails)
//
- (NSString *)stringByResolvingSymlinksAndAliases
{
	//
	// Convert to a standardized absolute path.
	//
	NSString *path = [self stringByStandardizingPath];
	if (![path hasPrefix:@"/"])
	{
		return nil;
	}
    
	//
	// Break into components. First component ("/") needs no resolution, so
	// we only need to handle subsequent components.
	//
	NSArray *pathComponents = [path pathComponents];
	NSString *resolvedPath = [pathComponents objectAtIndex:0];
	pathComponents = [pathComponents
                      subarrayWithRange:NSMakeRange(1, [pathComponents count] - 1)];
    
	//
	// Process all remaining components.
	//
	for (NSString *component in pathComponents)
	{
		resolvedPath = [resolvedPath stringByAppendingPathComponent:component];
		resolvedPath = [resolvedPath stringByIterativelyResolvingSymlinkOrAlias];
		if (!resolvedPath)
		{
			return nil;
		}
	}
    
	return resolvedPath;
}

//
// stringByIterativelyResolvingSymlinkOrAlias
//
// Resolves the path where the final component could be a symlink and any
// component could be an alias.
//
// returns the resolved path
//
- (NSString *)stringByIterativelyResolvingSymlinkOrAlias
{
	NSString *path = self;
	NSString *aliasTarget = nil;
	struct stat fileInfo;
    
	//
	// Use lstat to determine if the file is a symlink
	//
	if (lstat([[NSFileManager defaultManager]
               fileSystemRepresentationWithPath:path], &fileInfo) < 0)
	{
		return nil;
	}
    
	//
	// While the file is a symlink or we can resolve aliases in the path,
	// keep resolving.
	//
	while (S_ISLNK(fileInfo.st_mode) ||
           (!S_ISDIR(fileInfo.st_mode) &&
			(aliasTarget = [path stringByConditionallyResolvingAlias]) != nil))
	{
		if (S_ISLNK(fileInfo.st_mode))
		{
			//
			// Resolve the symlink final component in the path
			//
			NSString *symlinkPath = [path stringByConditionallyResolvingSymlink];
			if (!symlinkPath)
			{
				return nil;
			}
			path = symlinkPath;
		}
		else
		{
			path = aliasTarget;
		}
        
		//
		// Use lstat to determine if the file is a symlink
		//
		if (lstat([[NSFileManager defaultManager]
                   fileSystemRepresentationWithPath:path], &fileInfo) < 0)
		{
			path = nil;
			continue;
		}
	}
    
	return path;
}

//
// stringByResolvingAlias
//
// Attempts to resolve the single alias at the end of the path.
//
// returns the resolved alias or self if path wasn't an alias or couldn't be
//	resolved.
//
- (NSString *)stringByResolvingAlias
{
	NSString *aliasTarget = [self stringByConditionallyResolvingAlias];
	if (aliasTarget)
	{
		return aliasTarget;
	}
	return self;
}

//
// stringByResolvingSymlink
//
// Attempts to resolve the single symlink at the end of the path.
//
// returns the resolved path or self if path wasn't a symlink or couldn't be
//	resolved.
//
- (NSString *)stringByResolvingSymlink
{
	NSString *symlinkTarget = [self stringByConditionallyResolvingSymlink];
	if (symlinkTarget)
	{
		return symlinkTarget;
	}
	return self;
}

//
// stringByConditionallyResolvingSymlink
//
// Attempt to resolve the symlink pointed to by the path.
//
// returns the resolved path (if it was a symlink and resolution is possible)
//	otherwise nil
//
- (NSString *)stringByConditionallyResolvingSymlink
{
	//
	// Resolve the symlink final component in the path
	//
	NSString *symlinkPath =
    [[NSFileManager defaultManager]
     destinationOfSymbolicLinkAtPath:self
     error:NULL];
	if (!symlinkPath)
	{
		return nil;
	}
	if (![symlinkPath hasPrefix:@"/"])
	{
		//
		// For relative path symlinks (common case), remove the
		// relative links
		//
		symlinkPath =
        [[self stringByDeletingLastPathComponent]
         stringByAppendingPathComponent:symlinkPath];
		symlinkPath = [symlinkPath stringByStandardizingPath];
	}
	return symlinkPath;
}

//
// stringByConditionallyResolvingAlias
//
// Attempt to resolve the alias pointed to by the path.
//
// returns the resolved path (if it was an alias and resolution is possible)
//	otherwise nil
//
- (NSString *)stringByConditionallyResolvingAlias
{
	NSString *resolvedPath = nil;
    
	CFURLRef url = CFURLCreateWithFileSystemPath
    (kCFAllocatorDefault, (CFStringRef)self, kCFURLPOSIXPathStyle, NO);
	if (url != NULL)
	{
		FSRef fsRef;
		if (CFURLGetFSRef(url, &fsRef))
		{
			Boolean targetIsFolder, wasAliased;
			OSErr err = FSResolveAliasFileWithMountFlags(
                                                         &fsRef, false, &targetIsFolder, &wasAliased, kResolveAliasFileNoUI);
			if ((err == noErr) && wasAliased)
			{
				CFURLRef resolvedUrl = CFURLCreateFromFSRef(kCFAllocatorDefault, &fsRef);
				if (resolvedUrl != NULL)
				{
					resolvedPath =
                    [(id)NSMakeCollectable(CFURLCopyFileSystemPath(resolvedUrl, kCFURLPOSIXPathStyle))
                     autorelease];
					CFRelease(resolvedUrl);
				}
			}
		}
		CFRelease(url);
	}
    
	return resolvedPath;
}

#pragma mark - md5
- (NSData*)sha1 {
    NSData *data = [self dataUsingEncoding:NSASCIIStringEncoding];
    Byte *buffer;
    if (!(buffer = malloc(CC_SHA1_DIGEST_LENGTH))) {
        return nil;
    }
    CC_SHA1(data.bytes, (CC_LONG)data.length, buffer);
    
    NSData *output = nil;
    output = [NSData dataWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
    free(buffer);
    return output;
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString *)MD5FromData:(NSData *)data
{
    unsigned char result[16];
    CC_MD5(data.bytes, (unsigned int)data.length, result);
    //    NSData *resultData = [NSData dataWithBytes:result length:16]; 其实这一步不需要的
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString*)generateGUID {
    NSString *guid = nil;
    CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
    guid = [NSString stringWithFormat:@"%@", (NSString *)CFUUIDCreateString(kCFAllocatorDefault, guidref)];
    CFRelease(guidref);
    return guid;
}

#pragma mark - ContainsString
- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

- (BOOL)startWithString:(NSString *)string
                options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound && rng.location == 0;
}

- (BOOL)startWithString:(NSString *)string {
    return [self startWithString:string options:0];
}

#pragma mark - 字符串与字节的转换
- (NSData*)hexToBytes {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+ (NSString*)stringToHex:(uint8_t*)bytes length:(int)length {
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (int i = 0; i < length; i++) {
        @autoreleasepool {
            [hexString appendString:[NSString stringWithFormat:@"%02x", bytes[i]&0x00FF]];
        }
    }
    return hexString;
}

- (NSData*)toDataByEncoding:(NSStringEncoding)encoding {
    NSData *data = [self dataUsingEncoding:encoding];
    return data;
}

- (NSRange)rangeOfString:(NSString*)subString atOccurrence:(int)occurrence {
	int currentOccurrence = 0;
	NSRange	rangeToSearchWithin = NSMakeRange(0, [self length]);
	while (YES) {
		currentOccurrence++;
		NSRange searchResult = [self rangeOfString:subString options:NSLiteralSearch range:rangeToSearchWithin];
		if (searchResult.location == NSNotFound) {
			return searchResult;
		}
		if (currentOccurrence == occurrence) {
			return searchResult;
		}
		int newLocationToStartAt = searchResult.location + searchResult.length;
		rangeToSearchWithin = NSMakeRange(newLocationToStartAt, self.length - newLocationToStartAt);
	}
}

- (NSString *)AES256EncryptWithKey:(NSString *)key
{
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [plainData AES256EncryptWithKey:key];
    NSString *encryptedString = [encryptedData base64Encoding];
    
    return encryptedString;
}


- (NSString *)AES256DecryptWithKey:(NSString *)key
{
    NSData *encryptedData = [[NSData alloc] initWithBase64Encoding:self];
    NSData *plainData = [encryptedData AES256DecryptWithKey:key];
    NSString *plainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    [encryptedData release];
    return [plainString autorelease];
}

@end

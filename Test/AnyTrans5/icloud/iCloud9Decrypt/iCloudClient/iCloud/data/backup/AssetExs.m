//
//  Assets.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import "AssetExs.h"
#import "AssetEx.h"

@interface AssetExs ()

@property (nonatomic, readwrite, retain) NSString *domain;
@property (nonatomic, readwrite, retain) NSArray *files;

@end

@implementation AssetExs
@synthesize domain = _domain;
@synthesize files = _files;

+ (NSMutableArray*)files:(NSArray *)assetsList filter:(NSPredicate*)filter {
    NSMutableArray *returnAry = [[NSMutableArray alloc] init];
    @autoreleasepool {
        if (filter == nil) {
            for (AssetExs *aes in assetsList) {
                NSMutableArray *tmpArray = [aes filess];
                if (tmpArray.count > 0) {
                    [returnAry addObjectsFromArray:tmpArray];
                }
            }
        } else {
            NSArray *filteredArray = [assetsList filteredArrayUsingPredicate:filter];
            if (filteredArray && filteredArray.count > 0) {
                for (AssetExs *aes in filteredArray) {
                    NSMutableArray *tmpArray = [aes filess];
                    if (tmpArray.count > 0) {
                        [returnAry addObjectsFromArray:tmpArray];
                    }
                }
            }
        }
    }
    return (returnAry ? [returnAry autorelease] : nil);
}

+ (NSMutableArray*)fileObj:(NSArray *)assetsList filter:(NSPredicate*)filter {
    NSMutableArray *returnAry = [[NSMutableArray alloc] init];
    @autoreleasepool {
        if (filter == nil) {
            for (AssetExs *aes in assetsList) {
                NSMutableArray *tmpArray = [aes filess];
                if (tmpArray.count > 0) {
                    [returnAry addObjectsFromArray:tmpArray];
                }
            }
        } else {
            NSArray *filteredArray = [assetsList filteredArrayUsingPredicate:filter];
            if (filteredArray && filteredArray.count > 0) {
                for (AssetExs *aes in filteredArray) {
                    [returnAry addObject:aes];
                }
            }
        }
    }
    return (returnAry ? [returnAry autorelease] : nil);
}

+ (BOOL)isNonEmpty:(NSString *)asset {
    NSArray *split = [asset componentsSeparatedByString:@":"];
    if ([split count] < 4) {
        return YES;
    }
    NSString *x = [split objectAtIndex:3];
    if ([x isEqualToString:@"D"]) {
        return NO;
    }
    
    @try {
        int size = [x intValue];
        return size != 0;
    }
    @catch (NSException *exception) {
        return NO;
    }
}

+ (int)size:(NSString *)asset {
    NSArray *split = [asset componentsSeparatedByString:@":"];
    if ([split count] < 4) {
        return 0;
    }
    
    @try {
        return [[split objectAtIndex:3] intValue];
    }
    @catch (NSException *exception) {
        return 0;
    }
}

- (id)initWithDomain:(NSString *)domain withFiles:(NSArray *)files {
    if (self = [super init]) {
        if (!domain) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"domain" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setDomain:domain];
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:files];
        [self setFiles:tmpArray];
#if !__has_feature(objc_arc)
        if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
        return self;
    }else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setDomain:nil];
    [self setFiles:nil];
    [super dealloc];
#endif
}

- (NSMutableDictionary *)nonEmptyFilesMap {
    NSMutableDictionary *tmpDict = [[[NSMutableDictionary alloc] init] autorelease];
    for (NSString *str in [self files]) {
        if ([AssetExs isNonEmpty:str]) {
            [tmpDict setObject:self.domain forKey:str];
        }
    }
    return tmpDict;
}

- (NSMutableArray *)nonEmptyFiles {
    NSMutableArray *tmpAry = [[[NSMutableArray alloc] init] autorelease];
    for (NSString *str in [self files]) {
        if ([AssetExs isNonEmpty:str]) {
            [tmpAry addObject:str];
        }
    }
    return tmpAry;
}

- (NSMutableArray *)filess {
    return [[[NSMutableArray alloc] initWithArray:[self files]] autorelease];
}

- (NSArray *)getFiles {
    return _files;
}

@end

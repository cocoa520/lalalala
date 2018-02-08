//
//  FilePath.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/9/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import "FilePath.h"
#import "CategoryExtend.h"

@interface FilePath ()

@property (nonatomic, readwrite, retain) NSString *outputFolder;

@end

@implementation FilePath
@synthesize outputFolder = _outputFolder;

- (id)initWithOutputFolder:(NSString*)outputFolder {
    if (self = [super init]) {
        if (!outputFolder) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"outputFolder" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setOutputFolder:outputFolder];
        return self;
    }else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setOutputFolder:nil];
    [super dealloc];
#endif
}


- (NSString*)apply:(AssetEx*)asset {
    if (![asset domain]) {
        return nil;
    }
    if (![asset relativePath]) {
        return nil;
    }
    NSString *path = [[[self outputFolder] stringByAppendingPathComponent:[FilePath normalize:[asset domain]]] stringByAppendingPathComponent:[FilePath normalize:[asset relativePath]]];
    return path;
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
        newPath = [newPath stringByAppendingPathComponent:[FilePath replaceSpecialChar:name]];
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

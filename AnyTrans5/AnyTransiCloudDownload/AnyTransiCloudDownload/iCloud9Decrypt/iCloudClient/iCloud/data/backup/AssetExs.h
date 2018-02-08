//
//  Assets.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import <Foundation/Foundation.h>

@interface AssetExs : NSObject {
@private
    NSString *_domain;
    NSArray *_files;
}

+ (NSMutableArray*)files:(NSArray *)assetsList filter:(NSPredicate*)filter;
+ (BOOL)isNonEmpty:(NSString *)asset;
+ (int)size:(NSString *)asset;
- (id)initWithDomain:(NSString *)domain withFiles:(NSArray *)files;
- (NSString *)domain;
- (NSMutableArray *)nonEmptyFiles;
- (NSMutableArray *)filess;

@end

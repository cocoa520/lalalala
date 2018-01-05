//
//  FilePath.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/9/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import <Foundation/Foundation.h>
#import "AssetEx.h"

@interface FilePath : NSObject {
@private
    NSString *                          _outputFolder;
}

- (id)initWithOutputFolder:(NSString*)outputFolder;

- (NSString*)apply:(AssetEx*)asset;

@end

//
//  IMBiTunesCategoryBindData.h
//  iMobieTrans
//
//  Created by Pallas on 7/30/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCategoryView.h"
#import "IMBiTunesEnum.h"

@interface IMBiTunesCategoryBindData : NSObject {
@private
    NSString *_categoryName;
    NSString *_displayName;
    NSImage *_categoryIcon;
    NSImage *_categoryIcon1;
    BOOL _isSelected;
    BOOL _isHigLight;
    IMBCategoryView *_categoryView;
    NSString *_imageStrName;
}

@property (nonatomic, readwrite, retain) NSString *imageStrName;
@property (nonatomic, readwrite, retain) NSString *categoryName;
@property (nonatomic, readwrite, retain) NSString *displayName;
@property (nonatomic, readwrite, retain) NSImage *categoryIcon;
@property (nonatomic, readwrite, retain) NSImage *categoryIcon1;
@property (nonatomic, readwrite) BOOL isSelected;
@property (nonatomic, readwrite) BOOL isHigLight;
@property (nonatomic, readwrite, retain) IMBCategoryView *categoryView;

@end

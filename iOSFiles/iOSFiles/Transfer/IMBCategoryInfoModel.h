//
//  IMBCagetoryInfoModel.h
//  iMobieTrans
//
//  Created by iMobie on 7/24/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"

@interface IMBCategoryInfoModel : NSObject {
    NSString *_categoryName;
    NSImage *_categoryImage;
    CategoryNodesEnum _categoryNodes;
    BOOL _isSelected;
    NSAttributedString *_categoryNameAs;
}

@property (nonatomic, retain) NSString *categoryName;
@property (nonatomic, retain) NSAttributedString *categoryNameAs;
@property (nonatomic, retain) NSImage *categoryImage;
@property (nonatomic, readwrite) CategoryNodesEnum categoryNodes;
@property (nonatomic, readwrite) BOOL isSelected;

- (void)setCategoryNameAttributedString;

@end

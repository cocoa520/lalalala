//
//  IMBCategoryView.h
//  iMobieTrans
//
//  Created by Pallas on 7/30/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IMBCategoryView;

@protocol CategoryViewCallback
@optional
- (void)mouseOnCategory:(IMBCategoryView *)sender withObject:(id)object;
- (void)mouseExiteCategory:(IMBCategoryView *)sender withObject:(id)object;
@required
- (void)showToolTip:(IMBCategoryView*)sender withToolTip:(NSString*)toolTip;
- (void)closeToolTip:(IMBCategoryView*)sender;
- (void)categoryClick:(IMBCategoryView*)sender withObject:(id)object;

@end

@interface IMBCategoryView : NSView {
    NSString *_categoryName;
@private
    id _delegate;
    NSTrackingArea *_trackingArea;
    BOOL _isEntered;
    NSString *_toolTip;
    BOOL _hasIdentify;
    BOOL _isSelected;
    BOOL _isDown;
}
@property (nonatomic, retain) NSString *categoryName;
@property (nonatomic, readwrite, retain) id delegate;
@property (nonatomic, readwrite, retain,setter = setToolTip:) NSString *toolTip;
@property (nonatomic, readwrite) BOOL isSelected;
@property (nonatomic, readwrite) BOOL isEntered;
- (void)setToolTip:(NSString *)toolTip;

@end

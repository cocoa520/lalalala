//
//  IMBSearchParamterChooseView.h
//  AnyTransforCloud
//
//  Created by hym on 26/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef enum paramterType {
    nameType = 0,
    styleType = 1,
    timeType = 2,
} paramterTypeEnum;

@interface IMBSearchParamterChooseView : NSView
{
    NSShadow *_shadow;
    id		_target;
    SEL		_action;
}
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

- (void)setChooseCloudAry:(NSMutableArray *)ary;
- (void)setchooseStyleOrTimeAry:(NSArray *)ary;
@end

@class IMBCloudEntity;
@class IMBParamterItem;
#import "IMBCommonEnum.h"

@interface IMBSearchPullDownItem : NSView
{
    id	_target;
    SEL	_action;
    BOOL _hasImage;
    IMBCloudEntity *_cloudEntity;
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _buttonType;
    
    IMBParamterItem *_paramterItem;
}
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) BOOL hasImage;
@property (nonatomic, retain) IMBCloudEntity *cloudEntity;
@property (nonatomic, retain) IMBParamterItem *paramterItem;
@end


@interface IMBParamterItem : NSObject {
    FileTypeEnum _fileType;
    DateTypeEnum _dateType;
    NSString *_title;
}

@property (nonatomic, assign) FileTypeEnum fileType;
@property (nonatomic, assign) DateTypeEnum dateType;
@property (nonatomic, retain) NSString *title;
@end
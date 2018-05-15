//
//  IMBAccountItemView.h
//  AnyTransforCloud
//
//  Created by hym on 16/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCreateAccountTable.h"
#import "IMBCommonEnum.h"
@class IMBCurrencySvgButton;
@interface IMBAccountItemView : NSView
{
    NSTrackingArea *_trackingArea;
    id		_target;
    SEL		_action;
    IMBAccountEntity *_accountEntity;
    MouseStatusEnum _buttonType;
//    IMBCurrencySvgButton *_signOutBtn;
    SEL _removeAction;
}
@property (nonatomic, assign, nullable) id target;
@property (nonatomic, assign, nullable) SEL action;
@property (nonatomic, assign, nullable) SEL removeAction;
@property (nonnull, retain) IMBAccountEntity *accountEntity;
@end

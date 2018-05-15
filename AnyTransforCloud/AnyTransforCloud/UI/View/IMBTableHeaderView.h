//
//  IMBTableHeaderView.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/25.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBArrowButton.h"

@interface IMBTableHeaderView : NSTableHeaderView

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) IMBArrowButton *nameArrow;
@property (nonatomic, retain) IMBArrowButton *timeArrow;
@property (nonatomic, retain) IMBArrowButton *sizeArrow;
@property (nonatomic, retain) IMBArrowButton *extensionArrow;

/**
 *  正在点击的某个 arrow button
 *
 *  @param identifier 该点击button的唯一标识
 */
- (void)currentButtonClick:(NSString *)identifier;

@end

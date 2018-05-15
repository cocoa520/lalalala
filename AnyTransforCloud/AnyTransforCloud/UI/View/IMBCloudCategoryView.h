//
//  IMBCloudCategoryView.h
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/10.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBSelectedButton.h"
#import "IMBWhiteView.h"

@protocol CloudCategoryDelegate <NSObject>

@optional

- (void)cloudCategory:(IMBSelectedButton *)titleBtn;

@end

@interface IMBCloudCategoryView : NSView<NSAnimationDelegate> {
    id _delegate;
//    IMBSelectedButton *_titleOneBtn;
//    IMBSelectedButton *_titleTwoBtn;
//    IMBSelectedButton *_titleThreeBtn;
//    IMBSelectedButton *_titleFourBtn;
    NSMutableDictionary *_titleBtnDic;
    IMBWhiteView *_selectLineView;
    int _lineOneX;
    int _lineTwoX;
    int _lineThreeX;
    int _lineFourX;
    int _lineFiveX;
    int _lineSixX;
}
@property (nonatomic, retain) NSMutableDictionary *titleBtnDic;
//@property (nonatomic, retain) IMBSelectedButton *titleFourBtn;
@property (nonatomic, assign) id delegate;
/**
 *  设置选择某一个按钮
 *
 *  @param btn 对应的按钮
 */
- (void)setSelectBtn:(IMBSelectedButton *)btn;
@end

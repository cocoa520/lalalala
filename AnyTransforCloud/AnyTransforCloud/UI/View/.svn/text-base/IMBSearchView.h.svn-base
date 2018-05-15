//
//  IMBSearchView.h
//  AnyTransforCloud
//
//  Created by hym on 26/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBDrawImageBtn;
@class IMBWhiteView;
@class IMBCloudEntity;
typedef enum searchType {
    unUseType = 0,
    useType = 1,
    pullDownType = 2,
} searchTypeEnum;


typedef enum eyeType {
    closeEye = 0,
    openEye = 1,
} eyeTypeEnum;

@interface IMBSearchView : NSView
{
    NSShadow *_shadow;
    searchTypeEnum _searchType;
    eyeTypeEnum _eyeType;
    id _delegate;
    IMBCloudEntity *_selectedCloudEntity;
    IMBWhiteView *_searchBgView;
    CALayer *_lightLayer;
}
@property (assign) IBOutlet NSImageView *cloudImage;
@property (assign) IBOutlet IMBDrawImageBtn *pullDownBtn;
@property (assign) IBOutlet NSTextField *searchTextFiled;
@property (assign) IBOutlet IMBWhiteView *lineView;
@property (assign) IBOutlet IMBDrawImageBtn *eyeBtn;
@property (assign) IBOutlet IMBDrawImageBtn *searchBtn;
@property (assign) IBOutlet IMBDrawImageBtn *clearSearchBtn;
@property (assign) IBOutlet IMBWhiteView *firstLineView;
@property (assign) IBOutlet IMBWhiteView *thirdLineView;
@property (assign) IBOutlet IMBWhiteView *fourthLineView;
@property (assign) IBOutlet IMBWhiteView *secondLineView;
@property (assign) IBOutlet NSTextField *nameTextFiled;
@property (assign) IBOutlet NSTextField *typeTextFiled;
@property (assign) IBOutlet NSTextField *TimeTextFiled;
@property (assign) IBOutlet IMBDrawImageBtn *namePullDownBtn;
@property (assign) IBOutlet IMBDrawImageBtn *typePullDownBtn;
@property (assign) IBOutlet IMBDrawImageBtn *timePullDownBtn;
@property (assign) IBOutlet NSImageView *cloudImageView;
@property (assign) IBOutlet NSTextField *selectedNameTextFiled;
@property (assign) IBOutlet NSTextField *selectedTypeTextFiled;
@property (assign) IBOutlet NSTextField *selectedTimeTextFiled;
@property (nonatomic, assign) searchTypeEnum searchType;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) IMBCloudEntity *selectedCloudEntity;
@end

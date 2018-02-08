//
//  IMBIMView.h
//  iMobieTrans
//
//  Created by iMobie on 5/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBTextField.h"
#import "IMBPopupButton.h"
#import "IMBContactEntity.h"
#import "IMBContactItemView.h"

@interface IMBIMView : IMBContactItemView<InternalLayoutChange>{
    IMBTextField *_valueField;
    IMBPopupButton *_lablePopup;
    IMBPopupButton *_imPopup;
    NSArray *_labelsArr;
    NSArray *_imArr;
    NSString *_lableType;
    NSString *_servicetype;
    NSString *_valueText;
    NSString *_displayValue;
    IMBContactIMEntity *_imEntity;
    BOOL _isLastItem;
}

@property (nonatomic,retain,setter = setImArr:) NSArray *imArr;
@property (nonatomic,retain,setter = setLablesArr:) NSArray *labelsArr;
@property (nonatomic,retain,setter = setLableType:) NSString *lableType;
@property (nonatomic,retain,setter = setServiceType:) NSString *serviceType;
@property (nonatomic,retain,setter = setDisplayValue:) NSString *displayValue;
@property (nonatomic,retain,setter = setValueText:) NSString *valueText;
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) BOOL isLastItem;
@property (nonatomic,retain) IMBContactIMEntity *imEntity;

- (void)setImArr:(NSArray *)imArr;
- (void)setLabelsArr:(NSArray *)labelsArr;
- (void)setLableType:(NSString *)lableType;
- (void)setServiceType:(NSString *)serviceType;
- (void)setDisplayValue:(NSString *)displayValue;
- (void)setIsEditing:(BOOL)isEditing;
- (void)setValueText:(NSString *)valueText;

@end

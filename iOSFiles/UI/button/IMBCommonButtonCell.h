//
//  IMBCommonButtonCell.h
//  PhoneClean3.0
//
//  Created by Pallas on 8/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import "IMBMyDrawCommonly.h"
@interface IMBCommonButtonCell : NSButtonCell {
@private
    NSString *_prefixMouseOutPicName;
    NSString *_middleMouseOutPicName;
    NSString *_suffixMouseOutPicName;
    
    NSString *_prefixMouseEnterPicName;
    NSString *_middleMouseEnterPicName;
    NSString *_suffixMouseEnterPicName;
    
    NSString *_prefixMouseDownPicName;
    NSString *_middleMouseDownPicName;
    NSString *_suffixMouseDownPicName;
    
    MouseStatusEnum _mouseStatus;
    int _textOffsetY;
    NSColor *_borderColor;
    float _lineWeight;
    float _radius;
}

@property (nonatomic, readwrite) MouseStatusEnum mouseStatus;
@property (nonatomic, readwrite) int textOffsetY;
@property (nonatomic, readwrite, retain) NSColor *borderColor;
@property (nonatomic, readwrite) float lineWeight;
@property (nonatomic, readwrite) float radius;
@property (nonatomic, readwrite, copy) NSString *prefixMouseOutPicName;
@property (nonatomic, readwrite, copy) NSString *middleMouseOutPicName;
@property (nonatomic, readwrite, copy) NSString *suffixMouseOutPicName;
@property (nonatomic, readwrite, copy) NSString *prefixMouseEnterPicName;
@property (nonatomic, readwrite, copy) NSString *middleMouseEnterPicName;
@property (nonatomic, readwrite, copy) NSString *suffixMouseEnterPicName;
@property (nonatomic, readwrite, copy) NSString *prefixMouseDownPicName;
@property (nonatomic, readwrite, copy) NSString *middleMouseDownPicName;
@property (nonatomic, readwrite, copy) NSString *suffixMouseDownPicName;

@end

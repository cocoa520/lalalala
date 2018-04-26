//
//  IMBGeneralBtnCell.h
//  PhoneClean
//
//  Created by iMobie on 6/17/15.
//  Copyright (c) 2015 imobie.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBGeneralBtnCell : NSButtonCell {
    NSImage *_leftImage;
    NSImage *_rightImage;
    NSImage *_middleImage;
    BOOL _isBigBtn;
    BOOL _isChange;
    
    BOOL _isDrawBg;
    
    NSImage *_applyImage;
    NSImage *_downloadImage;
    NSImage *_downloadEnterImage;
    BOOL _isApply;
    BOOL _downloadState;
    BOOL _isSkin;
    
    BOOL _isSkip;
}
@property (nonatomic, readwrite, retain) NSImage *applyImage;
@property (nonatomic, readwrite, retain) NSImage *downloadImage;
@property (nonatomic, readwrite, retain) NSImage *downloadEnterImage;

@property (nonatomic, readwrite, retain) NSImage *leftImage;
@property (nonatomic, readwrite, retain) NSImage *rightImage;
@property (nonatomic, readwrite, retain) NSImage *middleImage;
@property (nonatomic, readwrite) BOOL isChange;
@property (nonatomic, readwrite) BOOL isBigBtn;
@property (nonatomic, readwrite) BOOL isDrawBg;
@property (nonatomic, readwrite) BOOL isApply;
@property (nonatomic, readwrite) BOOL downloadState;
@property (nonatomic, readwrite) BOOL isSkin;
@property (nonatomic, readwrite) BOOL isSkip;
@end

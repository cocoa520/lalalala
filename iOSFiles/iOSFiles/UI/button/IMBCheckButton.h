//
//  IMBCheckBtn.h
//  iMobieTrans
//
//  Created by iMobie on 3/20/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBCheckButton :NSButton
{
    NSImage *_checkImg;
    NSImage *_unCheckImg;
    NSImage *_mixImg;
    BOOL _shouldNotChangeState;
    BOOL _isbackUpsettingBtn;
}
@property (assign) BOOL isbackUpsettingBtn;
@property (readwrite,retain) NSImage *checkImg;
@property (readwrite,retain) NSImage *unCheckImg;
@property (readwrite,retain) NSImage *mixImg;
@property (assign) BOOL shouldNotChangeState;
- (id)initWithCheckImg:(NSImage *)checkImg unCheckImg:(NSImage *)uncheckImg mixImg:(NSImage *)mixImg;
- (id)initWithCheckImg:(NSImage *)checkImg unCheckImg:(NSImage *)uncheckImg;
- (void)setCheckStateImage:(NSString *)btnName;

@end

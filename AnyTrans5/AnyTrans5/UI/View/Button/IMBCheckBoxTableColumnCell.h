//
//  IMBCheckBoxTableColumnCell.h
//  PhoneClean3.0
//
//  Created by Pallas on 8/12/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCheckBtn.h"

@interface IMBCheckBoxTableColumnCell : NSTextFieldCell {
@private
    IMBCheckBtn *_checkBox;
    NSRect _cellFrames;
}

@property (nonatomic, readwrite, retain) IMBCheckBtn *checkBox;

- (IMBCheckBtn *)checkBox;
- (void)setCheckBox:(IMBCheckBtn *)checkBox;

@end

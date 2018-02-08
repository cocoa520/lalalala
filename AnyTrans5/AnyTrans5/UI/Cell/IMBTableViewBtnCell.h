//
//  IMBTableViewBtnCell.h
//  PhoneRescue
//
//  Created by iMobie on 4/26/16.
//  Copyright (c) 2016 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCenterTextFieldCell.h"
#import "IMBMyDrawCommonly.h"
@interface IMBTableViewBtnCell : IMBCenterTextFieldCell {
@private
    IMBMyDrawCommonly *_deleteBtn;
    IMBMyDrawCommonly *_findBtn;
//    NSButton *_exportBtn;
    BOOL _isSelected;
    NSString *_tipText;
}
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, readwrite, retain) IMBMyDrawCommonly *deleteBtn;
@property (nonatomic, readwrite, retain) IMBMyDrawCommonly *findBtn;
//@property (nonatomic, readwrite, retain) NSButton *exportBtn;

@property (nonatomic, readwrite, retain) NSString *tipText;

@end


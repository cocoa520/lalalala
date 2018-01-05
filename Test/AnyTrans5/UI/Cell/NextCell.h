//
//  NextCell.h
//  AnyTrans
//
//  Created by m on 16/12/14.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBCenterTextFieldCell.h"
#import "HoverButton.h"
@interface NextCell : IMBCenterTextFieldCell
{
    HoverButton *_nextBtn;

}
@property (nonatomic, retain, readwrite) HoverButton *nextBtn;

@end

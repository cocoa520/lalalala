//
//  IMBImageTextFieldCell.h
//  PhotoTrans
//
//  Created by iMobie on 11/1/13.
//  Copyright (c) 2013 iMobie. All rights reserved.
//

#import "IMBCenterTextFieldCell.h"

@interface IMBImageTextFieldCell : IMBCenterTextFieldCell{
@private
    NSImage *_image;
    NSSize _imageSize;
    int _marginX;
}

@property (readwrite, retain) NSImage *image;
@property (assign) NSSize imageSize;
@property (assign) int marginX;

@end

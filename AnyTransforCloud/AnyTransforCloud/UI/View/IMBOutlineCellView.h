//
//  IMBOutlineCellView.h
//  AnyTransforCloud
//
//  Created by hym on 01/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBOutlineTriangleView;
@class IMBDriveModel;
@interface IMBOutlineCellView : NSTableCellView{
    IBOutlet IMBOutlineTriangleView *_triangleView;
    IBOutlet NSTextField *_name;
    IBOutlet NSImageView *_imgView;
    IMBDriveModel *_model;
    id _delegate;
}
@property (nonatomic, retain) IMBOutlineTriangleView *triangleView;
@property (nonatomic, retain) NSTextField *name;
@property (nonatomic, retain) NSImageView *imgView;
@property (nonatomic, retain) IMBDriveModel *model;
@property (nonatomic, assign) id delegate;
@end

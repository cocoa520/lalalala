//
//  IMBScrollView.h
//  AnyTrans
//
//  Created by long on 16-7-18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol IMBCollectionListener
@optional
- (void)showVisibleRextPhoto;

@end

@interface IMBScrollView : NSScrollView
{
    NSString *_imageName;
    BOOL _topBorder;
    BOOL _leftBorder;
    BOOL _bottomBorder;
    BOOL _rightBorder;
    id _listener;
}

@property (nonatomic,retain,setter = setImageName:) NSString *imageName;
- (void)setHastopBorder:(BOOL)topBorder leftBorder:(BOOL)leftBorder BottomBorder:(BOOL)bottomBorder rightBorder:(BOOL)rightBorder;

- (void)setListener:(id)listener;

@end

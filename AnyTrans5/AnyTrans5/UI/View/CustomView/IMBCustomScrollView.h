//
//  IMBCustomScrollView.h
//  AnyTrans
//
//  Created by iMobie on 7/18/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol IMBScrollerProtocol
@optional

- (void)scrollerView:(NSView *)scrollView withDown:(BOOL)isDown;

@end

@interface IMBCustomScrollView : NSView {
    NSString *_imageName;
    BOOL _topBorder;
    BOOL _leftBorder;
    BOOL _bottomBorder;
    BOOL _rightBorder;
    NSColor *_borderColor;
    NSView *_collectionView;
    
    id _delegate;
    BOOL _isScroll;
    BOOL _isdown;
}

@property (nonatomic,retain,setter = setImageName:) NSString *imageName;
@property (nonatomic,retain)NSColor *borderColor;
@property (nonatomic, readwrite) BOOL isdown;
@property (nonatomic, readwrite) BOOL isScroll;
- (void)setHastopBorder:(BOOL)topBorder leftBorder:(BOOL)leftBorder BottomBorder:(BOOL)bottomBorder rightBorder:(BOOL)rightBorder;

- (void)setCollectionView:(NSView *)collectionView;
- (void)setDelegate:(id<IMBScrollerProtocol>)delegate;

@end

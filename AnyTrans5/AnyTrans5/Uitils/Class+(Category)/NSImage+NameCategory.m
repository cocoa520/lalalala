//
//  NSImage+NameCategory.m
//  PhoneRescue_Android
//
//  Created by m on 17/5/19.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "NSImage+NameCategory.h"

static char ImgNameKey;
@implementation NSImage (NameCategory)

- (void)setImgName:(NSString *)imgName {
    objc_setAssociatedObject(self, &ImgNameKey, imgName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)imgName {
    return objc_getAssociatedObject(self, &ImgNameKey);
}

@end

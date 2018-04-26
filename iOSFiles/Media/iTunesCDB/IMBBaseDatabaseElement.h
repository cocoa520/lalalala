//
//  IMBBaseDatabaseElement.h
//  MediaTrans
//
//  Created by Pallas on 12/11/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <malloc/malloc.h>
#import "IMBiPod.h"
#import "IMBBaseEntity.h"

@class IMBStringMHOD;

@interface IMBBaseDatabaseElement : IMBBaseEntity
{
@protected
    IMBiPod *iPod;
    char* _identifier;
    int _headerSize;
    int _sectionSize;
    Byte* _unusedHeader;
    int _requiredHeaderSize;
    
    int identifierLength;
    int unusedHeaderLength;
}

@property (nonatomic,readonly) int headerSize;
@property (nonatomic,readonly) int sectionSize;

#pragma mark - 读取CDB里的内容
-(BOOL)validateHeader:(NSString*)validIdentifier;
-(long)readToHeaderEnd:(NSData*)reader currPosition:(long)currPosition;
-(long)read:(IMBiPod*)ipod reader:(NSData*)reader currPosition:(long)currPosition;

#pragma mark - 将内容写回到CDB中,子类实现
-(void)write:(NSMutableData*)writer;
-(int)getSectionSize;

-(IMBStringMHOD*)getChildByType:(NSArray*)children childrentype:(int)type;
-(NSString*)getDataElement:(NSArray*)children clidrentype:(int)type;

@end

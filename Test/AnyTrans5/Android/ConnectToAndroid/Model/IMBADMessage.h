//
//  IMBADMessage.h
//  PhoneRescue_Android
//
//  Created by iMobie on 4/14/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBBaseCommunicate.h"
#import "IMBADMessageEntity.h"

@interface IMBADMessage : IMBBaseCommunicate {
    NSString *_journalPath;
    NSString *_htmlImgFolderPath;
}
@property (nonatomic, readwrite, retain) NSString *journalPath;

/**
 *获得附件,path：导出时的路劲；不需要就传nil；
 */
- (BOOL)getAttachmentContent:(IMBSMSPartEntity *)partEntity withPath:(NSString *)path;

@end

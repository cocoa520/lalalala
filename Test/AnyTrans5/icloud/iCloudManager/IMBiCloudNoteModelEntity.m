//
//  IMBiCloudNoteModelEntity.m
//  
//
//  Created by ding ming on 17/2/2.
//
//

#import "IMBiCloudNoteModelEntity.h"

@implementation IMBiCloudNoteModelEntity
@synthesize recordName = _recordName;
@synthesize recordType = _recordType;
@synthesize parentRecordName = _parentRecordName;
//保存note的其他字段
@synthesize createdDeviceID = _createdDeviceID;
@synthesize createdTimestamp = _createdTimestamp;
@synthesize createdUserRecordName = _createdUserRecordName;
@synthesize fieldsAttachmentViewTypeValue = _fieldsAttachmentViewTypeValue;
@synthesize fieldsCreationDateValue = _fieldsCreationDateValue;
@synthesize fieldsDeletedValue = _fieldsDeletedValue;
@synthesize fieldsFirstAttachmentThumbnailValueDownloadURL = _fieldsFirstAttachmentThumbnailValueDownloadURL;
@synthesize fieldsFirstAttachmentThumbnailValueFileChecksum = _fieldsFirstAttachmentThumbnailValueFileChecksum;
@synthesize fieldsFirstAttachmentThumbnailValueReferenceChecksum = _fieldsFirstAttachmentThumbnailValueReferenceChecksum;
@synthesize fieldsFirstAttachmentThumbnailValueSize = _fieldsFirstAttachmentThumbnailValueSize;
@synthesize fieldsFirstAttachmentThumbnailValueWrappingKey = _fieldsFirstAttachmentThumbnailValueWrappingKey;
@synthesize fieldsFirstAttachmentThumbnailOrientationValue = _fieldsFirstAttachmentThumbnailOrientationValue;
@synthesize fieldsFirstAttachmentUTIEncryptedValue = _fieldsFirstAttachmentUTIEncryptedValue;
@synthesize fieldsFoldersValueAction = _fieldsFoldersValueAction;
@synthesize fieldsFoldersValueRecordName = _fieldsFoldersValueRecordName;
@synthesize fieldsFoldersValueZoneIDOwnerRecordName = _fieldsFoldersValueZoneIDOwnerRecordName;
@synthesize fieldsFoldersValueZoneIDZoneName = _fieldsFoldersValueZoneIDZoneName;
@synthesize fieldsModificationDateValue = _fieldsModificationDateValue;
@synthesize fieldsSnippetEncryptedValue = _fieldsSnippetEncryptedValue;
@synthesize fieldsTextDataEncryptedValue = _fieldsTextDataEncryptedValue;
@synthesize fieldsTitleEncryptedValue = _fieldsTitleEncryptedValue;
@synthesize modifiedDeviceID = _modifiedDeviceID;
@synthesize modifiedTimestamp = _modifiedTimestamp;
@synthesize modifiedUserRecordName = _modifiedUserRecordName;
@synthesize recordChangeTag = _recordChangeTag;
@synthesize shortGUID = _shortGUID;

- (id)init {
    if (self = [super init]) {
        _recordName = @"";
        _recordType = @"";
        _parentRecordName = @"";
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end

@implementation IMBiCloudNoteAttachmentEntity
@synthesize width = _width;
@synthesize height = _height;
@synthesize parentRecordName = _parentRecordName;
@synthesize recordName = _recordName;
@synthesize recordType = _recordType;

- (id)init {
    if (self = [super init]) {
        _width = 0;
        _height = 0;
        _parentRecordName = @"";
        _recordName = @"";
        _recordType = @"";
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


@end

@implementation IMBUpdateNoteEntity
@synthesize timeStamp = _timeStamp;
@synthesize noteContent = _noteContent;

- (id)init {
    if (self = [super init]) {
        _timeStamp = 0;
        _noteContent = @"";
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end

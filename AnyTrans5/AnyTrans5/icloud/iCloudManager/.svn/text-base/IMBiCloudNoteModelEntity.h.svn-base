//
//  IMBiCloudNoteModelEntity.h
//  
//
//  Created by ding ming on 17/2/2.
//
//

#import "IMBNoteDataEntity.h"

@interface IMBiCloudNoteModelEntity : IMBNoteModelEntity {
    NSString *_recordName;
    NSString *_recordType;
    NSString *_parentRecordName;
    
    //保存note的其他字段
    NSString *_createdDeviceID;
    long long _createdTimestamp;
    NSString *_createdUserRecordName;
    long long _fieldsAttachmentViewTypeValue;
    long long _fieldsCreationDateValue;
    long long _fieldsDeletedValue;
    NSString *_fieldsFirstAttachmentThumbnailValueDownloadURL;
    NSString *_fieldsFirstAttachmentThumbnailValueFileChecksum;
    NSString *_fieldsFirstAttachmentThumbnailValueReferenceChecksum;
    long long _fieldsFirstAttachmentThumbnailValueSize;
    NSString *_fieldsFirstAttachmentThumbnailValueWrappingKey;
    long long _fieldsFirstAttachmentThumbnailOrientationValue;
    NSString *_fieldsFirstAttachmentUTIEncryptedValue;
    NSString *_fieldsFoldersValueAction;
    NSString *_fieldsFoldersValueRecordName;
    NSString *_fieldsFoldersValueZoneIDOwnerRecordName;
    NSString *_fieldsFoldersValueZoneIDZoneName;
    long long _fieldsModificationDateValue;
    NSString *_fieldsSnippetEncryptedValue;
    NSString *_fieldsTextDataEncryptedValue;
    NSString *_fieldsTitleEncryptedValue;
    NSString *_modifiedDeviceID;
    long long _modifiedTimestamp;
    NSString *_modifiedUserRecordName;
    NSString *_recordChangeTag;
    NSString *_shortGUID;
}

@property (nonatomic, retain) NSString *recordName;
@property (nonatomic, retain) NSString *recordType;
@property (nonatomic, retain) NSString *parentRecordName;
//保存note的其他字段
@property (nonatomic, retain) NSString *createdDeviceID;
@property (nonatomic, assign) long long createdTimestamp;
@property (nonatomic, retain) NSString *createdUserRecordName;
@property (nonatomic, assign) long long fieldsAttachmentViewTypeValue;
@property (nonatomic, assign) long long fieldsCreationDateValue;
@property (nonatomic, assign) long long fieldsDeletedValue;
@property (nonatomic, retain) NSString *fieldsFirstAttachmentThumbnailValueDownloadURL;
@property (nonatomic, retain) NSString *fieldsFirstAttachmentThumbnailValueFileChecksum;
@property (nonatomic, retain) NSString *fieldsFirstAttachmentThumbnailValueReferenceChecksum;
@property (nonatomic, assign) long long fieldsFirstAttachmentThumbnailValueSize;
@property (nonatomic, retain) NSString *fieldsFirstAttachmentThumbnailValueWrappingKey;
@property (nonatomic, assign) long long fieldsFirstAttachmentThumbnailOrientationValue;
@property (nonatomic, retain) NSString *fieldsFirstAttachmentUTIEncryptedValue;
@property (nonatomic, retain) NSString *fieldsFoldersValueAction;
@property (nonatomic, retain) NSString *fieldsFoldersValueRecordName;
@property (nonatomic, retain) NSString *fieldsFoldersValueZoneIDOwnerRecordName;
@property (nonatomic, retain) NSString *fieldsFoldersValueZoneIDZoneName;
@property (nonatomic, assign) long long fieldsModificationDateValue;
@property (nonatomic, retain) NSString *fieldsSnippetEncryptedValue;
@property (nonatomic, retain) NSString *fieldsTextDataEncryptedValue;
@property (nonatomic, retain) NSString *fieldsTitleEncryptedValue;
@property (nonatomic, retain) NSString *modifiedDeviceID;
@property (nonatomic, assign) long long modifiedTimestamp;
@property (nonatomic, retain) NSString *modifiedUserRecordName;
@property (nonatomic, retain) NSString *recordChangeTag;
@property (nonatomic, retain) NSString *shortGUID;

@end

@interface IMBiCloudNoteAttachmentEntity : IMBNoteAttachmentEntity {
    int _width;
    int _height;
    NSString *_parentRecordName;
    NSString *_recordName;
    NSString *_recordType;
}

@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, retain) NSString *parentRecordName;
@property (nonatomic, retain) NSString *recordName;
@property (nonatomic, retain) NSString *recordType;

@end

@interface IMBUpdateNoteEntity : NSObject {
    long long _timeStamp;
    NSString *_noteContent;
}

@property (nonatomic, assign) long long timeStamp;
@property (nonatomic, retain) NSString *noteContent;

@end

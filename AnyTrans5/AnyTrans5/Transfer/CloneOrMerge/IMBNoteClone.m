//
//  IMBNoteClone.m
//  iMobieTrans
//
//  Created by iMobie on 14-12-18.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBNoteClone.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "IMBZipHelper.h"
#import "StringHelper.h"
@implementation IMBNoteClone
- (id)initWithSourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray isClone:(BOOL)isClone
{
    if (self = [super initWithSourceBackupPath:sourceBackupPath desBackupPath:desBackupPath sourcerecordArray:sourcerecordArray targetrecordArray:targetrecordArray  isClone:isClone]) {
        _attachmentIdentifierList = [[NSMutableArray array] retain];
    }
    return self;
}

- (void)setsourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray
{
    _sourceVersion = [IMBBaseClone getBackupFileVersion:sourceBackupPath];
    _targetVersion = [IMBBaseClone getBackupFileVersion:desBackupPath];
    _sourceFloatVersion = [[IMBBaseClone getBackupFileFloatVersion:sourceBackupPath] retain];
    _targetFloatVersion = [[IMBBaseClone getBackupFileFloatVersion:desBackupPath] retain];
    //解析manifest
    _sourcerecordArray = [sourcerecordArray retain];
    _targetrecordArray = [targetrecordArray retain];
    _sourcedbType = [self determineDatabaseType:sourceBackupPath version:_sourceVersion];
    _targetdbType = [self determineDatabaseType:desBackupPath version:_targetVersion];
    _sourceBackuppath = [sourceBackupPath retain];
    _targetBakcuppath = [desBackupPath retain];
    if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
        _sourceManifestDBConnection = [[FMDatabase alloc] initWithPath:[sourceBackupPath stringByAppendingPathComponent:@"Manifest.db"]];
    }
    if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
        _targetManifestDBConnection = [[FMDatabase alloc] initWithPath:[desBackupPath stringByAppendingPathComponent:@"Manifest.db"]];
    }
    if (_sourcedbType) {
        sourceRecord = [[self getDBFileRecord:@"AppDomainGroup-group.com.apple.notes" path:@"NoteStore.sqlite" recordArray:_sourcerecordArray] retain];
        NSString *rstr = [sourceRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,sourceRecord.key];
        sourceRecord.relativePath = relativePath;

    }else{
        sourceRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/Notes/notes.sqlite" recordArray:_sourcerecordArray] retain];
        NSString *rstr = [sourceRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,sourceRecord.key];
        sourceRecord.relativePath = relativePath;
    }
    if (_targetdbType) {
        targetRecord = [[self getDBFileRecord:@"AppDomainGroup-group.com.apple.notes" path:@"NoteStore.sqlite" recordArray:_targetrecordArray] retain];
        NSString *rstr = [sourceRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,targetRecord.key];
        targetRecord.relativePath = relativePath;
        
    }else{
        targetRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/Notes/notes.sqlite" recordArray:_targetrecordArray] retain];
        NSString *rstr = [sourceRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,targetRecord.key];
        targetRecord.relativePath = relativePath;
    }
    _sourceSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"sourceSqlite"] fileRecord:sourceRecord backupfilePath:sourceBackupPath] retain];
    _targetSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetSqlite"] fileRecord:targetRecord backupfilePath:desBackupPath] retain];
}

- (void)dealloc
{
    [_attachmentIdentifierList release],_attachmentIdentifierList = nil;
    [super dealloc];
}

#pragma mark - method

- (NSString *)analysisNoteData:(NSData *)noteData withIsCompress:(BOOL)isdeCompress {
    NSData *decompressData = nil;
    if (isdeCompress) {
        decompressData = [IMBNoteClone uncompressZippedData:noteData];//ZipHelper.Decompress(noteData);
    }else {
        decompressData = noteData;
    }
    
    if (decompressData == nil) {
        return @"";
    }
    NSInteger fileLength = decompressData.length - 4;
    int Offset = 2;
    if (fileLength > 128) {
        //Paging
        Offset = Offset + 2;
    }else {
        Offset = Offset + 1;
    }
    Offset = Offset + 5;
    NSInteger fileMinLength = decompressData.length - 12;
    
    if (fileMinLength > 128) {
        Offset = Offset + 2;
    }else {
        Offset = Offset + 1;
    }
    Offset = Offset + 2;
    char *bytes = (char *)decompressData.bytes;
    NSMutableString *noteContent = [NSMutableString string];// List<byte> noteContent = new List<byte>();
    for (int i = Offset; i < decompressData.length; i++)
    {
        NSString *text16 = [NSString stringWithFormat:@"%02x",(unsigned char)bytes[i]];
        if ([text16 isEqualToString:@"1a"])
        {
            break;
        }
        [noteContent appendFormat:@"%02x", ((uint8_t*)bytes)[i]];
    }
    if (noteContent.length == 0)
    {
        return @"";
    }
    
    NSString *contentStr = @"";
    if (noteContent.length - 1 > 128)
    {
        if (noteContent.length >= 2) {
            contentStr = [noteContent stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""];
        }
    }else {
        if (noteContent.length >= 1) {
            contentStr = [noteContent stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
        }
    }
    NSString *noteStr = [StringHelper stringFromHexString:contentStr];
    return noteStr;
}

- (BOOL)determineDatabaseType:(NSString *)backupFolderPath version:(NSInteger)version{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (version>=9) {
        NSString *filePath = nil;
        if (version>=10) {
            filePath = [[backupFolderPath stringByAppendingPathComponent:@"85"] stringByAppendingPathComponent:@"857109b149c3a666c746569cec5ffd3cbf5955d9"];
        }else{
            filePath = [backupFolderPath stringByAppendingPathComponent:@"857109b149c3a666c746569cec5ffd3cbf5955d9"];
        }
        if ([fm fileExistsAtPath:filePath]) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

+(NSData *)uncompressZippedData:(NSData *)compressedData
{
    if ([compressedData length] == 0) return compressedData;
    unsigned full_length = [compressedData length];
    unsigned half_length = [compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}


+(NSData *)greadData:(NSString *)noteContent{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DataPlist" ofType:@"plist"];
    NSMutableDictionary *noteDataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSMutableData *headByte = [NSMutableData data];
    int i = 8;
    NSData *data1 = [NSData dataWithBytes:&i length:1];
    [headByte appendData:data1];
    i = 0;
    NSData *data2 = [NSData dataWithBytes:&i length:1];
    [headByte appendData:data2];
    i = 18;
    NSData *data3 = [NSData dataWithBytes:&i length:1];
    [headByte appendData:data3];
    
    NSMutableData *unknownByte = [NSMutableData data];
    i = 8;
    NSData *unknowndata1 = [NSData dataWithBytes:&i length:1];
    [unknownByte appendData:unknowndata1];
    i = 0;
    NSData *unknowndata2 = [NSData dataWithBytes:&i length:1];
    [unknownByte appendData:unknowndata2];
    i = 16;
    NSData *unknowndata3 = [NSData dataWithBytes:&i length:1];
    [unknownByte appendData:unknowndata3];
    i = 0;
    NSData *unknowndata4 = [NSData dataWithBytes:&i length:1];
    [unknownByte appendData:unknowndata4];
    
    NSMutableData *identifbyte = [NSMutableData data];
    i = 26;
    NSData *iden = [NSData dataWithBytes:&i length:1];
    [identifbyte appendData:iden];
    
    NSMutableData *unknownbyte1 = [NSMutableData data];
    i = 18;
    NSData *unData = [NSData dataWithBytes:&i length:1];
    [unknownbyte1 appendData:unData];
    
    NSMutableData *lenbytes = [NSMutableData data];
    NSData* noteData = [noteContent dataUsingEncoding:NSUTF8StringEncoding];
    if (noteData.length < 128) {
        i = noteData.length;
        NSData *iden = [NSData dataWithBytes:&i length:1];
        [lenbytes appendData:iden];
    }else{
        int pageCount = noteData.length/128;
        int firstbytes = noteData.length - (pageCount -1)*128;
        NSData *iden = [NSData dataWithBytes:&firstbytes length:1];
        NSData *iden1 = [NSData dataWithBytes:&pageCount length:1];
        [lenbytes appendData:iden];
        [lenbytes appendData:iden1];
    }
    NSData *sectionBytes = [noteDataDic objectForKey:@"NoteData1"];
    
    NSMutableData *section1List = [NSMutableData data];
    i = 40;
    NSData *sectionData = [NSData dataWithBytes:&i length:1];
    [section1List appendData:sectionData];
    i = 1;
    NSData *sectionData1 = [NSData dataWithBytes:&i length:1];
    [section1List appendData:sectionData1];
    i = 26;
    NSData *sectionData2 = [NSData dataWithBytes:&i length:1];
    [section1List appendData:sectionData2];
    
    int charCount = noteContent.length;
    BOOL isPaging = charCount >=128? YES : NO;
    NSMutableData *charCountList = [NSMutableData data];
    if (isPaging) {
        i = 17;
        NSData *sectionData2 = [NSData dataWithBytes:&i length:1];
        [section1List appendData:sectionData2];
    }else{
        i = 16;
        NSData *sectionData2 = [NSData dataWithBytes:&i length:1];
        [section1List appendData:sectionData2];
    }
    [section1List appendData:[noteDataDic objectForKey:@"NoteData2"]];
    
    if (isPaging) {
        int pageCount = charCount / 128;
        int firstPageBytes = charCount - (pageCount -1) *128;
        NSData *sectionData1 = [NSData dataWithBytes:&firstPageBytes length:1];
        NSData *sectionData2 = [NSData dataWithBytes:&pageCount length:1];
        [charCountList appendData:sectionData1];
        [charCountList appendData:sectionData2];
    }else{
        NSData *sectionData2 = [NSData dataWithBytes:&charCount length:1];
        [charCountList appendData:sectionData2];
    }
    [section1List appendData:charCountList];
    [section1List appendData:[noteDataDic objectForKey:@"NoteData3"]];
    
    NSMutableData *section2List = [NSMutableData data];
    i = 40;
    NSData *section2Data = [NSData dataWithBytes:&i length:1];
    [section2List appendData:section2Data];
    
    i = 2;
    NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
    [section2List appendData:section2Data2];
    
    i = 26;
    NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
    [section2List appendData:section2Data3];
    [section2List appendData:[noteDataDic objectForKey:@"NoteData4"]];
    if (isPaging) {
        i = 29;
        NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
        [section2List appendData:section2Data2];
        
        i = 10;
        NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
        [section2List appendData:section2Data3];
    }else{
        i = 28;
        NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
        [section2List appendData:section2Data2];
        
        i = 10;
        NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
        [section2List appendData:section2Data3];
    }
    NSMutableData *endSectionList = [NSMutableData data];
    if (isPaging) {
        i = 27;
        NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data2];
        
        i = 10;
        NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data3];
    }else{
        i = 26;
        NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data2];
        
        i = 10;
        NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data3];
    }
    [endSectionList appendData:[noteDataDic objectForKey:@"NoteData5"]];
    if (isPaging) {
        i = 18;
        NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data2];
        
        i = 03;
        NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data3];
    }else{
        i = 18;
        NSData *section2Data2 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data2];
        
        i = 02;
        NSData *section2Data3 = [NSData dataWithBytes:&i length:1];
        [endSectionList appendData:section2Data3];
    }
    i = 8;
    NSData *secti= [NSData dataWithBytes:&i length:1];
    [endSectionList appendData:secti];
    [endSectionList appendData:charCountList];
    
    [endSectionList appendData:[noteDataDic objectForKey:@"NoteData6"]];
    
    NSMutableData *endBytes = [NSMutableData data];
    i = 8;
    NSData *endData = [NSData dataWithBytes:&i length:1];
    [endBytes appendData:endData];
    [endBytes appendData:charCountList];
    
    if (charCount == noteData.length) {
        i = 18;
        NSData *secti= [NSData dataWithBytes:&i length:1];
        [endBytes appendData:secti];
        
        i = 02;
        NSData *secti1= [NSData dataWithBytes:&i length:1];
        [endBytes appendData:secti1];
        
        i = 24;
        NSData *secti2= [NSData dataWithBytes:&i length:1];
        [endBytes appendData:secti2];
        
        i = 01;
        NSData *secti3 = [NSData dataWithBytes:&i length:1];
        [endBytes appendData:secti3];
    }else{
        i = 18;
        NSData *secti2= [NSData dataWithBytes:&i length:1];
        [endBytes appendData:secti2];
        
        i = 0;
        NSData *secti3 = [NSData dataWithBytes:&i length:1];
        [endBytes appendData:secti3];
    }
    int endCount = endBytes.length;
    NSData *endCountData = [NSData dataWithBytes:&endCount length:1];
    [endSectionList appendData:endCountData];
    [endSectionList appendData:endBytes];
    
    NSMutableData *datas = [NSMutableData data];
    int countentLength = unknownbyte1.length + lenbytes.length + noteData.length + sectionBytes.length + section1List.length + section2List.length + endSectionList.length;
    //    NSData *countentData = [NSData dataWithBytes:&countentLength length:1];
    //    [datas appendData:countentData];
    [datas appendData:headByte];
    
    int totalLength = countentLength +unknownByte.length + identifbyte.length;
    totalLength = countentLength >=128 ? totalLength +2 : totalLength + 1;
    if (totalLength >=128) {
        int pageCount = totalLength / 128;
        int firstPageBytes = totalLength - (pageCount -1) *128;
        NSData *countentData1 = [NSData dataWithBytes:&firstPageBytes length:1];
        NSData *countentData2 = [NSData dataWithBytes:&pageCount length:1];
        [datas appendData:countentData1];
        [datas appendData:countentData2];
    }else{
        NSData *countentData = [NSData dataWithBytes:&totalLength length:1];
        [datas appendData:countentData];
    }
    [datas appendData:unknownByte];
    [datas appendData:identifbyte];
    if (countentLength >=128) {
        int pageCount = countentLength /128;
        int firstbyes = countentLength - (pageCount -1)*128;
        NSData *secti2 = [NSData dataWithBytes:&firstbyes length:1];
        NSData *secti3 = [NSData dataWithBytes:&pageCount length:1];
        [datas appendData:secti2];
        [datas appendData:secti3];
    }else{
        NSData *secti3 = [NSData dataWithBytes:&countentLength length:1];
        [datas appendData:secti3];
    }
    [datas appendData:unknownbyte1];
    [datas appendData:lenbytes];
    [datas appendData:noteData];
    [datas appendData:sectionBytes];
    [datas appendData:section1List];
    [datas appendData:section2List];
    [datas appendData:endSectionList];
    return datas;
}

+(NSData*) gzipData:(NSData*)pUncompressedData
{
    if (!pUncompressedData || [pUncompressedData length] == 0)
    {
        NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
        return nil;
    }
    
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
    zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
    zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
    zlibStreamStruct.next_in   = (Bytef*)[pUncompressedData bytes]; // Pointer to input bytes
    zlibStreamStruct.avail_in  = [pUncompressedData length]; // Number of input bytes left to process
    
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
    if (initError != Z_OK)
    {
        NSString *errorMsg = nil;
        switch (initError)
        {
            case Z_STREAM_ERROR:
                errorMsg = @"Invalid parameter passed in to function.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Insufficient memory.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        [errorMsg release];
        return nil;
    }
    
    // Create output memory buffer for compressed data. The zlib documentation states that
    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
    NSMutableData *compressedData = [NSMutableData dataWithLength:[pUncompressedData length] * 1.01 + 12];
    
    int deflateStatus;
    do
    {
        // Store location where next byte should be put in next_out
        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        
        // Calculate the amount of remaining free space in the output buffer
        // by subtracting the number of bytes that have been written so far
        // from the buffer's total capacity
        zlibStreamStruct.avail_out = [compressedData length] - zlibStreamStruct.total_out;
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
        
    } while ( deflateStatus == Z_OK );
    
    // Check for zlib error and convert code to usable error message if appropriate
    if (deflateStatus != Z_STREAM_END)
    {
        NSString *errorMsg = nil;
        switch (deflateStatus)
        {
            case Z_ERRNO:
                errorMsg = @"Error occured while reading file.";
                break;
            case Z_STREAM_ERROR:
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                break;
            case Z_DATA_ERROR:
                errorMsg = @"The deflate data was invalid or incomplete.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Memory could not be allocated for processing.";
                break;
            case Z_BUF_ERROR:
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        [errorMsg release];
        // Free data structures that were dynamically created for the stream.
        deflateEnd(&zlibStreamStruct);
        return nil;
    }
    // Free data structures that were dynamically created for the stream.
    deflateEnd(&zlibStreamStruct);
    [compressedData setLength: zlibStreamStruct.total_out];
    return compressedData;
}

#pragma mark - merge
- (void)merge:(NSMutableArray *)noteArray
{
    @try {
        if ([self openDataBase:_sourceDBConnection]&& [self openDataBase:_targetDBConnection]) {
            [_logHandle writeInfoLog:@"merge Note enter"];
            [_sourceDBConnection beginTransaction];
            [_targetDBConnection beginTransaction];
            _localaccountZPK = 1;
            _trashFolderZPK = 2;
            _defaultFolderZPK = 3;
            if (_targetVersion>= 9 &&_targetdbType) {//表明iOS9以上版本,note数据库也升级
                NSString *queryAccountSql = @"SELECT Z_PK,ZIDENTIFIER FROM ZICCLOUDSYNCINGOBJECT WHERE ZIDENTIFIER = 'LocalAccount' OR ZIDENTIFIER='DefaultFolder-LocalAccount' OR ZIDENTIFIER='TrashFolder-LocalAccount'";
                FMResultSet *rs = [_targetDBConnection executeQuery:queryAccountSql];
                while ([rs next]) {
                    int zpk = [rs intForColumn:@"Z_PK"];
                    NSString *identifier = [rs stringForColumn:@"ZIDENTIFIER"];
                    if ([identifier isEqualToString:@"LocalAccount"]) {
                        _localaccountZPK = zpk;
                    }else if ([identifier isEqualToString:@"DefaultFolder-LocalAccount"]){
                        _defaultFolderZPK = zpk;
                    }else if ([identifier isEqualToString:@"TrashFolder-LocalAccount"]){
                        _trashFolderZPK = zpk;
                    }
                }
                [rs close];
            }
            NSMutableDictionary *attachmentImages = [NSMutableDictionary dictionary];
            if (_sourceVersion>= 9 && _sourcedbType) {
                //获取源设备的attachmentImages集合的值
                if (_sourceVersion<10) {
                    NSString *imageListSql = @"SELECT Z_4ATTACHMENTS,Z_5PREVIEWIMAGES FROM Z_4PREVIEWIMAGES";
                    FMResultSet *rs = [_sourceDBConnection executeQuery:imageListSql];
                    while ([rs next]) {
                        int attachementId = [rs intForColumn:@"Z_4ATTACHMENTS"];
                        int preImageId = [rs intForColumn:@"Z_5PREVIEWIMAGES"];
                        if (attachementId != 0 && preImageId != 0) {
                            if (![attachmentImages.allKeys containsObject:@(attachementId)]) {
                                NSMutableArray *previewImg = [NSMutableArray array];
                                [previewImg addObject:@(preImageId)];
                                [attachmentImages setObject:previewImg forKey:@(attachementId)];
                            }else{
                                NSMutableArray *previewImg = [attachmentImages objectForKey:@(attachementId)];
                                [previewImg addObject:@(preImageId)];
                            }
                        }
                    }
                    [rs close];

                }else{
                    NSString *imageListSql = @"select Z_PK,ZATTACHMENT FROM ZICCLOUDSYNCINGOBJECT WHERE ZMARKEDFORDELETION==0 AND Z_ENT=(select Z_ENT FROM Z_PRIMARYKEY WHERE Z_NAME='ICAttachmentPreviewImage')";
                    FMResultSet *rs = [_sourceDBConnection executeQuery:imageListSql];
                    while ([rs next]) {
                        int attachementId = [rs intForColumn:@"ZATTACHMENT"];
                        int preImageId = [rs intForColumn:@"Z_PK"];
                        if (attachementId != 0 && preImageId != 0) {
                            if (![attachmentImages.allKeys containsObject:@(attachementId)]) {
                                NSMutableArray *previewImg = [NSMutableArray array];
                                [previewImg addObject:@(preImageId)];
                                [attachmentImages setObject:previewImg forKey:@(attachementId)];
                            }else{
                                NSMutableArray *previewImg = [attachmentImages objectForKey:@(attachementId)];
                                [previewImg addObject:@(preImageId)];
                            }
                        }
                    }
                    [rs close];
                }
                {
                    NSString *zentStr = @"SELECT Z_ENT,Z_NAME FROM Z_PRIMARYKEY WHERE Z_NAME='ICNote' OR Z_NAME='ICAttachment' OR Z_NAME='ICMedia' OR Z_NAME='ICAttachmentPreviewImage'";
                    FMResultSet *rs = [_sourceDBConnection executeQuery:zentStr];
                    while ([rs next]) {
                        int zpk = [rs intForColumn:@"Z_ENT"];
                        NSString *identifier = [rs stringForColumn:@"Z_NAME"];
                        if ([identifier isEqualToString:@"ICNote"]) {
                            noteZENT = zpk;
                        }else if ([identifier isEqualToString:@"ICAttachment"]) {
                            attachZENT = zpk;
                        }else if ([identifier isEqualToString:@"ICMedia"]) {
                            mediaZENT = zpk;
                        }else if ([identifier isEqualToString:@"ICAttachmentPreviewImage"]) {
                            preViewZENT = zpk;
                        }
                    }
                    [rs close];
                }
                {
                    NSString *zentStr = @"SELECT Z_ENT,Z_NAME FROM Z_PRIMARYKEY WHERE Z_NAME='ICNote' OR Z_NAME='ICAttachment' OR Z_NAME='ICMedia' OR Z_NAME='ICAttachmentPreviewImage'";
                    FMResultSet *rs = [_targetDBConnection executeQuery:zentStr];
                    while ([rs next]) {
                        int zpk = [rs intForColumn:@"Z_ENT"];
                        NSString *identifier = [rs stringForColumn:@"Z_NAME"];
                        if ([identifier isEqualToString:@"ICNote"]) {
                            noteTargetZENT = zpk;
                        }else if ([identifier isEqualToString:@"ICAttachment"]) {
                            attachTargetZENT = zpk;
                        }else if ([identifier isEqualToString:@"ICMedia"]) {
                            mediaTargetZENT = zpk;
                        }else if ([identifier isEqualToString:@"ICAttachmentPreviewImage"]) {
                            preViewTargetZENT = zpk;
                        }
                    }
                    [rs close];
                }
                if (_targetVersion >= 9) {
                    if (_targetdbType) {
                        //高到高
                        [self mergeNoteHightToHight:_sourceDBConnection targetDB:_targetDBConnection attachmentImages:attachmentImages noteArray:noteArray];
                        //copy附件
                        [self copyAttachments:_attachmentIdentifierList];
                    }else{
                        //高到低
                        [self mergeNoteHightToLow:_sourceDBConnection targetDB:_targetDBConnection noteArray:noteArray];
                    }
                }else{
                    if (_sourcedbType) {
                        //高到低
                        [self mergeNoteHightToLow:_sourceDBConnection targetDB:_targetDBConnection noteArray:noteArray];
                    }
                }
            }else {
                if (_targetVersion >= 9) {
                    if (_targetdbType) {
                        //底到高
                        [self mergeNoteLowToHight:_sourceDBConnection targetDB:_targetDBConnection noteArray:noteArray];
                    }else{
                        //底到低
                        [self mergeNoteLowToLow:_sourceDBConnection targetDB:_targetDBConnection noteArray:noteArray];
                    }
                }else{
                    //底到底
                    [self mergeNoteLowToLow:_sourceDBConnection targetDB:_targetDBConnection noteArray:noteArray];
                }
            }
            if (![_sourceDBConnection commit]) {
                [_sourceDBConnection rollback];
            }
            if (![_targetDBConnection commit]) {
                [_targetDBConnection rollback];
            }
            [_sourceDBConnection close];
            [_targetDBConnection close];
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"异常原因:%@",exception]];
    }
    [_logHandle writeInfoLog:@"merge Note exit"];
    [self modifyHashAndManifest];
}


- (int)insertToLowRecords:(IMBNoteModelEntity *)item targetDB:(FMDatabase *)targetDB
{
    int newNoteID = -1;
    NSString *IOS8InsertStr = @"insert into ZNOTE(Z_ENT, Z_OPT, ZCONTAINSCJK, ZCONTENTTYPE,ZDELETEDFLAG,ZISBOOKKEEPINGENTRY,ZBODY, ZSTORE, ZCREATIONDATE, ZMODIFICATIONDATE,ZGUID, ZTITLE) values(:Z_ENT,:Z_OPT,:ZCONTAINSCJK,:ZCONTENTTYPE,:ZDELETEDFLAG,:ZISBOOKKEEPINGENTRY, :ZBODY,:ZSTORE, :ZCREATIONDATE,:ZMODIFICATIONDATE, :ZGUID, :ZTITLE)";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    int z_ent = [self getZENT:@"Note" targetDB:targetDB];
    int storeId = [self getStoreID:targetDB];
    
    [param setObject:@(z_ent) forKey:@"Z_ENT"];
    [param setObject:@(1) forKey:@"Z_OPT"];
    [param setObject:@(0) forKey:@"ZCONTAINSCJK"];
    [param setObject:@(0) forKey:@"ZCONTENTTYPE"];
    [param setObject:@(0) forKey:@"ZISBOOKKEEPINGENTRY"];
    [param setObject:@(0) forKey:@"ZDELETEDFLAG"];
    [param setObject:@(0) forKey:@"ZBODY"];
    [param setObject:@(storeId) forKey:@"ZSTORE"];
    [param setObject:@(item.creatDate) forKey:@"ZCREATIONDATE"];
    [param setObject:@(item.creatDate) forKey:@"ZMODIFICATIONDATE"];
    [param setObject:[self createGUID] forKey:@"ZGUID"];
    [param setObject:item.title?:@"" forKey:@"ZTITLE"];
    if ([targetDB executeUpdate:IOS8InsertStr withParameterDictionary:param]) {
        NSString *sql1 = @"select last_insert_rowid() from ZNOTE";
        FMResultSet *rs1 = [targetDB executeQuery:sql1];
        while ([rs1 next]) {
            newNoteID = [rs1 intForColumn:@"last_insert_rowid()"];
        }
        [rs1 close];
        if (newNoteID != -1) {
            [self updateprimarykeyMax:targetDB Z_MAX:newNoteID Z_NAME:@"Note"];
            int z_NoteBody_ent = [self getZENT:@"NoteBody" targetDB:targetDB];
            NSString *sql = @"insert into ZNOTEBODY( Z_ENT, Z_OPT, ZOWNER, ZCONTENT) values( :Z_ENT, :Z_OPT, :ZOWNER, :ZCONTENT)";
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@(z_NoteBody_ent),@"Z_ENT",@(2),@"Z_OPT",@(newNoteID),@"ZOWNER",item.content,@"ZCONTENT", nil];
            if ([targetDB executeUpdate:sql withParameterDictionary:param]) {
                NSString *sql = @"select z_pk from znotebody where ZOWNER=:zowner";
                FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:[NSDictionary dictionaryWithObject:@(newNoteID) forKey:@"zowner"]];
                while ([rs next]) {
                    int notebodyID = [rs intForColumn:@"z_pk"];
                    NSString *sql1 = @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
                    [targetDB executeUpdate:sql1 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(notebodyID),@"Z_MAX",@"NoteBody",@"Z_NAME", nil]];
                    
                    NSString *sql2 = @"update znote set zbody=:zbody where z_pk=:z_pk";
                    [targetDB executeUpdate:sql2 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(notebodyID),@"zbody",@(newNoteID),@"z_pk", nil]];
                }
                [rs close];
            }
        }
    }
    return newNoteID;
}

- (NSTimeInterval)getTimeIntervalSince2001:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *originDate = [dateFormatter dateFromString:@"01/01/2001 00:00:00"];
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:originDate];
    [dateFormatter release];
    return timeInterval;
}

- (int)insertToHightRecords:(IMBNoteModelEntity *)item targetDB:(FMDatabase *)targetDB
{
    int newNoteID = -1;
    NSString *IOS9InsertStr = @"insert into ZICCLOUDSYNCINGOBJECT( Z_ENT, Z_OPT,ZMARKEDFORDELETION,ZACCOUNT2,ZNOTEDATA,ZCREATIONDATE,ZMODIFICATIONDATE1,ZIDENTIFIER,ZSNIPPET,ZTITLE1,ZNEEDSINITIALFETCHFROMCLOUD,ZLEGACYNOTEINTEGERID,ZNOTEHASCHANGES) values( :Z_ENT, :Z_OPT,:ZMARKEDFORDELETION,:ZACCOUNT2,:ZNOTEDATA,:ZCREATIONDATE,:ZMODIFICATIONDATE1,:ZIDENTIFIER,:ZSNIPPET,:ZTITLE1,:ZNEEDSINITIALFETCHFROMCLOUD,:ZLEGACYNOTEINTEGERID,:ZNOTEHASCHANGES)";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    int z_ent = 9;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICNote'";
    FMResultSet *rs = [targetDB executeQuery:sql];
    while ([rs next]) {
        z_ent = [rs intForColumn:@"Z_ENT"];
    }
    [rs close];
    [param setObject:@(z_ent) forKey:@"Z_ENT"];
    [param setObject:@(4) forKey:@"Z_OPT"];
    [param setObject:@(0) forKey:@"ZMARKEDFORDELETION"];
    [param setObject:@(_localaccountZPK) forKey:@"ZACCOUNT2"];
    [param setObject:@(0) forKey:@"ZNOTEDATA"];
    [param setObject:@(item.creatDate) forKey:@"ZCREATIONDATE"];
    [param setObject:@(item.modifyDate) forKey:@"ZMODIFICATIONDATE1"];
    [param setObject:[self createGUID] forKey:@"ZIDENTIFIER"];
    [param setObject:item.title?:@"" forKey:@"ZTITLE1"];
    [param setObject:item.title?:item.content forKey:@"ZSNIPPET"];
    [param setObject:@(0) forKey:@"ZNEEDSINITIALFETCHFROMCLOUD"];
    [param setObject:@(0) forKey:@"ZLEGACYNOTEINTEGERID"];
    [param setObject:@(0) forKey:@"ZNOTEHASCHANGES"];
    if ([targetDB executeUpdate:IOS9InsertStr withParameterDictionary:param]) {
        NSString *sql1 = @"select last_insert_rowid() from ZICCLOUDSYNCINGOBJECT";
        FMResultSet *rs1 = [targetDB executeQuery:sql1];
        while ([rs1 next]) {
            newNoteID = [rs1 intForColumn:@"last_insert_rowid()"];
        }
        [rs1 close];
        [self updateprimarykeyMax:targetDB Z_MAX:newNoteID Z_NAME:@"ICCloudSyncingObject"];
        int icloudstateId = [self insertICloudState:targetDB newnoteID:newNoteID zent:z_ent];
        int z_NoteData_ent = [self getZENT:@"ICNoteData" targetDB:targetDB];
        NSString *sql2 = @"insert into ZICNOTEDATA( Z_ENT,Z_OPT,ZNOTE,ZDATA) values(:Z_ENT,:Z_OPT,:ZNOTE,:ZDATA)";
        NSMutableDictionary *param2 = [NSMutableDictionary dictionary];
        [param2 setObject:@(z_NoteData_ent) forKey:@"Z_ENT"];
        [param2 setObject:@(3) forKey:@"Z_OPT"];
        [param2 setObject:@(newNoteID) forKey:@"ZNOTE"];
        NSData *notedata =  [IMBNoteClone greadData:item.content?:item.title];
        NSData *gzipData =[IMBNoteClone gzipData:notedata];
        if (gzipData) {
            [param2 setObject:gzipData forKey:@"ZDATA"];
        }else{
            [param2 setObject:[NSNull null] forKey:@"ZDATA"];
        }
        if ([targetDB executeUpdate:sql2 withParameterDictionary:param2]) {
            int notebodyID = -1;
            NSString *sql1 = @"select z_pk from ZICNOTEDATA where ZNOTE=:ZNOTE";
            FMResultSet *rs1 = [targetDB executeQuery:sql1 withParameterDictionary:[NSDictionary dictionaryWithObject:@(newNoteID) forKey:@"ZNOTE"]];
            while ([rs1 next]) {
                notebodyID = [rs1 intForColumn:@"z_pk"];
            }
            [rs1 close];
            if (notebodyID != -1) {
                [self updateprimarykeyMax:targetDB Z_MAX:notebodyID Z_NAME:@"ICNoteData"];
                NSString *sql2 = @"UPDATE ZICCLOUDSYNCINGOBJECT SET zcloudstate=:zcloudstate,znotedata=:znotedata WHERE Z_PK=:Z_PK";
                [targetDB executeUpdate:sql2 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(icloudstateId),@"zcloudstate",@(notebodyID),@"znotedata",@(newNoteID),@"Z_PK", nil]];
            }
        }
    }
    return newNoteID;
}

- (void)mergeNoteLowToLow:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB noteArray:(NSMutableArray *)noteArray
{
    for (IMBNoteModelEntity *entity in noteArray) {
        [self insertnoteLowToLow:entity.zpk sourceDB:sourceDB targetDB:targetDB];
    }
}

- (void)insertnoteLowToLow:(int)item sourceDB:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    int newNoteID = -1;
    NSString *sql1 = @"select * from ZNOTE where Z_PK=:noteID";
    NSString *sql2 = @"insert into ZNOTE(Z_ENT,Z_OPT,ZCONTAINSCJK,ZCONTENTTYPE,ZDELETEDFLAG,ZEXTERNALFLAGS,ZEXTERNALSERVERINTID,ZINTEGERID,ZISBOOKKEEPINGENTRY,ZBODY,ZSTORE,ZCREATIONDATE,ZMODIFICATIONDATE,ZGUID,ZSERVERID,ZSUMMARY,ZTITLE) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:item] forKey:@"noteID"];
    FMResultSet *rs = [sourceDB executeQuery:sql1 withParameterDictionary:dic];
    while ([rs next]) {
        int Z_ENT = [self getZENT:@"Note" targetDB:targetDB];;
        int Z_OPT = [rs intForColumn:@"Z_OPT"];
        int ZCONTAINSCJK = [rs intForColumn:@"ZCONTAINSCJK"];
        int ZCONTENTTYPE = [rs intForColumn:@"ZCONTENTTYPE"];
        int ZDELETEDFLAG = [rs intForColumn:@"ZDELETEDFLAG"];
        int ZEXTERNALFLAGS = [rs intForColumn:@"ZEXTERNALFLAGS"];
        int ZEXTERNALSERVERINTID = [rs intForColumn:@"ZEXTERNALSERVERINTID"];
        int ZINTEGERID = [rs intForColumn:@"ZINTEGERID"];
        int ZISBOOKKEEPINGENTRY = [rs intForColumn:@"ZISBOOKKEEPINGENTRY"];
        int ZBODY = [rs intForColumn:@"ZBODY"];
        int newZBODY = [self mergeZNOTEBODY:ZBODY sourceDB:sourceDB targetDB:targetDB];
        int ZSTORE = [self getStoreID:targetDB];
        double ZCREATIONDATE = [rs doubleForColumn:@"ZCREATIONDATE"];
        double ZMODIFICATIONDATE = [rs doubleForColumn:@"ZMODIFICATIONDATE"];
        NSString *ZGUID = [rs stringForColumn:@"ZGUID"];
        NSString *ZSERVERID = [rs stringForColumn:@"ZSERVERID"];
        NSString *ZSUMMARY = [rs stringForColumn:@"ZSUMMARY"];
        NSString *ZTITLE = [rs stringForColumn:@"ZTITLE"];
        if ([targetDB executeUpdate:sql2,[NSNumber numberWithInt:Z_ENT],[NSNumber numberWithInt:Z_OPT],[NSNumber numberWithInt:ZCONTAINSCJK],[NSNumber numberWithInt:ZCONTENTTYPE],[NSNumber numberWithInt:ZDELETEDFLAG],[NSNumber numberWithInt:ZEXTERNALFLAGS],[NSNumber numberWithInt:ZEXTERNALSERVERINTID],[NSNumber numberWithInt:ZINTEGERID],[NSNumber numberWithInt:ZISBOOKKEEPINGENTRY],[NSNumber numberWithInt:newZBODY],[NSNumber numberWithInt:ZSTORE],[NSNumber numberWithDouble:ZCREATIONDATE],[NSNumber numberWithDouble:ZMODIFICATIONDATE],ZGUID,ZSERVERID,ZSUMMARY,ZTITLE]) {
            NSString *sql3 = @"select last_insert_rowid() from ZNOTE";
            FMResultSet *rs1 = [targetDB executeQuery:sql3];
            while ([rs1 next]) {
                newNoteID = [rs1 intForColumn:@"last_insert_rowid()"];
            }
            [rs1 close];
            [self updateprimarykeyMax:targetDB Z_MAX:newNoteID Z_NAME:@"NoteBody"];
        }
    }
    [rs close];
}

- (int)mergeZNOTEBODY:(int)noteBodyID sourceDB:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [_logHandle writeInfoLog:@"merge table ZNOTEBODY enter"];
    int newnoteBody = -1;
    NSString *sql1 = @"select * from ZNOTEBODY where Z_PK=:noteBodyID";
    NSString *sql2 = @"insert into ZNOTEBODY(Z_ENT,Z_OPT,ZOWNER,ZCONTENT,ZEXTERNALCONTENTREF,ZEXTERNALREPRESENTATION) values(?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:noteBodyID] forKey:@"noteBodyID"];
    FMResultSet *rs = [sourceDB executeQuery:sql1 withParameterDictionary:dic];
    while ([rs next]) {
        int Z_ENT = [self getZENT:@"NoteBody" targetDB:targetDB];
        int Z_OPT = [rs intForColumn:@"Z_OPT"];
        int ZOWNER = [rs intForColumn:@"ZOWNER"];
        NSString *ZCONTENT = [rs stringForColumn:@"ZCONTENT"];
        NSString *ZEXTERNALCONTENTREF = [rs stringForColumn:@"ZEXTERNALCONTENTREF"];
        NSData *ZEXTERNALREPRESENTATION = [rs dataForColumn:@"ZEXTERNALREPRESENTATION"];
        BOOL success = [targetDB executeUpdate:sql2,[NSNumber numberWithInt:Z_ENT],[NSNumber numberWithInt:Z_OPT],[NSNumber numberWithInt:ZOWNER],ZCONTENT,ZEXTERNALCONTENTREF,ZEXTERNALREPRESENTATION];
        if (success) {
            NSString *sql3 = @"select last_insert_rowid() from ZNOTEBODY";
            FMResultSet *rs1 = [targetDB executeQuery:sql3];
            while ([rs1 next]) {
                newnoteBody = [rs1 intForColumn:@"last_insert_rowid()"];
            }
            [rs1 close];
            [self updateprimarykeyMax:targetDB Z_MAX:newnoteBody Z_NAME:@"NoteBody"];
            
        }
    }
    [rs close];
    [_logHandle writeInfoLog:@"merge table ZNOTEBODY exit"];
    return newnoteBody;
}

- (void)updateprimarykeyMax:(FMDatabase *)targetDB Z_MAX:(int)Z_MAX Z_NAME:(NSString *)Z_NAME
{
    NSString *sql1 = @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
    [targetDB executeUpdate:sql1 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(Z_MAX),@"Z_MAX",Z_NAME,@"Z_NAME", nil]];
}

- (int)getZENT:(NSString *)Name targetDB:(FMDatabase *)targetDB
{
    int Z_ENT = -1;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME=:NoteBody";
    FMResultSet *set = [targetDB executeQuery:sql withParameterDictionary:[NSDictionary dictionaryWithObject:Name forKey:@"NoteBody"]];
    while ([set next]) {
        Z_ENT = [set intForColumn:@"Z_ENT"];
    }
    [set close];
    return Z_ENT;
}

- (int)getStoreID:(FMDatabase *)targetDB
{
    int storeID=1;
    NSString *sql = @"select Z_PK from ZSTORE where ZNAME='LOCAL_NOTES_STORE'";
    FMResultSet *set = [targetDB executeQuery:sql];
    while ([set next]) {
        storeID = [set intForColumn:@"Z_PK"];
        
    }
    [set close];
    return storeID;
}

- (void)mergeNoteLowToHight:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB noteArray:(NSMutableArray *)noteArray
{
    for (IMBNoteModelEntity *entity in noteArray) {
        int newNoteid = [self insertLowToZICCLOUDSYNCINGOBJECTRecords:entity.zpk sourceDB:sourceDB targetDB:targetDB];
        if (newNoteid > 0)
        {
            //插入一天记录到Z_12NOTES表
            //InsertLowToZICNOTEDATARecords(newNoteid, targetCmd);
            [self insert12NOTESRecord:_defaultFolderZPK newNoteID:newNoteid targetDB:targetDB];
        }
    }
}

- (int)insertLowToZICCLOUDSYNCINGOBJECTRecords:(int)item sourceDB:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    int sourceVersion = _sourceVersion;
    int newNoteID = -1;
    NSString *IOS8SelectStr = @"SELECT ZNOTE.Z_OPT, ZCONTAINSCJK, ZCONTENTTYPE, ZDELETEDFLAG, ZEXTERNALFLAGS, ZEXTERNALSERVERINTID, ZINTEGERID, ZISBOOKKEEPINGENTRY, ZBODY, ZSTORE, ZCREATIONDATE, ZMODIFICATIONDATE, ZAUTHOR, ZGUID, ZSERVERID, ZSUMMARY, ZTITLE,ZCONTENT FROM ZNOTE left join ZNOTEBODY on ZNOTE.ZBODY==ZNOTEBODY.Z_PK where ZNOTE.Z_PK=:Z_PK";
    NSString *IOS6SelectStr = @"SELECT ZNOTE.Z_OPT, ZCONTAINSCJK, ZCONTENTTYPE, ZDELETEDFLAG, ZEXTERNALFLAGS,ZEXTERNALSERVERINTID, ZINTEGERID, ZISBOOKKEEPINGENTRY, ZBODY, ZSTORE, ZCREATIONDATE, ZMODIFICATIONDATE, ZAUTHOR, ZGUID, ZSERVERID, ZSUMMARY, ZTITLE,ZCONTENT FROM ZNOTE left join ZNOTEBODY on ZNOTE.ZBODY==ZNOTEBODY.Z_PK where ZNOTE.Z_PK=:Z_PK";
    NSString *IOS9InsertStr = @"insert into ZICCLOUDSYNCINGOBJECT( Z_ENT, Z_OPT,ZMARKEDFORDELETION,ZACCOUNT2,ZNOTEDATA,ZCREATIONDATE,ZMODIFICATIONDATE1,ZIDENTIFIER,ZSNIPPET,ZTITLE1,ZNEEDSINITIALFETCHFROMCLOUD,ZLEGACYNOTEINTEGERID,ZNOTEHASCHANGES) values(:Z_ENT,:Z_OPT,:ZMARKEDFORDELETION,:ZACCOUNT2,:ZNOTEDATA,:ZCREATIONDATE,:ZMODIFICATIONDATE1,:ZIDENTIFIER,:ZSNIPPET,:ZTITLE1,:ZNEEDSINITIALFETCHFROMCLOUD,:ZLEGACYNOTEINTEGERID,:ZNOTEHASCHANGES)";
    NSString *IOS10InsertStr = @"insert into ZICCLOUDSYNCINGOBJECT(Z_ENT, Z_OPT,ZMINIMUMSUPPORTEDNOTESVERSION,ZMARKEDFORDELETION,ZNEEDSTOSAVEUSERSPECIFICRECORD,ZATTACHMENTVIEWTYPE,ZACCOUNT2,ZNOTEDATA,ZCREATIONDATE1,ZMODIFICATIONDATE1,ZIDENTIFIER,ZSNIPPET,ZTITLE1,ZNEEDSINITIALFETCHFROMCLOUD,ZLEGACYNOTEINTEGERID,ZNOTEHASCHANGES) values(:Z_ENT,:Z_OPT,:ZMINIMUMSUPPORTEDNOTESVERSION,:ZMARKEDFORDELETION,:ZNEEDSTOSAVEUSERSPECIFICRECORD,:ZATTACHMENTVIEWTYPE,:ZACCOUNT2,:ZNOTEDATA,:ZCREATIONDATE1,:ZMODIFICATIONDATE1,:ZIDENTIFIER,:ZSNIPPET,:ZTITLE1,:ZNEEDSINITIALFETCHFROMCLOUD,:ZLEGACYNOTEINTEGERID,:ZNOTEHASCHANGES)";
    
    NSString *IOS11InsertStr = @"insert into ZICCLOUDSYNCINGOBJECT(Z_ENT, Z_OPT,ZMINIMUMSUPPORTEDNOTESVERSION,ZMARKEDFORDELETION,ZNEEDSTOSAVEUSERSPECIFICRECORD,ZATTACHMENTVIEWTYPE,ZACCOUNT2,ZNOTEDATA,ZCREATIONDATE1,ZMODIFICATIONDATE1,ZIDENTIFIER,ZSNIPPET,ZTITLE1,ZNEEDSINITIALFETCHFROMCLOUD,ZNOTEHASCHANGES,ZFOLDER) values(:Z_ENT,:Z_OPT,:ZMINIMUMSUPPORTEDNOTESVERSION,:ZMARKEDFORDELETION,:ZNEEDSTOSAVEUSERSPECIFICRECORD,:ZATTACHMENTVIEWTYPE,:ZACCOUNT2,:ZNOTEDATA,:ZCREATIONDATE1,:ZMODIFICATIONDATE1,:ZIDENTIFIER,:ZSNIPPET,:ZTITLE1,:ZNEEDSINITIALFETCHFROMCLOUD,:ZNOTEHASCHANGES,:ZFOLDER)";
    
    
    int z_ent = 9;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICNote'";
    FMResultSet *rs = [targetDB executeQuery:sql];
    while ([rs next]) {
        z_ent = [rs intForColumn:@"Z_ENT"];
    }
    [rs close];
    NSString *insertStr = nil;
    if (sourceVersion >= 7){
        insertStr = IOS8SelectStr;
    }else {
        insertStr = IOS6SelectStr;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    FMResultSet *insertRS = [sourceDB executeQuery:IOS8SelectStr withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(item),@"Z_PK", nil]];
    while ([insertRS next]) {
        [param setObject:@(z_ent) forKey:@"Z_ENT"];
        [param setObject:[insertRS objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [param setObject:@(0) forKey:@"ZMARKEDFORDELETION"];
        [param setObject:@(_localaccountZPK) forKey:@"ZACCOUNT2"];
        [param setObject:@(0) forKey:@"ZNOTEDATA"];
        if (_targetVersion >= 10) {
            [param setObject:@(0) forKey:@"ZATTACHMENTVIEWTYPE"];
            [param setObject:@(1) forKey:@"ZNEEDSTOSAVEUSERSPECIFICRECORD"];
            [param setObject:@(0) forKey:@"ZMINIMUMSUPPORTEDNOTESVERSION"];
        }
        if (_targetVersion >= 10) {
            [param setObject:@([insertRS doubleForColumn:@"ZCREATIONDATE"]) forKey:@"ZCREATIONDATE1"];
        }else{
            [param setObject:@([insertRS doubleForColumn:@"ZCREATIONDATE"]) forKey:@"ZCREATIONDATE"];
        }
        
        [param setObject:@([insertRS doubleForColumn:@"ZMODIFICATIONDATE"]) forKey:@"ZMODIFICATIONDATE1"];
        [param setObject:[self createGUID] forKey:@"ZIDENTIFIER"];
        [param setObject:[insertRS objectForColumnName:@"ZTITLE"] forKey:@"ZTITLE1"];
        [param setObject:[insertRS objectForColumnName:@"ZTITLE"] forKey:@"ZSNIPPET"];
        [param setObject:@(0) forKey:@"ZNEEDSINITIALFETCHFROMCLOUD"];
        
        if (_targetVersion<11) {
            [param setObject:@(0) forKey:@"ZLEGACYNOTEINTEGERID"];
        }else{
            [param setObject:@(_defaultFolderZPK) forKey:@"ZFOLDER"];
        }
        [param setObject:@(0) forKey:@"ZNOTEHASCHANGES"];
        NSString *insertStr = nil;
        if (_targetVersion>=11) {
            insertStr = IOS11InsertStr;
        }else if (_targetVersion >= 10) {
            insertStr = IOS10InsertStr;
        }else{
            insertStr = IOS9InsertStr;
        }
        if ([targetDB executeUpdate:insertStr withParameterDictionary:param]) {
            NSString *sql = @"select last_insert_rowid() from ZICCLOUDSYNCINGOBJECT";
            FMResultSet *rs = [_targetDBConnection executeQuery:sql];
            while ([rs next]) {
                newNoteID = [rs intForColumn:@"last_insert_rowid()"];
            }
            [rs close];
            NSString *sql1 = @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
            [targetDB executeUpdate:sql1 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(newNoteID),@"Z_MAX",@"ICCloudSyncingObject",@"Z_NAME", nil]];
            int icloudstateId = [self insertICloudState:targetDB newnoteID:newNoteID zent:z_ent];
            int z_NoteData_ent = -1;
            NSString *sql2 = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICNoteData'";
            FMResultSet *rs2 = [targetDB executeQuery:sql2];
            while ([rs2 next]) {
                z_NoteData_ent = [rs2 intForColumn:@"Z_ENT"];
            }
            [rs2 close];
            if (z_NoteData_ent != -1) {
                NSString *sql3 = @"insert into ZICNOTEDATA( Z_ENT,Z_OPT,ZNOTE,ZDATA) values(:Z_ENT,:Z_OPT,:ZNOTE,:ZDATA)";
                NSMutableDictionary *param3 = [NSMutableDictionary dictionary];
                [param3 setObject:@(z_NoteData_ent) forKey:@"Z_ENT"];
                [param3 setObject:@(1) forKey:@"Z_OPT"];
                [param3 setObject:@(newNoteID) forKey:@"ZNOTE"];
                NSString *noteContent = [insertRS stringForColumn:@"ZCONTENT"];
                NSData *notedata =  [IMBNoteClone greadData:noteContent];
                NSData *gzipData =  [IMBNoteClone gzipData:notedata];
                if (gzipData) {
                    [param3 setObject:gzipData forKey:@"ZDATA"];
                }else{
                    [param3 setObject:[NSNull null] forKey:@"ZDATA"];
                }
                if ([targetDB executeUpdate:sql3 withParameterDictionary:param3]) {
                    int notebodyID = -1;
                    NSString *sql1 = @"select z_pk from ZICNOTEDATA where ZNOTE=:ZNOTE";
                    FMResultSet *rs1 = [targetDB executeQuery:sql1 withParameterDictionary:[NSDictionary dictionaryWithObject:@(newNoteID) forKey:@"ZNOTE"]];
                    while ([rs1 next]) {
                        notebodyID = [rs1 intForColumn:@"z_pk"];
                    }
                    [rs1 close];
                    if (notebodyID != -1) {
                        NSString *sql1 = @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
                        [targetDB executeUpdate:sql1 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(notebodyID),@"Z_MAX",@"ICNoteData",@"Z_NAME", nil]];
                        NSString *sql2 = @"UPDATE ZICCLOUDSYNCINGOBJECT SET zcloudstate=:zcloudstate,znotedata=:znotedata WHERE Z_PK=:Z_PK";
                        [targetDB executeUpdate:sql2 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(icloudstateId),@"zcloudstate",@(notebodyID),@"znotedata",@(newNoteID),@"Z_PK", nil]];
                    }
                }
            }
        }
    }
    [insertRS close];
    
    return newNoteID;
}

- (void)mergeNoteHightToLow:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB noteArray:(NSMutableArray *)noteArray
{
    for (IMBNoteModelEntity *entity in noteArray) {
        [self insertAvove9ToZNOTERecords:entity sourceDB:sourceDB targetDB:targetDB];
    }
}
//高到低
- (int)insertAvove9ToZNOTERecords:(IMBNoteModelEntity *)item sourceDB:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    int newNoteID = -1;
    NSString *IOS9SelectStr = @"SELECT note.Z_OPT,ZMARKEDFORDELETION,ZNOTEDATA,ZDATA,ZCREATIONDATE,ZMODIFICATIONDATE1,ZIDENTIFIER,ZSNIPPET,ZTITLE1,note.Z_ENT FROM ZICCLOUDSYNCINGOBJECT as note left join ZICNOTEDATA as noteData on note.ZNOTEDATA=noteData.Z_PK where note.Z_PK=:Z_PK and ZCLOUDSTATE IS NOT NULL";
    NSString *IOS8InsertStr = @"insert into ZNOTE(Z_ENT, Z_OPT, ZCONTAINSCJK, ZCONTENTTYPE,ZDELETEDFLAG,ZISBOOKKEEPINGENTRY,ZBODY, ZSTORE, ZCREATIONDATE, ZMODIFICATIONDATE,ZGUID, ZTITLE) values(:Z_ENT,:Z_OPT,:ZCONTAINSCJK,:ZCONTENTTYPE,:ZDELETEDFLAG,:ZISBOOKKEEPINGENTRY, :ZBODY,:ZSTORE, :ZCREATIONDATE,:ZMODIFICATIONDATE, :ZGUID, :ZTITLE)";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    int z_ent = 3;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='Note'";
    FMResultSet *rs = [targetDB executeQuery:sql];
    while ([rs next]) {
        z_ent = [rs intForColumn:@"Z_ENT"];
    }
    [rs close];
    
    int storeId = 1;
    NSString *sql1 = @"select Z_PK from ZSTORE where ZNAME='LOCAL_NOTES_STORE'";
    FMResultSet *rs1 = [targetDB executeQuery:sql1];
    while ([rs1 next]) {
        storeId = [rs1 intForColumn:@"Z_PK"];
    }
    [rs1 close];
    
    FMResultSet *noters = [sourceDB executeQuery:IOS9SelectStr withParameterDictionary:[NSDictionary dictionaryWithObject:@(item.zpk) forKey:@"Z_PK"]];
    while ([noters next]) {
        [param setObject:@(z_ent) forKey:@"Z_ENT"];
        [param setObject:@(1) forKey:@"Z_OPT"];
        [param setObject:@(0) forKey:@"ZCONTAINSCJK"];
        [param setObject:@(0) forKey:@"ZCONTENTTYPE"];
        [param setObject:@(0) forKey:@"ZISBOOKKEEPINGENTRY"];
        [param setObject:@(0) forKey:@"ZDELETEDFLAG"];
        [param setObject:@(0) forKey:@"ZBODY"];
        [param setObject:@(storeId) forKey:@"ZSTORE"];
        [param setObject:@([noters doubleForColumn:@"ZCREATIONDATE"]) forKey:@"ZCREATIONDATE"];
        [param setObject:@([noters doubleForColumn:@"ZCREATIONDATE"]) forKey:@"ZMODIFICATIONDATE"];
        [param setObject:[noters objectForColumnName:@"ZIDENTIFIER"] forKey:@"ZGUID"];
        [param setObject:[noters objectForColumnName:@"ZTITLE1"] forKey:@"ZTITLE"];
        if ([targetDB executeUpdate:IOS8InsertStr withParameterDictionary:param]) {
            NSString *sql = @"select last_insert_rowid() from ZNOTE";
            FMResultSet *rs = [_targetDBConnection executeQuery:sql];
            while ([rs next]) {
                newNoteID = [rs intForColumn:@"last_insert_rowid()"];
            }
            [rs close];
            
            NSString *sql1 = @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
            [targetDB executeUpdate:sql1 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(newNoteID),@"Z_MAX",@"Note",@"Z_NAME", nil]];
            
            int z_NoteBody_ent = 4;
            NSString *sql2 = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='NoteBody'";
            FMResultSet *rs2 = [targetDB executeQuery:sql2];
            while ([rs2 next]) {
                z_NoteBody_ent = [rs2 intForColumn:@"Z_ENT"];
            }
            [rs2 close];
            
            NSString *sql3 = @"insert into ZNOTEBODY(Z_ENT, Z_OPT, ZOWNER, ZCONTENT) values( :Z_ENT, :Z_OPT, :ZOWNER, :ZCONTENT)";
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:@(z_NoteBody_ent) forKey:@"Z_ENT"];
            [param setObject:@([noters intForColumn:@"Z_OPT"]) forKey:@"Z_OPT"];
            [param setObject:@(newNoteID) forKey:@"ZOWNER"];
            NSString *content = item.content;
            if (content) {
                [param setObject:content forKey:@"ZCONTENT"];
            }else{
                [param setObject:[NSNull null] forKey:@"ZCONTENT"];
            }
            if ([targetDB executeUpdate:sql3 withParameterDictionary:param]) {
                NSString *sql = @"select z_pk from znotebody where ZOWNER=:zowner";
                FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:[NSDictionary dictionaryWithObject:@(newNoteID) forKey:@"zowner"]];
                while ([rs next]) {
                    int notebodyID = [rs intForColumn:@"z_pk"];
                    NSString *sql1 = @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
                    [targetDB executeUpdate:sql1 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(notebodyID),@"Z_MAX",@"NoteBody",@"Z_NAME", nil]];
                    
                    NSString *sql2 = @"update znote set zbody=:zbody where z_pk=:z_pk";
                    [targetDB executeUpdate:sql2 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(notebodyID),@"zbody",@(newNoteID),@"z_pk", nil]];
                }
                [rs close];
            }
        }
    }
    [noters close];
    return newNoteID;
}

- (NSMutableArray *)getAllIdArray:(NSMutableArray *)noteArray
{
    NSMutableArray *idArray = [NSMutableArray array];
    for (IMBNoteModelEntity *entity in noteArray) {
        [idArray addObject:@(entity.zpk)];
        for (IMBNoteAttachmentEntity *noteAttach in entity.attachmentAry) {
            [idArray addObject:@(noteAttach.zpk)];
            [idArray addObject:@(noteAttach.mediaId)];
            [idArray addObjectsFromArray:noteAttach.allPreviewId];
        }
    }
    return idArray;
}

- (void)mergeNoteHightToHight:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB attachmentImages:(NSMutableDictionary *)attachmentImages noteArray:(NSMutableArray *)noteArray
{
    NSMutableDictionary *noteObjectIDList = [NSMutableDictionary dictionary];
    NSMutableDictionary *mediaIDList = [NSMutableDictionary dictionary];
    NSMutableArray *idArray = [self getAllIdArray:noteArray];
    for (NSNumber *zpk in idArray) {
        @autoreleasepool {
            [self insertZICCLOUDSYNCINGOBJECTRecords:zpk.intValue attachmentImages:attachmentImages noteObjectIDList:noteObjectIDList mediaIDList:mediaIDList sourceDB:sourceDB targetDB:targetDB];
        }
    }
}

- (void)copyAttachments:(NSMutableArray *)attachfilePathArray
{
    if ([attachfilePathArray count] == 0) {
        return;
    }
    NSMutableArray *sourceRecodArray = _sourcerecordArray;
    NSMutableArray *previewsRecordArray = [NSMutableArray array];
    NSMutableArray *mediaRecordArray = [NSMutableArray array];
    for (IMBMBFileRecord *record in sourceRecodArray) {
        if ([record.path hasPrefix:
             @"Previews"] && [record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"]) {
            if ([record.path isEqualToString:@"Previews"]) {
                [previewsRecordArray addObject:record];
            }
            for (NSString *path in attachfilePathArray) {
                if ([record.path isEqualToString:path]&&![previewsRecordArray containsObject:record]) {
                    [previewsRecordArray addObject:record];
                }
            }
        }
        if ([record.path hasPrefix:
             @"Media"] && [record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"]) {
            if ([record.path isEqualToString:@"Media"]) {
                [mediaRecordArray addObject:record];
            }
            for (NSString *path in attachfilePathArray) {
                if ([record.path isEqualToString:path]&&![mediaRecordArray containsObject:record]) {
                    [mediaRecordArray addObject:record];
                }
            }
        }
    }
    if ([_targetFloatVersion isVersionLess:@"10"]) {
        NSMutableArray *targetRecodArray = _targetrecordArray;
        NSMutableArray *targetRecodArray1 = [NSMutableArray array];
        NSMutableArray *targetRecodArray2 = [NSMutableArray array];
        NSMutableArray *tarpreviewsRecordArray = [NSMutableArray array];
        NSMutableArray *tarmediaRecordArray = [NSMutableArray array];
        NSMutableArray *tarpreviewssameRecord = [NSMutableArray array];
        NSMutableArray*tarmediasameRecord = [NSMutableArray array];
        BOOL canAdd = YES;
        for (IMBMBFileRecord *record in targetRecodArray) {
            if (canAdd) {
                [targetRecodArray1 addObject:record];
            }else
            {
                if (([record.path isEqualToString:
                      @"Previews"]&&[record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"])||([record.path isEqualToString:
                                                                                                                @"Media"]&&[record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"])) {
                    continue;
                }
                [targetRecodArray2 addObject:record];
            }
            
            if ([record.path isEqualToString:@""]&&[record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"]) {
                canAdd = NO;
            }
            if ([record.path hasPrefix:
                 @"Previews/"]&&[record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"]) {
                [tarpreviewsRecordArray addObject:record];
                for (IMBMBFileRecord *sRecord in previewsRecordArray) {
                    if ([record.path isEqualToString:sRecord.path]) {
                        [tarpreviewssameRecord addObject:sRecord];
                    }
                }
            }
            if ([record.path hasPrefix:
                 @"Media/"]&&[record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"]) {
                [tarmediaRecordArray addObject:record];
                for (IMBMBFileRecord *sRecord in mediaRecordArray) {
                    if ([record.path isEqualToString:sRecord.path]) {
                        [tarmediasameRecord addObject:sRecord];
                    }
                }
            }
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [targetRecodArray removeAllObjects];
        [targetRecodArray addObjectsFromArray:targetRecodArray1];
        [previewsRecordArray removeObjectsInArray:tarpreviewssameRecord];
        //进行拷贝文件
        for (IMBMBFileRecord *record in previewsRecordArray) {
            NSString *fkey = [record.key substringWithRange:NSMakeRange(0, 2)];
            NSString *sourcePath = nil;
            if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                sourcePath = [folderPath stringByAppendingPathComponent:record.key];
            }else{
                sourcePath = [_sourceBackuppath stringByAppendingPathComponent:record.key];
            }

            NSString *desPath = [_targetBakcuppath stringByAppendingPathComponent:record.key];
            if ([fileManager fileExistsAtPath:desPath]) {
                [fileManager removeItemAtPath:desPath error:nil];
            }
            if ([fileManager fileExistsAtPath:sourcePath]) {
                [record setDataHash:[IMBBaseClone dataHashfilePath:sourcePath]];
                int64_t fileSize = [IMBUtilTool fileSizeAtPath:sourcePath];
                [record changeFileLength:fileSize];
                [fileManager copyItemAtPath:sourcePath toPath:desPath error:nil];
            }
        }
        [previewsRecordArray insertObjects:tarpreviewsRecordArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, [tarpreviewsRecordArray count])]];
        [targetRecodArray addObjectsFromArray:previewsRecordArray];
        [mediaRecordArray removeObjectsInArray:tarmediasameRecord];
        //进行拷贝文件
        for (IMBMBFileRecord *record in mediaRecordArray) {
            NSString *fkey = [record.key substringWithRange:NSMakeRange(0, 2)];
            NSString *sourcePath = nil;
            if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                sourcePath = [folderPath stringByAppendingPathComponent:record.key];
            }else{
                sourcePath = [_sourceBackuppath stringByAppendingPathComponent:record.key];
            }

            NSString *desPath = [_targetBakcuppath stringByAppendingPathComponent:record.key];
            if ([fileManager fileExistsAtPath:desPath]) {
                [fileManager removeItemAtPath:desPath error:nil];
            }
            if ([fileManager fileExistsAtPath:sourcePath]) {
                [record setDataHash:[IMBBaseClone dataHashfilePath:sourcePath]];
                int64_t fileSize = [IMBUtilTool fileSizeAtPath:sourcePath];
                [record changeFileLength:fileSize];
                [fileManager copyItemAtPath:sourcePath toPath:desPath error:nil];
            }
        }
        [mediaRecordArray insertObjects:tarmediaRecordArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, [tarmediaRecordArray count])]];
        [targetRecodArray addObjectsFromArray:mediaRecordArray];
        [targetRecodArray2 removeObjectsInArray:tarpreviewsRecordArray];
        [targetRecodArray2 removeObjectsInArray:tarmediaRecordArray];
        [targetRecodArray addObjectsFromArray:targetRecodArray2];
    }else{
        if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
            if ([mediaRecordArray count]==0&&[previewsRecordArray count]==0) {
                return;
            }else{
                NSMutableArray *attachRecordArray = [NSMutableArray array];
                [attachRecordArray addObjectsFromArray:previewsRecordArray];
                [attachRecordArray addObjectsFromArray:mediaRecordArray];
                [self createAttachmentPlist:attachRecordArray TargetDB:_targetManifestDBConnection];
            }
        }
    }
    
}

- (void)createAttachmentPlist:(NSMutableArray *)sourceattachmentRecordArray TargetDB:(FMDatabase *)targetDB
{
    if ([self openDataBase:targetDB]) {
        [self openDataBase:_sourceManifestDBConnection];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //首先查看目标数据库是否存在一样的
        NSString *querySql = @"SELECT rowid,file FROM Files where relativePath =:relativePath and domain=:domain";
        for (IMBMBFileRecord *record in sourceattachmentRecordArray) {
            BOOL isexsited = NO;
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:record.path,@"relativePath",record.domain,@"domain", nil];
            FMResultSet *rs = [targetDB executeQuery:querySql withParameterDictionary:param];
            while ([rs next]) {
                isexsited = YES;
                break;
            }
            [rs close];
            if (!isexsited) {
                //开始构建plist
                NSString *insertSql = @"insert into Files(fileID, domain, relativePath, flags, file) values(:fileID, :domain, :relativePath, :flags, :file)";
                NSMutableDictionary *insertParams = [NSMutableDictionary dictionary];
                [insertParams setObject:record.key forKey:@"fileID"];
                [insertParams setObject:record.domain forKey:@"domain"];
                [insertParams setObject:record.path forKey:@"relativePath"];
                NSData *data = nil;
                if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                    NSString *querySql1 = @"SELECT rowid,file FROM Files where fileID =:fileID";
                    NSDictionary *param1 = [NSDictionary dictionaryWithObject:record.key forKey:@"fileID"];
                    FMResultSet *rs1 = [_sourceManifestDBConnection executeQuery:querySql1 withParameterDictionary:param1];
                    while ([rs1 next]) {
                        data = [rs1 dataForColumn:@"file"];
                    }
                    [rs1 close];
                    if (record.filetype == FileType_Backup) {
                        [insertParams setObject:@(1) forKey:@"flags"];
                    }else{
                        [insertParams setObject:@(2) forKey:@"flags"];
                    }
                }else{
                    if (record.filetype == FileType_Backup) {
                        data = [self createPlist:record createHash:YES];
                        [insertParams setObject:@(1) forKey:@"flags"];
                    }else{
                        data = [self createPlist:record createHash:NO];
                        [insertParams setObject:@(2) forKey:@"flags"];
                    }
                }
                if (data) {
                    [insertParams setObject:data forKey:@"file"];
                    if ([targetDB executeUpdate:insertSql withParameterDictionary:insertParams]) {
                        //开始拷贝文件
                        if (record.filetype == FileType_Backup) {
                            NSString *fkey = [record.key substringWithRange:NSMakeRange(0, 2)];
                            NSString *folderPath = [_targetBakcuppath stringByAppendingPathComponent:fkey];
                            NSString *targetfilePath = [folderPath stringByAppendingPathComponent:record.key];
                            NSString *sourcefilePath = nil;
                            if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                                NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                                sourcefilePath = [folderPath stringByAppendingPathComponent:record.key];
                            }else{
                                sourcefilePath = [_sourceBackuppath stringByAppendingPathComponent:record.key];
                            }
                            if ([fileManager fileExistsAtPath:folderPath]&&[fileManager fileExistsAtPath:sourcefilePath]) {
                                if ([fileManager fileExistsAtPath:targetfilePath]) {
                                    [fileManager removeItemAtPath:targetfilePath error:nil];
                                }
                                [fileManager copyItemAtPath:sourcefilePath toPath:targetfilePath error:nil];
                            }else{
                                if ([fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil]&&[fileManager fileExistsAtPath:sourcefilePath]) {
                                    [fileManager copyItemAtPath:sourcefilePath toPath:targetfilePath error:nil];
                                }
                            }
                        }
                    }
                }
            }
        }
        [self closeDataBase:targetDB];
        [self closeDataBase:_sourceManifestDBConnection];
    }
}

- (NSData *)createPlist:(IMBMBFileRecord *)record createHash:(BOOL)createHash
{
    NSData *data = nil;
    NSMutableDictionary *firstDic = [NSMutableDictionary dictionary];
    [firstDic setObject:@"NSKeyedArchiver" forKey:@"$archiver"];
    NSMutableArray *objectsList = [NSMutableArray array];
    [objectsList addObject:@"$null"];
    NSMutableDictionary *objectsDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *classDic = [NSMutableDictionary dictionary];
    [classDic setObject:@(3) forKey:@"CF$UID"];
    [objectsDic setObject:classDic forKey:@"$class"];
    [objectsDic setObject:@((long long)[[NSDate date] timeIntervalSince1970]) forKey:@"Birth"];
    [objectsDic setObject:@(record.userId) forKey:@"GroupID"];
    [objectsDic setObject:@(record.inode) forKey:@"InodeNumber"];
    [objectsDic setObject:@((long long)[[NSDate date] timeIntervalSince1970]) forKey:@"LastModified"];
    [objectsDic setObject:@((long long)[[NSDate date] timeIntervalSince1970]) forKey:@"LastStatusChange"];
    [objectsDic setObject:@(record.mode) forKey:@"Mode"];
    if (createHash) {
        [objectsDic setObject:@(3) forKey:@"ProtectionClass"];
    }else{
        [objectsDic setObject:@(0) forKey:@"ProtectionClass"];
    }
    NSMutableDictionary *RelativePathDic = [NSMutableDictionary dictionary];
    [RelativePathDic setObject:@(2) forKey:@"CF$UID"];
    [objectsDic setObject:RelativePathDic forKey:@"RelativePath"];
    [objectsDic setObject:@(record.fileLength) forKey:@"Size"];
    [objectsDic setObject:@(record.userId) forKey:@"UserID"];
    [objectsList addObject:objectsDic];
    [objectsList addObject:record.path];
    NSMutableDictionary *endDic = [NSMutableDictionary dictionary];
    NSMutableArray *endClassesDic = [NSMutableArray array];
    [endClassesDic addObject:@"MBFile"];
    [endClassesDic addObject:@"NSObject"];
    [endDic setObject:endClassesDic forKey:@"$classes"];
    [endDic setObject:@"MBFile" forKey:@"$classname"];
    [objectsList addObject:endDic];
    [firstDic setObject:objectsList forKey:@"$objects"];
    NSMutableDictionary *topDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
    [rootDic setObject:@(1) forKey:@"CF$UID"];
    [topDic setObject:rootDic forKey:@"root"];
    [firstDic setObject:topDic forKey:@"$top"];
    [firstDic setObject:@(100000) forKey:@"$version"];
    data = [firstDic toData];
    return data;
}



- (int)insertZICCLOUDSYNCINGOBJECTRecords:(int)sourcenoteID attachmentImages:(NSMutableDictionary *)attachmentImages noteObjectIDList:(NSMutableDictionary *)noteIDList mediaIDList:(NSMutableDictionary *)mediaIDList sourceDB:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    int newNoteID = -1;
    BOOL isAlreadyExist = false;
    int isMarkDeletedFlag = -1;
    NSString *IOS11SelectStr = @"SELECT  Z_ENT,Z_OPT,ZMODIFICATIONDATE,ZMODIFIEDDATE,ZPREVIEWUPDATEDATE,ZSTATEMODIFICATIONDATE,ZMODIFICATIONDATEATIMPORT,ZCREATIONDATE1,ZLEGACYMODIFICATIONDATEATIMPORT,ZMODIFICATIONDATE1,ZDATEFORLASTTITLEMODIFICATION,ZPARENTMODIFICATIONDATE,ZMARKEDFORDELETION,ZNEEDSINITIALFETCHFROMCLOUD,ZNEEDSTOBEFETCHEDFROMCLOUD,ZCLOUDSTATE,ZCHECKEDFORLOCATION,ZFILESIZE,ZORIENTATION,ZSECTION,ZLOCATION,ZMEDIA,ZNOTE,ZSCALEWHENDRAWING,ZSTATE,ZACCOUNT,ZTYPE,ZACCOUNT1,ZLEGACYNOTEWASPLAINTEXT,ZNOTEHASCHANGES,ZACCOUNT2,ZNOTEDATA,ZISHIDDENNOTECONTAINER,ZSORTORDER,ZOWNER,ZACCOUNTTYPE,ZDIDCHOOSETOMIGRATE,ZDIDFINISHMIGRATION,ZDIDMIGRATEONMAC,ZFOLDERTYPE,ZIMPORTEDFROMLEGACY,ZACCOUNT3,ZPARENT,ZDURATION,ZORIGINX,ZORIGINY,ZSIZEHEIGHT,ZSIZEWIDTH,ZHEIGHT,ZSCALE,ZWIDTH,ZIDENTIFIER,ZSUMMARY,ZTITLE,ZTYPEUTI,ZURLSTRING,ZDEVICEIDENTIFIER,ZCONTENTHASHATIMPORT,ZFILENAME,ZLEGACYCONTENTHASHATIMPORT,ZLEGACYIMPORTDEVICEIDENTIFIER,ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,ZSNIPPET,ZTHUMBNAILATTACHMENTIDENTIFIER,ZTITLE1,ZACCOUNTNAMEFORACCOUNTLISTSORTING,ZNESTEDTITLEFORSORTING,ZNAME,ZUSERRECORDNAME,ZTITLE2,ZMERGEABLEDATA,ZMETADATA,ZATTACHMENT FROM ZICCLOUDSYNCINGOBJECT where Z_PK=:Z_PK and ZCLOUDSTATE IS NOT NULL and ZMARKEDFORDELETION!=1";
    
    NSString *IOS10SelectStr = @"SELECT  Z_ENT,Z_OPT,ZMODIFICATIONDATE,ZMODIFIEDDATE,ZPREVIEWUPDATEDATE,ZSTATEMODIFICATIONDATE,ZMODIFICATIONDATEATIMPORT,ZCREATIONDATE1,ZFOLDERSMODIFICATIONDATE,ZLEGACYMODIFICATIONDATEATIMPORT,ZMODIFICATIONDATE1,ZDATEFORLASTTITLEMODIFICATION,ZPARENTMODIFICATIONDATE,ZMARKEDFORDELETION,ZNEEDSINITIALFETCHFROMCLOUD,ZNEEDSTOBEFETCHEDFROMCLOUD,ZCLOUDSTATE,ZCHECKEDFORLOCATION,ZFILESIZE,ZORIENTATION,ZSECTION,ZLOCATION,ZMEDIA,ZNOTE,ZSCALEWHENDRAWING,ZSTATE,ZACCOUNT,ZTYPE,ZACCOUNT1,ZINTEGERID,ZLEGACYNOTEINTEGERID,ZLEGACYNOTEWASPLAINTEXT,ZNOTEHASCHANGES,ZACCOUNT2,ZNOTEDATA,ZISHIDDENNOTECONTAINER,ZSORTORDER,ZOWNER,ZACCOUNTTYPE,ZDIDCHOOSETOMIGRATE,ZDIDFINISHMIGRATION,ZDIDMIGRATEONMAC,ZFOLDERTYPE,ZIMPORTEDFROMLEGACY,ZACCOUNT3,ZPARENT,ZDURATION,ZORIGINX,ZORIGINY,ZSIZEHEIGHT,ZSIZEWIDTH,ZHEIGHT,ZSCALE,ZWIDTH,ZIDENTIFIER,ZSUMMARY,ZTITLE,ZTYPEUTI,ZURLSTRING,ZDEVICEIDENTIFIER,ZCONTENTHASHATIMPORT,ZFILENAME,ZLEGACYCONTENTHASHATIMPORT,ZLEGACYIMPORTDEVICEIDENTIFIER,ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,ZSNIPPET,ZTHUMBNAILATTACHMENTIDENTIFIER,ZTITLE1,ZACCOUNTNAMEFORACCOUNTLISTSORTING,ZNESTEDTITLEFORSORTING,ZNAME,ZUSERRECORDNAME,ZTITLE2,ZSERVERRECORD,ZREMOTEFILEURL,ZMERGEABLEDATA,ZMETADATA,ZATTACHMENT FROM ZICCLOUDSYNCINGOBJECT where Z_PK=:Z_PK and ZCLOUDSTATE IS NOT NULL and ZMARKEDFORDELETION!=1";
    NSString *IOS9SelectStr = @"SELECT  Z_ENT,Z_OPT,ZMODIFICATIONDATE,ZMODIFIEDDATE,ZPREVIEWUPDATEDATE,ZSTATEMODIFICATIONDATE,ZMODIFICATIONDATEATIMPORT,ZCREATIONDATE,ZFOLDERSMODIFICATIONDATE,ZLEGACYMODIFICATIONDATEATIMPORT,ZMODIFICATIONDATE1,ZDATEFORLASTTITLEMODIFICATION,ZPARENTMODIFICATIONDATE,ZMARKEDFORDELETION,ZNEEDSINITIALFETCHFROMCLOUD,ZNEEDSTOBEFETCHEDFROMCLOUD,ZCLOUDSTATE,ZCHECKEDFORLOCATION,ZFILESIZE,ZORIENTATION,ZSECTION,ZLOCATION,ZMEDIA,ZNOTE,ZSCALEWHENDRAWING,ZSTATE,ZACCOUNT,ZTYPE,ZACCOUNT1,ZINTEGERID,ZLEGACYNOTEINTEGERID,ZLEGACYNOTEWASPLAINTEXT,ZNOTEHASCHANGES,ZACCOUNT2,ZNOTEDATA,ZISHIDDENNOTECONTAINER,ZSORTORDER,ZOWNER,ZACCOUNTTYPE,ZDIDCHOOSETOMIGRATE,ZDIDFINISHMIGRATION,ZDIDMIGRATEONMAC,ZFOLDERTYPE,ZIMPORTEDFROMLEGACY,ZACCOUNT3,ZPARENT,ZDURATION,ZORIGINX,ZORIGINY,ZSIZEHEIGHT,ZSIZEWIDTH,ZHEIGHT,ZSCALE,ZWIDTH,ZIDENTIFIER,ZSUMMARY,ZTITLE,ZTYPEUTI,ZURLSTRING,ZDEVICEIDENTIFIER,ZCONTENTHASHATIMPORT,ZFILENAME,ZLEGACYCONTENTHASHATIMPORT,ZLEGACYIMPORTDEVICEIDENTIFIER,ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,ZSNIPPET,ZTHUMBNAILATTACHMENTIDENTIFIER,ZTITLE1,ZACCOUNTNAMEFORACCOUNTLISTSORTING,ZNESTEDTITLEFORSORTING,ZNAME,ZUSERRECORDNAME,ZTITLE2,ZSERVERRECORD,ZREMOTEFILEURL,ZMERGEABLEDATA,ZMETADATA FROM ZICCLOUDSYNCINGOBJECT where Z_PK=:Z_PK and ZCLOUDSTATE IS NOT NULL and ZMARKEDFORDELETION!=1";
    NSString *IOS9InsertStr = @"insert into ZICCLOUDSYNCINGOBJECT (Z_ENT,Z_OPT,ZMARKEDFORDELETION,ZNEEDSINITIALFETCHFROMCLOUD,ZNEEDSTOBEFETCHEDFROMCLOUD,ZCLOUDSTATE,ZCHECKEDFORLOCATION,ZFILESIZE,ZORIENTATION,ZSECTION,ZLOCATION,ZMEDIA,ZNOTE,ZSCALEWHENDRAWING,ZSTATE,ZACCOUNT,ZTYPE,ZACCOUNT1,ZINTEGERID,ZLEGACYNOTEINTEGERID,ZLEGACYNOTEWASPLAINTEXT,ZNOTEHASCHANGES,ZACCOUNT2,ZNOTEDATA,ZISHIDDENNOTECONTAINER,ZSORTORDER,ZOWNER,ZACCOUNTTYPE,ZDIDCHOOSETOMIGRATE,ZDIDFINISHMIGRATION,ZDIDMIGRATEONMAC,ZFOLDERTYPE,ZIMPORTEDFROMLEGACY,ZACCOUNT3,ZPARENT,ZDURATION,ZMODIFICATIONDATE,ZORIGINX,ZORIGINY,ZPREVIEWUPDATEDATE,ZSIZEHEIGHT,ZSIZEWIDTH,ZHEIGHT,ZMODIFIEDDATE,ZSCALE,ZWIDTH,ZSTATEMODIFICATIONDATE,ZMODIFICATIONDATEATIMPORT,ZCREATIONDATE,ZFOLDERSMODIFICATIONDATE,ZLEGACYMODIFICATIONDATEATIMPORT,ZMODIFICATIONDATE1,ZDATEFORLASTTITLEMODIFICATION,ZPARENTMODIFICATIONDATE,ZIDENTIFIER,ZSUMMARY,ZTITLE,ZTYPEUTI,ZURLSTRING,ZDEVICEIDENTIFIER,ZCONTENTHASHATIMPORT,ZFILENAME,ZLEGACYCONTENTHASHATIMPORT,ZLEGACYIMPORTDEVICEIDENTIFIER,ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,ZSNIPPET,ZTHUMBNAILATTACHMENTIDENTIFIER,ZTITLE1,ZACCOUNTNAMEFORACCOUNTLISTSORTING,ZNESTEDTITLEFORSORTING,ZNAME,ZUSERRECORDNAME,ZTITLE2,ZSERVERRECORD,ZREMOTEFILEURL,ZMERGEABLEDATA,ZMETADATA)values(:Z_ENT,:Z_OPT,:ZMARKEDFORDELETION,:ZNEEDSINITIALFETCHFROMCLOUD,:ZNEEDSTOBEFETCHEDFROMCLOUD,:ZCLOUDSTATE,:ZCHECKEDFORLOCATION,:ZFILESIZE,:ZORIENTATION,:ZSECTION,:ZLOCATION,:ZMEDIA,:ZNOTE,:ZSCALEWHENDRAWING,:ZSTATE,:ZACCOUNT,:ZTYPE,:ZACCOUNT1,:ZINTEGERID,:ZLEGACYNOTEINTEGERID,:ZLEGACYNOTEWASPLAINTEXT,:ZNOTEHASCHANGES,:ZACCOUNT2,:ZNOTEDATA,:ZISHIDDENNOTECONTAINER,:ZSORTORDER,:ZOWNER,:ZACCOUNTTYPE,:ZDIDCHOOSETOMIGRATE,:ZDIDFINISHMIGRATION,:ZDIDMIGRATEONMAC,:ZFOLDERTYPE,:ZIMPORTEDFROMLEGACY,:ZACCOUNT3,:ZPARENT,:ZDURATION,:ZMODIFICATIONDATE,:ZORIGINX,:ZORIGINY,:ZPREVIEWUPDATEDATE,:ZSIZEHEIGHT,:ZSIZEWIDTH,:ZHEIGHT,:ZMODIFIEDDATE,:ZSCALE,:ZWIDTH,:ZSTATEMODIFICATIONDATE,:ZMODIFICATIONDATEATIMPORT,:ZCREATIONDATE,:ZFOLDERSMODIFICATIONDATE,:ZLEGACYMODIFICATIONDATEATIMPORT,:ZMODIFICATIONDATE1,:ZDATEFORLASTTITLEMODIFICATION,:ZPARENTMODIFICATIONDATE,:ZIDENTIFIER,:ZSUMMARY,:ZTITLE,:ZTYPEUTI,:ZURLSTRING,:ZDEVICEIDENTIFIER,:ZCONTENTHASHATIMPORT,:ZFILENAME,:ZLEGACYCONTENTHASHATIMPORT,:ZLEGACYIMPORTDEVICEIDENTIFIER,:ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,:ZSNIPPET,:ZTHUMBNAILATTACHMENTIDENTIFIER,:ZTITLE1,:ZACCOUNTNAMEFORACCOUNTLISTSORTING,:ZNESTEDTITLEFORSORTING,:ZNAME,:ZUSERRECORDNAME,:ZTITLE2,:ZSERVERRECORD,:ZREMOTEFILEURL,:ZMERGEABLEDATA,:ZMETADATA)";
    NSString *IOS10InsertStr = @"insert into ZICCLOUDSYNCINGOBJECT (Z_ENT,Z_OPT,ZMARKEDFORDELETION,ZNEEDSINITIALFETCHFROMCLOUD,ZNEEDSTOBEFETCHEDFROMCLOUD,ZNEEDSTOSAVEUSERSPECIFICRECORD,ZMINIMUMSUPPORTEDNOTESVERSION,ZATTACHMENTVIEWTYPE,ZCLOUDSTATE,ZCHECKEDFORLOCATION,ZFILESIZE,ZORIENTATION,ZSECTION,ZLOCATION,ZMEDIA,ZNOTE,ZSCALEWHENDRAWING,ZSTATE,ZACCOUNT,ZTYPE,ZACCOUNT1,ZINTEGERID,ZLEGACYNOTEINTEGERID,ZLEGACYNOTEWASPLAINTEXT,ZNOTEHASCHANGES,ZACCOUNT2,ZNOTEDATA,ZISHIDDENNOTECONTAINER,ZSORTORDER,ZOWNER,ZACCOUNTTYPE,ZDIDCHOOSETOMIGRATE,ZDIDFINISHMIGRATION,ZDIDMIGRATEONMAC,ZFOLDERTYPE,ZIMPORTEDFROMLEGACY,ZACCOUNT3,ZPARENT,ZDURATION,ZMODIFICATIONDATE,ZORIGINX,ZORIGINY,ZPREVIEWUPDATEDATE,ZSIZEHEIGHT,ZSIZEWIDTH,ZHEIGHT,ZMODIFIEDDATE,ZSCALE,ZWIDTH,ZSTATEMODIFICATIONDATE,ZMODIFICATIONDATEATIMPORT,ZCREATIONDATE1,ZFOLDERSMODIFICATIONDATE,ZLEGACYMODIFICATIONDATEATIMPORT,ZMODIFICATIONDATE1,ZDATEFORLASTTITLEMODIFICATION,ZPARENTMODIFICATIONDATE,ZIDENTIFIER,ZSUMMARY,ZTITLE,ZTYPEUTI,ZURLSTRING,ZDEVICEIDENTIFIER,ZCONTENTHASHATIMPORT,ZFILENAME,ZLEGACYCONTENTHASHATIMPORT,ZLEGACYIMPORTDEVICEIDENTIFIER,ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,ZSNIPPET,ZTHUMBNAILATTACHMENTIDENTIFIER,ZTITLE1,ZACCOUNTNAMEFORACCOUNTLISTSORTING,ZNESTEDTITLEFORSORTING,ZNAME,ZUSERRECORDNAME,ZTITLE2,ZSERVERRECORD,ZREMOTEFILEURL,ZMERGEABLEDATA,ZMETADATA,ZATTACHMENT)values(:Z_ENT,:Z_OPT,:ZMARKEDFORDELETION,:ZNEEDSINITIALFETCHFROMCLOUD,:ZNEEDSTOBEFETCHEDFROMCLOUD,:ZNEEDSTOSAVEUSERSPECIFICRECORD,:ZMINIMUMSUPPORTEDNOTESVERSION,:ZATTACHMENTVIEWTYPE,:ZCLOUDSTATE,:ZCHECKEDFORLOCATION,:ZFILESIZE,:ZORIENTATION,:ZSECTION,:ZLOCATION,:ZMEDIA,:ZNOTE,:ZSCALEWHENDRAWING,:ZSTATE,:ZACCOUNT,:ZTYPE,:ZACCOUNT1,:ZINTEGERID,:ZLEGACYNOTEINTEGERID,:ZLEGACYNOTEWASPLAINTEXT,:ZNOTEHASCHANGES,:ZACCOUNT2,:ZNOTEDATA,:ZISHIDDENNOTECONTAINER,:ZSORTORDER,:ZOWNER,:ZACCOUNTTYPE,:ZDIDCHOOSETOMIGRATE,:ZDIDFINISHMIGRATION,:ZDIDMIGRATEONMAC,:ZFOLDERTYPE,:ZIMPORTEDFROMLEGACY,:ZACCOUNT3,:ZPARENT,:ZDURATION,:ZMODIFICATIONDATE,:ZORIGINX,:ZORIGINY,:ZPREVIEWUPDATEDATE,:ZSIZEHEIGHT,:ZSIZEWIDTH,:ZHEIGHT,:ZMODIFIEDDATE,:ZSCALE,:ZWIDTH,:ZSTATEMODIFICATIONDATE,:ZMODIFICATIONDATEATIMPORT,:ZCREATIONDATE1,:ZFOLDERSMODIFICATIONDATE,:ZLEGACYMODIFICATIONDATEATIMPORT,:ZMODIFICATIONDATE1,:ZDATEFORLASTTITLEMODIFICATION,:ZPARENTMODIFICATIONDATE,:ZIDENTIFIER,:ZSUMMARY,:ZTITLE,:ZTYPEUTI,:ZURLSTRING,:ZDEVICEIDENTIFIER,:ZCONTENTHASHATIMPORT,:ZFILENAME,:ZLEGACYCONTENTHASHATIMPORT,:ZLEGACYIMPORTDEVICEIDENTIFIER,:ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,:ZSNIPPET,:ZTHUMBNAILATTACHMENTIDENTIFIER,:ZTITLE1,:ZACCOUNTNAMEFORACCOUNTLISTSORTING,:ZNESTEDTITLEFORSORTING,:ZNAME,:ZUSERRECORDNAME,:ZTITLE2,:ZSERVERRECORD,:ZREMOTEFILEURL,:ZMERGEABLEDATA,:ZMETADATA,:ZATTACHMENT)";
    NSString *IOS11InsertStr = @"insert into ZICCLOUDSYNCINGOBJECT (Z_ENT,Z_OPT,ZMARKEDFORDELETION,ZNEEDSINITIALFETCHFROMCLOUD,ZNEEDSTOBEFETCHEDFROMCLOUD,ZNEEDSTOSAVEUSERSPECIFICRECORD,ZMINIMUMSUPPORTEDNOTESVERSION,ZATTACHMENTVIEWTYPE,ZCLOUDSTATE,ZCHECKEDFORLOCATION,ZFILESIZE,ZORIENTATION,ZSECTION,ZLOCATION,ZMEDIA,ZNOTE,ZSCALEWHENDRAWING,ZSTATE,ZACCOUNT,ZTYPE,ZACCOUNT1,ZLEGACYNOTEWASPLAINTEXT,ZNOTEHASCHANGES,ZACCOUNT2,ZNOTEDATA,ZISHIDDENNOTECONTAINER,ZSORTORDER,ZOWNER,ZACCOUNTTYPE,ZDIDCHOOSETOMIGRATE,ZDIDFINISHMIGRATION,ZDIDMIGRATEONMAC,ZFOLDERTYPE,ZIMPORTEDFROMLEGACY,ZACCOUNT3,ZPARENT,ZDURATION,ZMODIFICATIONDATE,ZORIGINX,ZORIGINY,ZPREVIEWUPDATEDATE,ZSIZEHEIGHT,ZSIZEWIDTH,ZHEIGHT,ZMODIFIEDDATE,ZSCALE,ZWIDTH,ZSTATEMODIFICATIONDATE,ZMODIFICATIONDATEATIMPORT,ZCREATIONDATE1,ZLEGACYMODIFICATIONDATEATIMPORT,ZMODIFICATIONDATE1,ZDATEFORLASTTITLEMODIFICATION,ZPARENTMODIFICATIONDATE,ZIDENTIFIER,ZSUMMARY,ZTITLE,ZTYPEUTI,ZURLSTRING,ZDEVICEIDENTIFIER,ZCONTENTHASHATIMPORT,ZFILENAME,ZLEGACYCONTENTHASHATIMPORT,ZLEGACYIMPORTDEVICEIDENTIFIER,ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,ZSNIPPET,ZTHUMBNAILATTACHMENTIDENTIFIER,ZTITLE1,ZACCOUNTNAMEFORACCOUNTLISTSORTING,ZNESTEDTITLEFORSORTING,ZNAME,ZUSERRECORDNAME,ZTITLE2,ZMERGEABLEDATA,ZMETADATA,ZATTACHMENT,ZFOLDER,ZPAPERSTYLETYPE,ZISPINNED)values(:Z_ENT,:Z_OPT,:ZMARKEDFORDELETION,:ZNEEDSINITIALFETCHFROMCLOUD,:ZNEEDSTOBEFETCHEDFROMCLOUD,:ZNEEDSTOSAVEUSERSPECIFICRECORD,:ZMINIMUMSUPPORTEDNOTESVERSION,:ZATTACHMENTVIEWTYPE,:ZCLOUDSTATE,:ZCHECKEDFORLOCATION,:ZFILESIZE,:ZORIENTATION,:ZSECTION,:ZLOCATION,:ZMEDIA,:ZNOTE,:ZSCALEWHENDRAWING,:ZSTATE,:ZACCOUNT,:ZTYPE,:ZACCOUNT1,:ZLEGACYNOTEWASPLAINTEXT,:ZNOTEHASCHANGES,:ZACCOUNT2,:ZNOTEDATA,:ZISHIDDENNOTECONTAINER,:ZSORTORDER,:ZOWNER,:ZACCOUNTTYPE,:ZDIDCHOOSETOMIGRATE,:ZDIDFINISHMIGRATION,:ZDIDMIGRATEONMAC,:ZFOLDERTYPE,:ZIMPORTEDFROMLEGACY,:ZACCOUNT3,:ZPARENT,:ZDURATION,:ZMODIFICATIONDATE,:ZORIGINX,:ZORIGINY,:ZPREVIEWUPDATEDATE,:ZSIZEHEIGHT,:ZSIZEWIDTH,:ZHEIGHT,:ZMODIFIEDDATE,:ZSCALE,:ZWIDTH,:ZSTATEMODIFICATIONDATE,:ZMODIFICATIONDATEATIMPORT,:ZCREATIONDATE1,:ZLEGACYMODIFICATIONDATEATIMPORT,:ZMODIFICATIONDATE1,:ZDATEFORLASTTITLEMODIFICATION,:ZPARENTMODIFICATIONDATE,:ZIDENTIFIER,:ZSUMMARY,:ZTITLE,:ZTYPEUTI,:ZURLSTRING,:ZDEVICEIDENTIFIER,:ZCONTENTHASHATIMPORT,:ZFILENAME,:ZLEGACYCONTENTHASHATIMPORT,:ZLEGACYIMPORTDEVICEIDENTIFIER,:ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,:ZSNIPPET,:ZTHUMBNAILATTACHMENTIDENTIFIER,:ZTITLE1,:ZACCOUNTNAMEFORACCOUNTLISTSORTING,:ZNESTEDTITLEFORSORTING,:ZNAME,:ZUSERRECORDNAME,:ZTITLE2,:ZMERGEABLEDATA,:ZMETADATA,:ZATTACHMENT,:ZFOLDER,:ZPAPERSTYLETYPE,:ZISPINNED)";
    NSDictionary *selectParam = [NSDictionary dictionaryWithObject:@(sourcenoteID) forKey:@"Z_PK"];
    NSMutableDictionary *insertParam = [NSMutableDictionary dictionary];
    int noteIndex = 0;
    int mediaID = 0;
    int zent = 0;
    int currentzent = 0;
    FMResultSet *selectRS = nil;
    if (_sourceVersion >=11) {
        selectRS = [sourceDB executeQuery:IOS11SelectStr withParameterDictionary:selectParam];
    }else if (_sourceVersion>=10) {
        selectRS = [sourceDB executeQuery:IOS10SelectStr withParameterDictionary:selectParam];

    }else{
        selectRS = [sourceDB executeQuery:IOS9SelectStr withParameterDictionary:selectParam];
    }
    while ([selectRS next]) {
        zent = [selectRS intForColumn:@"Z_ENT"];
        if (zent == noteZENT)
        {
            //执行操作插入一条12note数据
            currentzent = noteTargetZENT;
            noteIndex = noteZENT;
        }
        else if (zent == attachZENT)
        {
            currentzent =attachTargetZENT;
            noteIndex = attachZENT;
        }
        else if (zent == mediaZENT)
        {
            currentzent = mediaTargetZENT;
            noteIndex = mediaZENT;
        }
        else if (zent == preViewZENT)
        {
            currentzent = preViewTargetZENT;
            noteIndex = preViewZENT;
        }else{
            currentzent = zent;
        }
        [insertParam setObject:@(currentzent) forKey:@"Z_ENT"];
        [insertParam setObject:[selectRS objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZMARKEDFORDELETION"] forKey:@"ZMARKEDFORDELETION"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZNEEDSINITIALFETCHFROMCLOUD"] forKey:@"ZNEEDSINITIALFETCHFROMCLOUD"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZNEEDSTOBEFETCHEDFROMCLOUD"] forKey:@"ZNEEDSTOBEFETCHEDFROMCLOUD"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZCLOUDSTATE"] forKey:@"ZCLOUDSTATE"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZCHECKEDFORLOCATION"] forKey:@"ZCHECKEDFORLOCATION"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZFILESIZE"] forKey:@"ZFILESIZE"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZORIENTATION"] forKey:@"ZORIENTATION"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZSECTION"] forKey:@"ZSECTION"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZLOCATION"] forKey:@"ZLOCATION"];
        if (zent == attachZENT) {
            mediaID = [selectRS intForColumn:@"ZMEDIA"];
            [insertParam setObject:@(-1) forKey:@"ZMEDIA"];
            int znote = [selectRS intForColumn:@"ZNOTE"];
            if (noteIDList.count >0) {
                for (NSNumber *key in noteIDList.allKeys) {
                    if (key.intValue == znote) {
                        NSNumber *tarGetKey = [noteIDList objectForKey:key];
                        [insertParam setObject:tarGetKey forKey:@"ZNOTE"];
                        break;
                    }
                }
            }else{
                [insertParam setObject:[selectRS objectForColumnName:@"ZNOTE"] forKey:@"ZNOTE"];
            }
        }else{
            [insertParam setObject:[selectRS objectForColumnName:@"ZMEDIA"] forKey:@"ZMEDIA"];
            [insertParam setObject:[selectRS objectForColumnName:@"ZNOTE"] forKey:@"ZNOTE"];
        }
        [insertParam setObject:[selectRS objectForColumnName:@"ZSCALEWHENDRAWING"] forKey:@"ZSCALEWHENDRAWING"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZSTATE"] forKey:@"ZSTATE"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZACCOUNT"] forKey:@"ZACCOUNT"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZTYPE"] forKey:@"ZTYPE"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZACCOUNT1"] forKey:@"ZACCOUNT1"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZLEGACYNOTEWASPLAINTEXT"] forKey:@"ZLEGACYNOTEWASPLAINTEXT"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZNOTEHASCHANGES"] forKey:@"ZNOTEHASCHANGES"];
        if (zent == noteZENT) {
            [insertParam setObject:@(_localaccountZPK) forKey:@"ZACCOUNT2"];
        }else{
            [insertParam setObject:[NSNull null] forKey:@"ZACCOUNT2"];
        }
        [insertParam setObject:[selectRS objectForColumnName:@"ZNOTEDATA"] forKey:@"ZNOTEDATA"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZSORTORDER"] forKey:@"ZSORTORDER"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZISHIDDENNOTECONTAINER"] forKey:@"ZISHIDDENNOTECONTAINER"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZOWNER"] forKey:@"ZOWNER"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZACCOUNTTYPE"] forKey:@"ZACCOUNTTYPE"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZDIDCHOOSETOMIGRATE"] forKey:@"ZDIDCHOOSETOMIGRATE"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZDIDFINISHMIGRATION"] forKey:@"ZDIDFINISHMIGRATION"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZDIDMIGRATEONMAC"] forKey:@"ZDIDMIGRATEONMAC"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZFOLDERTYPE"] forKey:@"ZFOLDERTYPE"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZIMPORTEDFROMLEGACY"] forKey:@"ZIMPORTEDFROMLEGACY"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZACCOUNT3"] forKey:@"ZACCOUNT3"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZPARENT"] forKey:@"ZPARENT"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZDURATION"] forKey:@"ZDURATION"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZMODIFICATIONDATE"] forKey:@"ZMODIFICATIONDATE"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZORIGINX"] forKey:@"ZORIGINX"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZORIGINY"] forKey:@"ZORIGINY"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZPREVIEWUPDATEDATE"] forKey:@"ZPREVIEWUPDATEDATE"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZSIZEHEIGHT"] forKey:@"ZSIZEHEIGHT"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZSIZEWIDTH"] forKey:@"ZSIZEWIDTH"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZHEIGHT"] forKey:@"ZHEIGHT"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZMODIFIEDDATE"] forKey:@"ZMODIFIEDDATE"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZSCALE"] forKey:@"ZSCALE"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZWIDTH"] forKey:@"ZWIDTH"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZSTATEMODIFICATIONDATE"] forKey:@"ZSTATEMODIFICATIONDATE"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZMODIFICATIONDATEATIMPORT"] forKey:@"ZMODIFICATIONDATEATIMPORT"];
        if (_targetVersion>=10) {
            [insertParam setObject:[selectRS objectForColumnIndex:7] forKey:@"ZCREATIONDATE1"];

        }else{
            [insertParam setObject:[selectRS objectForColumnIndex:7] forKey:@"ZCREATIONDATE"];

        }
        
        if (_targetVersion >= 11) {
            if (zent == noteZENT) {
                [insertParam setObject:@(_defaultFolderZPK) forKey:@"ZFOLDER"];
                [insertParam setObject:@(1) forKey:@"ZPAPERSTYLETYPE"];
                [insertParam setObject:@(0) forKey:@"ZISPINNED"];
                
            }else{
                [insertParam setObject:[NSNull null] forKey:@"ZPAPERSTYLETYPE"];
                [insertParam setObject:[NSNull null] forKey:@"ZFOLDER"];
                [insertParam setObject:[NSNull null] forKey:@"ZISPINNED"];
                
            }
        }else{
            if (_sourceVersion<11) {
                [insertParam setObject:[selectRS objectForColumnName:@"ZFOLDERSMODIFICATIONDATE"] forKey:@"ZFOLDERSMODIFICATIONDATE"];
                [insertParam setObject:[selectRS objectForColumnName:@"ZLEGACYNOTEINTEGERID"] forKey:@"ZLEGACYNOTEINTEGERID"];
                [insertParam setObject:[selectRS objectForColumnName:@"ZINTEGERID"] forKey:@"ZINTEGERID"];
                [insertParam setObject:[selectRS objectForColumnName:@"ZSERVERRECORD"] forKey:@"ZSERVERRECORD"];
                [insertParam setObject:[selectRS objectForColumnName:@"ZREMOTEFILEURL"] forKey:@"ZREMOTEFILEURL"];
            }else{
                [insertParam setObject:[NSNull null] forKey:@"ZFOLDERSMODIFICATIONDATE"];
                [insertParam setObject:[NSNull null] forKey:@"ZLEGACYNOTEINTEGERID"];
                [insertParam setObject:[NSNull null] forKey:@"ZINTEGERID"];
                [insertParam setObject:[NSNull null] forKey:@"ZSERVERRECORD"];
                [insertParam setObject:[NSNull null] forKey:@"ZREMOTEFILEURL"];
            }
        }
        [insertParam setObject:[selectRS objectForColumnName:@"ZLEGACYMODIFICATIONDATEATIMPORT"] forKey:@"ZLEGACYMODIFICATIONDATEATIMPORT"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZMODIFICATIONDATE1"] forKey:@"ZMODIFICATIONDATE1"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZDATEFORLASTTITLEMODIFICATION"] forKey:@"ZDATEFORLASTTITLEMODIFICATION"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZPARENTMODIFICATIONDATE"] forKey:@"ZPARENTMODIFICATIONDATE"];
        if (_targetVersion>=10 &&zent == noteZENT) {
            [insertParam setObject:[NSNull null] forKey:@"ZATTACHMENTVIEWTYPE"];
            [insertParam setObject:[NSNull null] forKey:@"ZNEEDSTOSAVEUSERSPECIFICRECORD"];
            [insertParam setObject:@(0) forKey:@"ZMINIMUMSUPPORTEDNOTESVERSION"];
        }else if (_targetVersion>=10 &&zent != noteZENT){
            [insertParam setObject:@(0) forKey:@"ZATTACHMENTVIEWTYPE"];
            [insertParam setObject:@(1) forKey:@"ZNEEDSTOSAVEUSERSPECIFICRECORD"];
            [insertParam setObject:@(0) forKey:@"ZMINIMUMSUPPORTEDNOTESVERSION"];
        }
        
        if (_targetVersion>=10) {
            [insertParam setObject:[NSNull null] forKey:@"ZATTACHMENT"];
        }
        
        id identifier = [selectRS objectForColumnName:@"ZIDENTIFIER"];
        [insertParam setObject:identifier forKey:@"ZIDENTIFIER"];
        
        [insertParam setObject:[selectRS objectForColumnName:@"ZSUMMARY"] forKey:@"ZSUMMARY"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZTITLE"] forKey:@"ZTITLE"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZTYPEUTI"] forKey:@"ZTYPEUTI"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZURLSTRING"] forKey:@"ZURLSTRING"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZDEVICEIDENTIFIER"] forKey:@"ZDEVICEIDENTIFIER"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZCONTENTHASHATIMPORT"] forKey:@"ZCONTENTHASHATIMPORT"];
        id fileName = [selectRS objectForColumnName:@"ZFILENAME"];
        [insertParam setObject:fileName forKey:@"ZFILENAME"];
        if (zent == preViewZENT) {
            NSString *identiPath = [NSString stringWithFormat:@"Previews/%@.png",identifier];
            [_attachmentIdentifierList addObject:identiPath];
        }else if (zent == mediaZENT){
            NSString *identifolderPath = [NSString stringWithFormat:@"Media/%@",identifier];
            [_attachmentIdentifierList addObject:identifolderPath];
            NSString *identiPath = [NSString stringWithFormat:@"Media/%@/%@",identifier,fileName];
            [_attachmentIdentifierList addObject:identiPath];
        }
        [insertParam setObject:[selectRS objectForColumnName:@"ZLEGACYCONTENTHASHATIMPORT"] forKey:@"ZLEGACYCONTENTHASHATIMPORT"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZLEGACYIMPORTDEVICEIDENTIFIER"] forKey:@"ZLEGACYIMPORTDEVICEIDENTIFIER"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION"] forKey:@"ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZSNIPPET"] forKey:@"ZSNIPPET"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZTHUMBNAILATTACHMENTIDENTIFIER"] forKey:@"ZTHUMBNAILATTACHMENTIDENTIFIER"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZTITLE1"] forKey:@"ZTITLE1"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZACCOUNTNAMEFORACCOUNTLISTSORTING"] forKey:@"ZACCOUNTNAMEFORACCOUNTLISTSORTING"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZNESTEDTITLEFORSORTING"] forKey:@"ZNESTEDTITLEFORSORTING"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZNAME"] forKey:@"ZNAME"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZUSERRECORDNAME"] forKey:@"ZUSERRECORDNAME"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZTITLE2"] forKey:@"ZTITLE2"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZMERGEABLEDATA"] forKey:@"ZMERGEABLEDATA"];
        [insertParam setObject:[selectRS objectForColumnName:@"ZMETADATA"] forKey:@"ZMETADATA"];
        
        NSString *querySql = @"select z_pk,ZMARKEDFORDELETION from ZICCLOUDSYNCINGOBJECT where ZIDENTIFIER=:ZIDENTIFIER";
        FMResultSet *set = [targetDB executeQuery:querySql withParameterDictionary:[NSDictionary dictionaryWithObject:identifier forKey:@"ZIDENTIFIER"]];
        int rowid = 0;
        while ([set next]) {
            isMarkDeletedFlag = [set intForColumnIndex:1];
            rowid = [set intForColumnIndex:0];
        }
        [set close];
        if (rowid>0) {
            isAlreadyExist = YES;
            newNoteID = rowid;
        }else{
            if (_targetVersion >= 11) {
                if ([targetDB executeUpdate:IOS11InsertStr withParameterDictionary:insertParam]) {
                    NSString *sql = @"select last_insert_rowid() from ZICCLOUDSYNCINGOBJECT";
                    FMResultSet *rs = [_targetDBConnection executeQuery:sql];
                    while ([rs next]) {
                        newNoteID = [rs intForColumn:@"last_insert_rowid()"];
                    }
                    [rs close];
                    if (newNoteID != -1) {
                        NSString *sql = @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
                        [targetDB executeUpdate:sql withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(newNoteID),@"Z_MAX",@"ICCloudSyncingObject",@"Z_NAME", nil]];
                    }
                }
            }else if (_targetVersion>=10) {
                if ([targetDB executeUpdate:IOS10InsertStr withParameterDictionary:insertParam]) {
                    NSString *sql = @"select last_insert_rowid() from ZICCLOUDSYNCINGOBJECT";
                    FMResultSet *rs = [_targetDBConnection executeQuery:sql];
                    while ([rs next]) {
                        newNoteID = [rs intForColumn:@"last_insert_rowid()"];
                    }
                    [rs close];
                    if (newNoteID != -1) {
                        NSString *sql = @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
                        [targetDB executeUpdate:sql withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(newNoteID),@"Z_MAX",@"ICCloudSyncingObject",@"Z_NAME", nil]];
                    }
                }

            }else{
                if ([targetDB executeUpdate:IOS9InsertStr withParameterDictionary:insertParam]) {
                    NSString *sql = @"select last_insert_rowid() from ZICCLOUDSYNCINGOBJECT";
                    FMResultSet *rs = [_targetDBConnection executeQuery:sql];
                    while ([rs next]) {
                        newNoteID = [rs intForColumn:@"last_insert_rowid()"];
                    }
                    [rs close];
                    if (newNoteID != -1) {
                        NSString *sql = @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
                        [targetDB executeUpdate:sql withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(newNoteID),@"Z_MAX",@"ICCloudSyncingObject",@"Z_NAME", nil]];
                    }
                }
            }
        }
    }
    
    if (newNoteID != -1) {
        if (![noteIDList.allKeys containsObject:@(sourcenoteID)]) {
            [noteIDList setObject:@(newNoteID) forKey:@(sourcenoteID)];
        }
        if (!isAlreadyExist) {
            int icloudstateId = [self insertICloudState:targetDB newnoteID:newNoteID zent:zent currentent:currentzent];
            if (icloudstateId != -1) {
                if (noteIndex == noteZENT) {
                    [self insertZICNOTEDATARecords:sourcenoteID newNoteID:newNoteID icloudstateId:icloudstateId sourceDB:sourceDB targetDB:targetDB];
                    [self insert12NOTESRecord:_defaultFolderZPK newNoteID:newNoteID targetDB:targetDB];
                }else{
                    if (noteIndex == attachZENT) {
                        if ([attachmentImages.allKeys containsObject:@(sourcenoteID)]) {
                            NSMutableArray *preViewKeys = [[attachmentImages objectForKey:@(sourcenoteID)] retain];
                            [attachmentImages removeObjectForKey:@(sourcenoteID)];
                            [attachmentImages setObject:preViewKeys forKey:@(newNoteID)];
                            if (![mediaIDList.allKeys containsObject:@(mediaID)]) {
                                [mediaIDList setObject:@(newNoteID) forKey:@(mediaID)];
                            }
                        }
                    }else if (noteIndex == mediaZENT){
                        int mediaKey = [[mediaIDList objectForKey:@(sourcenoteID)] intValue];
                        if (mediaKey != 0) {
                            //修改znote==4  zmedia==-1列的值
                            NSString *sql = @"update ZICCLOUDSYNCINGOBJECT set ZMEDIA=:ZMEDIA where rowid=:ROWID and ZMEDIA=-1";
                            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@(newNoteID),@"ZMEDIA",@(mediaKey),@"ROWID", nil];
                            [targetDB executeUpdate:sql withParameterDictionary:param];
                        }
                    }else if (noteIndex == preViewZENT){
                        if (attachmentImages.count != 0) {
                            int attachId = 0;
                            for (NSNumber *key in attachmentImages.allKeys) {
                                NSArray *preview = [attachmentImages objectForKey:key];
                                if ([preview containsObject:@(sourcenoteID)]) {
                                    attachId = key.intValue;
                                    break;
                                }
                            }
                            if (attachId>0) {
                                //添加到4PREVIEWIMAGES表
                                if (_targetVersion >= 10) {
                                    [self UpdateZATTACHMENT:attachId previewKey:newNoteID targetDB:targetDB];
                                }else{
                                    [self insert4PREVIEWIMAGESRecord:attachId previewKey:newNoteID targetDB:targetDB];

                                }
                            }
                        }
                    }
                    [self updateZICLOUDSTATE:newNoteID icloudState:icloudstateId targetDB:targetDB];
                }
            }
        }else{
            if (noteIndex == noteZENT) {
                if (isMarkDeletedFlag == 1) {
                    NSString *sql = @"update ZICCLOUDSYNCINGOBJECT set ZMARKEDFORDELETION=:ZMARKEDFORDELETION where rowid=:ROWID";
                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@(0),@"ZMARKEDFORDELETION",@(newNoteID),@"ROWID", nil];
                    [targetDB executeUpdate:sql withParameterDictionary:param];
                }
                [self Update12NOTESRecord:newNoteID targetDB:targetDB];
                [self updateZICNOTEDATARecords:sourcenoteID newNoteID:newNoteID sourceDB:sourceDB targetDB:targetDB];
            }
        }
    }
    return newNoteID;
}

- (void)UpdateZATTACHMENT:(int)attachId previewKey:(int)previewKey targetDB:(FMDatabase *)targetCmd
{
    NSString *sql = @"UPDATE ZICCLOUDSYNCINGOBJECT SET ZATTACHMENT=:ZATTACHMENT WHERE Z_PK=:Z_PK";
    [targetCmd executeUpdate:sql withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(attachId),@"ZATTACHMENT",@(previewKey),@"Z_PK", nil]];
}

- (int)insertICloudState:(FMDatabase *)targetDB newnoteID:(int)noteId zent:(int)z_ent
{
    int cloudstateID = -1;
    int z_CloudState_ent = 2; //默认为2
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICCloudState'";
    FMResultSet *rs = [targetDB executeQuery:sql];
    while ([rs next]) {
        z_CloudState_ent = [rs intForColumnIndex:0];
        break;
    }
    NSString *sql1 = nil;
    if (_targetVersion>=10) {
        sql1 = @"INSERT INTO ZICCLOUDSTATE(Z_ENT,Z_OPT,ZCURRENTLOCALVERSION,ZINCLOUD,ZLATESTVERSIONSYNCEDTOCLOUD,ZCLOUDSYNCINGOBJECT,Z2_CLOUDSYNCINGOBJECT,ZLOCALVERSIONDATE) VALUES(:Z_ENT,:Z_OPT,:ZCURRENTLOCALVERSION,:ZINCLOUD,:ZLATESTVERSIONSYNCEDTOCLOUD,:ZCLOUDSYNCINGOBJECT,:Z2_CLOUDSYNCINGOBJECT,:ZLOCALVERSIONDATE)";
        
    }else{
        sql1 = @"INSERT INTO ZICCLOUDSTATE(Z_ENT,Z_OPT,ZCURRENTLOCALVERSION,ZINCLOUD,ZLATESTVERSIONSYNCEDTOCLOUD,ZCLOUDSYNCINGOBJECT,Z3_CLOUDSYNCINGOBJECT,ZLOCALVERSIONDATE) VALUES(:Z_ENT,:Z_OPT,:ZCURRENTLOCALVERSION,:ZINCLOUD,:ZLATESTVERSIONSYNCEDTOCLOUD,:ZCLOUDSYNCINGOBJECT,:Z3_CLOUDSYNCINGOBJECT,:ZLOCALVERSIONDATE)";
    }
    NSMutableDictionary *param1 = [NSMutableDictionary dictionary];
    [param1 setObject:@(z_CloudState_ent) forKey:@"Z_ENT"];
    if (z_ent == mediaZENT) {
        [param1 setObject:@(2) forKey:@"Z_OPT"];
    }else if (z_ent == preViewZENT){
        [param1 setObject:@(1) forKey:@"Z_OPT"];
    }else{
        [param1 setObject:@(4) forKey:@"Z_OPT"];
    }
    if (z_ent == preViewZENT) {
        [param1 setObject:@(0) forKey:@"ZCURRENTLOCALVERSION"];
    }else if (z_ent == attachZENT){
        [param1 setObject:@(6) forKey:@"ZCURRENTLOCALVERSION"];
    }else if (z_ent == mediaZENT){
        [param1 setObject:@(2) forKey:@"ZCURRENTLOCALVERSION"];
    }else{
        [param1 setObject:@(20) forKey:@"ZCURRENTLOCALVERSION"];
    }
    
    [param1 setObject:@(0) forKey:@"ZINCLOUD"];
    [param1 setObject:@(0) forKey:@"ZLATESTVERSIONSYNCEDTOCLOUD"];
    [param1 setObject:@(noteId) forKey:@"ZCLOUDSYNCINGOBJECT"];
    if (_targetVersion>=10) {
        [param1 setObject:@(z_ent) forKey:@"Z2_CLOUDSYNCINGOBJECT"];
        
    }else {
        [param1 setObject:@(z_ent) forKey:@"Z3_CLOUDSYNCINGOBJECT"];
    }
    if (z_ent == preViewZENT) {
        [param1 setObject:[NSNull null] forKey:@"ZLOCALVERSIONDATE"];
    }else{
        
        [param1 setObject:@([DateHelper getTimeIntervalSince2001:[NSDate date]]) forKey:@"ZLOCALVERSIONDATE"];
    }
    if ([targetDB executeUpdate:sql1 withParameterDictionary:param1]) {
        NSString *sql = @"select last_insert_rowid() from ZICCLOUDSTATE";
        FMResultSet *rs = [targetDB executeQuery:sql];
        while ([rs next]) {
            cloudstateID = [rs intForColumn:@"last_insert_rowid()"];
        }
        [rs close];
        if (cloudstateID != -1) {
            NSString *sql = @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
            [targetDB executeUpdate:sql withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(cloudstateID),@"Z_MAX",@"ICCloudState",@"Z_NAME", nil]];
        }
    }
    return cloudstateID;

}

- (int)insertICloudState:(FMDatabase *)targetDB newnoteID:(int)noteId zent:(int)z_ent currentent:(int)currentEnt
{
    int cloudstateID = -1;
    int z_CloudState_ent = 2; //默认为2
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICCloudState'";
    FMResultSet *rs = [targetDB executeQuery:sql];
    while ([rs next]) {
        z_CloudState_ent = [rs intForColumnIndex:0];
        break;
    }
    NSString *sql1 = nil;
    if (_targetVersion>=10) {
        sql1 = @"INSERT INTO ZICCLOUDSTATE(Z_ENT,Z_OPT,ZCURRENTLOCALVERSION,ZINCLOUD,ZLATESTVERSIONSYNCEDTOCLOUD,ZCLOUDSYNCINGOBJECT,Z2_CLOUDSYNCINGOBJECT,ZLOCALVERSIONDATE) VALUES(:Z_ENT,:Z_OPT,:ZCURRENTLOCALVERSION,:ZINCLOUD,:ZLATESTVERSIONSYNCEDTOCLOUD,:ZCLOUDSYNCINGOBJECT,:Z2_CLOUDSYNCINGOBJECT,:ZLOCALVERSIONDATE)";

    }else{
         sql1 = @"INSERT INTO ZICCLOUDSTATE(Z_ENT,Z_OPT,ZCURRENTLOCALVERSION,ZINCLOUD,ZLATESTVERSIONSYNCEDTOCLOUD,ZCLOUDSYNCINGOBJECT,Z3_CLOUDSYNCINGOBJECT,ZLOCALVERSIONDATE) VALUES(:Z_ENT,:Z_OPT,:ZCURRENTLOCALVERSION,:ZINCLOUD,:ZLATESTVERSIONSYNCEDTOCLOUD,:ZCLOUDSYNCINGOBJECT,:Z3_CLOUDSYNCINGOBJECT,:ZLOCALVERSIONDATE)";
    }
    NSMutableDictionary *param1 = [NSMutableDictionary dictionary];
    [param1 setObject:@(z_CloudState_ent) forKey:@"Z_ENT"];
    if (z_ent == mediaZENT) {
        [param1 setObject:@(2) forKey:@"Z_OPT"];
    }else if (z_ent == preViewZENT){
        [param1 setObject:@(1) forKey:@"Z_OPT"];
    }else{
        [param1 setObject:@(4) forKey:@"Z_OPT"];
    }
    if (z_ent == preViewZENT) {
        [param1 setObject:@(0) forKey:@"ZCURRENTLOCALVERSION"];
    }else if (z_ent == attachZENT){
        [param1 setObject:@(6) forKey:@"ZCURRENTLOCALVERSION"];
    }else if (z_ent == mediaZENT){
        [param1 setObject:@(2) forKey:@"ZCURRENTLOCALVERSION"];
    }else{
        [param1 setObject:@(20) forKey:@"ZCURRENTLOCALVERSION"];
    }
    
    [param1 setObject:@(0) forKey:@"ZINCLOUD"];
    [param1 setObject:@(0) forKey:@"ZLATESTVERSIONSYNCEDTOCLOUD"];
    [param1 setObject:@(noteId) forKey:@"ZCLOUDSYNCINGOBJECT"];
    if (_targetVersion>=10) {
        [param1 setObject:@(currentEnt) forKey:@"Z2_CLOUDSYNCINGOBJECT"];

    }else {
        [param1 setObject:@(currentEnt) forKey:@"Z3_CLOUDSYNCINGOBJECT"];
    }
    if (z_ent == preViewZENT) {
        [param1 setObject:[NSNull null] forKey:@"ZLOCALVERSIONDATE"];
    }else{
        
        [param1 setObject:@([DateHelper getTimeIntervalSince2001:[NSDate date]]) forKey:@"ZLOCALVERSIONDATE"];
    }
    if ([targetDB executeUpdate:sql1 withParameterDictionary:param1]) {
        NSString *sql = @"select last_insert_rowid() from ZICCLOUDSTATE";
        FMResultSet *rs = [targetDB executeQuery:sql];
        while ([rs next]) {
            cloudstateID = [rs intForColumn:@"last_insert_rowid()"];
        }
        [rs close];
        if (cloudstateID != -1) {
            NSString *sql = @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
            [targetDB executeUpdate:sql withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(cloudstateID),@"Z_MAX",@"ICCloudState",@"Z_NAME", nil]];
        }
    }
    return cloudstateID;
}



- (void)insertZICNOTEDATARecords:(int)sourceNoteID newNoteID:(int)newNoteID icloudstateId:(int)icloudstateId sourceDB:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    int z_ent = -1;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICNoteData'";
    FMResultSet *rs = [targetDB executeQuery:sql];
    while ([rs next]) {
        z_ent = [rs intForColumn:@"Z_ENT"];
    }
    [rs close];
    if (z_ent != -1) {
        NSString *sql1 = @"SELECT Z_ENT,Z_OPT,ZNOTE,ZDATA FROM ZICNOTEDATA where z_pk in(select ZNOTEDATA from ZICCLOUDSYNCINGOBJECT where z_pk=:z_pk)";
        NSString *sql2 = @"insert into ZICNOTEDATA(Z_ENT,Z_OPT,ZNOTE,ZDATA) values(:Z_ENT,:Z_OPT,:ZNOTE,:ZDATA)";
        NSString *sql3 = @"select z_pk from ZICNOTEDATA where ZNOTE=:ZNOTE";
        NSString *sql4= @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
        NSString *sql5 = @"UPDATE ZICCLOUDSYNCINGOBJECT SET ZCLOUDSTATE=:ZCLOUDSTATE,znotedata=:znotedata WHERE Z_PK=:Z_PK";
        FMResultSet *rs = [sourceDB executeQuery:sql1 withParameterDictionary:[NSDictionary dictionaryWithObject:@(sourceNoteID) forKey:@"z_pk"]];
        while ([rs next]) {
            NSDictionary *param2 = [NSDictionary dictionaryWithObjectsAndKeys:@(z_ent),@"Z_ENT",[rs objectForColumnName:@"Z_OPT"],@"Z_OPT",@(newNoteID),@"ZNOTE",[rs objectForColumnName:@"ZDATA"],@"ZDATA", nil];
            if ([targetDB executeUpdate:sql2 withParameterDictionary:param2]) {
                FMResultSet *set = [targetDB executeQuery:sql3 withParameterDictionary:[NSDictionary dictionaryWithObject:@(newNoteID) forKey:@"ZNOTE"]];
                while ([set next]) {
                    int notebodyID = [set intForColumn:@"z_pk"];
                    [targetDB executeUpdate:sql4 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(notebodyID),@"Z_MAX",@"ICNoteData",@"Z_NAME", nil]];
                    [targetDB executeUpdate:sql5 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(icloudstateId),@"ZCLOUDSTATE",@(notebodyID),@"znotedata",@(newNoteID),@"Z_PK", nil]];
                }
            }
        }
        [rs close];
    }
}

- (void)insert12NOTESRecord:(int)accountId newNoteID:(int)newNoteID targetDB:(FMDatabase *)targetDB
{
    if (_targetVersion>=11) {
        //不做处理
    }else if (_targetVersion>=10) {
        NSString *sql = @"insert into Z_11NOTES (Z_11FOLDERS, Z_8NOTES)values(:Z_11FOLDERS, :Z_8NOTES)";
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(accountId),@"Z_11FOLDERS",@(newNoteID),@"Z_8NOTES", nil];
        [targetDB executeUpdate:sql withParameterDictionary:dic];
    }else{
        NSString *sql = @"insert into Z_12NOTES (Z_12FOLDERS, Z_9NOTES)values(:Z_12FOLDERS, :Z_9NOTES)";
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(accountId),@"Z_12FOLDERS",@(newNoteID),@"Z_9NOTES", nil];
        [targetDB executeUpdate:sql withParameterDictionary:dic];
    }
   
}

- (void)insert4PREVIEWIMAGESRecord:(int)attachId previewKey:(int)previewKey targetDB:(FMDatabase *)targetDB
{
    NSString *sql = @"insert into Z_4PREVIEWIMAGES (Z_4ATTACHMENTS, Z_5PREVIEWIMAGES)values(:Z_4ATTACHMENTS, :Z_5PREVIEWIMAGES)";
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@(attachId),@"Z_4ATTACHMENTS",@(previewKey),@"Z_5PREVIEWIMAGES", nil];
    [targetDB executeUpdate:sql withParameterDictionary:param];
}

- (void)updateZICLOUDSTATE:(int)newNoteID icloudState:(int)icloudState targetDB:(FMDatabase *)targetDB
{
    NSString *sql = @"UPDATE ZICCLOUDSYNCINGOBJECT SET ZCLOUDSTATE=:ZCLOUDSTATE WHERE Z_PK=:Z_PK";
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(newNoteID),@"Z_PK",@(icloudState),@"ZCLOUDSTATE", nil];
    [targetDB executeUpdate:sql withParameterDictionary:dic];
}

- (void)Update12NOTESRecord:(int)noteId targetDB:(FMDatabase *)targetDB
{
    NSString *sql = nil;
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    if (_targetVersion>=11) {
        return;
    }else if (_targetVersion >= 10) {
        sql = @"select Count(*) from Z_11NOTES where Z_8NOTES=:Z_8NOTES";
        [parma setObject:@(noteId) forKey:@"Z_8NOTES"];
    }else{
        sql = @"select Count(*) from Z_12NOTES where Z_9NOTES=:Z_9NOTES";
        [parma setObject:@(noteId) forKey:@"Z_9NOTES"];
    }
    int noteCount = 0;
    FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:parma];
    while ([rs next]) {
        noteCount = [rs intForColumnIndex:0];
    }
    [rs close];
    NSMutableDictionary *parma1 = [NSMutableDictionary dictionary];
    NSString *sql1 = nil;
    if (noteCount > 0) {
        if (_targetVersion >= 10) {
             sql1 = @"update Z_11NOTES set Z_11FOLDERS=:Z_11FOLDERS where Z_8NOTES=:Z_8NOTES";
            [parma1 setObject:@(_defaultFolderZPK) forKey:@"Z_11FOLDERS"];
            [parma1 setObject:@(noteId) forKey:@"Z_8NOTES"];

        }else{
            sql1 = @"update Z_12NOTES set Z_12FOLDERS=:Z_12FOLDERS where Z_9NOTES=:Z_9NOTES";
            [parma1 setObject:@(_defaultFolderZPK) forKey:@"Z_12FOLDERS"];
            [parma1 setObject:@(noteId) forKey:@"Z_9NOTES"];
        }
    }else{
        if (_targetVersion >= 10) {
            sql1 = @"insert into Z_11NOTES (Z_11FOLDERS, Z_8NOTES)values(:Z_11FOLDERS, :Z_8NOTES)";
            [parma1 setObject:@(_defaultFolderZPK) forKey:@"Z_11FOLDERS"];
            [parma1 setObject:@(noteId) forKey:@"Z_8NOTES"];

        }else{
            sql1 = @"insert into Z_12NOTES (Z_12FOLDERS, Z_9NOTES)values(:Z_12FOLDERS, :Z_9NOTES)";
            [parma1 setObject:@(_defaultFolderZPK) forKey:@"Z_12FOLDERS"];
            [parma1 setObject:@(noteId) forKey:@"Z_9NOTES"];
        }
    }
    [targetDB executeUpdate:sql1 withParameterDictionary:parma1];
}


- (void)updateZICNOTEDATARecords:(int)sourcenoteID newNoteID:(int)newNoteID sourceDB:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    NSString *sql = @"SELECT Z_ENT,Z_OPT,ZNOTE,ZDATA FROM ZICNOTEDATA where z_pk in(select ZNOTEDATA from ZICCLOUDSYNCINGOBJECT where z_pk=:z_pk)";
    NSDictionary *param = [NSDictionary dictionaryWithObject:@(sourcenoteID) forKey:@"z_pk"];
    FMResultSet *rs = [sourceDB executeQuery:sql withParameterDictionary:param];
    while ([rs next]) {
        NSString *sql1 = @"update ZICNOTEDATA set ZDATA=:ZDATA where ZNOTE=:ZNOTE";
        NSDictionary *param1 = [NSDictionary dictionaryWithObjectsAndKeys:@(newNoteID),@"ZNOTE",[rs objectForColumnName:@"ZDATA"],@"ZDATA", nil];
        [targetDB executeUpdate:sql1 withParameterDictionary:param1];
    }
}

#pragma mark - clone
- (void)clone
{
    [_logHandle writeInfoLog:@"Clone Note enter"];
     if (_sourceVersion<=_targetVersion) {
        int version = _sourceVersion;
        _sourceVersion = _targetVersion;
        _targetVersion = version;
        if ([_sourceFloatVersion isVersionLessEqual:_targetFloatVersion]) {
            if (isneedClone) {
                [_logHandle writeInfoLog:@"Clone Note sourceFloatVersion <= targetFloatVersion"];
                return;
            }
            IMBMBFileRecord *record = sourceRecord;
            sourceRecord = targetRecord;
            targetRecord = record;
            
            NSString *backupPath = _sourceBackuppath;
            _sourceBackuppath = _targetBakcuppath;
            _targetBakcuppath = backupPath;
            
            NSString *sqlitePath = _sourceSqlitePath;
            _sourceSqlitePath = _targetSqlitePath;
            _targetSqlitePath = sqlitePath;
            
            NSMutableArray *recordArray = _sourcerecordArray;
            _sourcerecordArray = _targetrecordArray;
            _targetrecordArray = recordArray;
            
            FMDatabase *dataCo = _sourceManifestDBConnection;
            _sourceManifestDBConnection = _targetManifestDBConnection;
            _targetManifestDBConnection = dataCo;
            
            NSString *version = _sourceFloatVersion;
            _sourceFloatVersion = _targetFloatVersion;
            _targetFloatVersion = version;
            
        }else
        {
            if (!isneedClone) {
                return;
            }
        }
    }else
    {
        if (!isneedClone) {
            return;
        }
    }
    //开启数据库
    @try {
        if ([self openDataBase:_sourceDBConnection]&& [self openDataBase:_targetDBConnection]) {
            if (_sourcedbType && _targetdbType) {
                //高到高
                [_logHandle writeInfoLog:@"Clone Note Hight To Hight"];
                [self cloneHightToHight:_sourceDBConnection targetDB:_targetDBConnection];
                NSMutableArray *sourceRecodArray = _sourcerecordArray;
                NSMutableArray *previewsRecordArray = [NSMutableArray array];
                NSMutableArray *mediaRecordArray = [NSMutableArray array];
                for (IMBMBFileRecord *record in sourceRecodArray) {
                    if ([record.path hasPrefix:
                         @"Previews"] && [record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"]) {
                        [previewsRecordArray addObject:record];
                    }
                    if ([record.path hasPrefix:
                         @"Media"] && [record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"]) {
                        [mediaRecordArray addObject:record];
                    }
                }
                if ([_targetFloatVersion isVersionLess:@"10"]) {
                    NSMutableArray *targetRecodArray = _targetrecordArray;
                    NSMutableArray *targetRecodArray1 = [NSMutableArray array];
                    NSMutableArray *targetRecodArray2 = [NSMutableArray array];
                    NSMutableArray *tarpreviewsRecordArray = [NSMutableArray array];
                    NSMutableArray *tarmediaRecordArray = [NSMutableArray array];
                    BOOL canAdd = YES;
                    for (IMBMBFileRecord *record in targetRecodArray) {
                        if (canAdd) {
                            [targetRecodArray1 addObject:record];
                        }else
                        {
                            if (([record.path isEqualToString:
                                  @"Previews"]&&[record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"])||([record.path isEqualToString:
                                                                                                                            @"Media"]&&[record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"])) {
                                continue;
                            }
                            [targetRecodArray2 addObject:record];
                        }
                        
                        if ([record.path isEqualToString:@""]&&[record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"]) {
                            canAdd = NO;
                        }
                        if ([record.path hasPrefix:
                             @"Previews/"]&&[record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"]) {
                            [tarpreviewsRecordArray addObject:record];
                        }
                        if ([record.path hasPrefix:
                             @"Media/"]&&[record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"]) {
                            [tarmediaRecordArray addObject:record];
                        }
                    }
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    [targetRecodArray removeAllObjects];
                    [targetRecodArray addObjectsFromArray:targetRecodArray1];
                    //进行拷贝文件
                    for (IMBMBFileRecord *record in previewsRecordArray) {
                        NSString *fkey = [record.key substringWithRange:NSMakeRange(0, 2)];
                        NSString *sourcePath = nil;
                        if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                            NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                            sourcePath = [folderPath stringByAppendingPathComponent:record.key];
                        }else{
                            sourcePath = [_sourceBackuppath stringByAppendingPathComponent:record.key];
                        }
                        NSString *desPath = [_targetBakcuppath stringByAppendingPathComponent:record.key];
                        if ([fileManager fileExistsAtPath:desPath]) {
                            [fileManager removeItemAtPath:desPath error:nil];
                        }
                        if ([fileManager fileExistsAtPath:sourcePath]) {
                            [record setDataHash:[IMBBaseClone dataHashfilePath:sourcePath]];
                            int64_t fileSize = [IMBUtilTool fileSizeAtPath:sourcePath];
                            [record changeFileLength:fileSize];
                            [fileManager copyItemAtPath:sourcePath toPath:desPath error:nil];
                        }
                    }
                    [targetRecodArray addObjectsFromArray:previewsRecordArray];
                    //进行拷贝文件
                    for (IMBMBFileRecord *record in mediaRecordArray) {
                        NSString *fkey = [record.key substringWithRange:NSMakeRange(0, 2)];
                        NSString *sourcePath = nil;
                        if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                            NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                            sourcePath = [folderPath stringByAppendingPathComponent:record.key];
                        }else{
                            sourcePath = [_sourceBackuppath stringByAppendingPathComponent:record.key];
                        }
                        
                        NSString *desPath = [_targetBakcuppath stringByAppendingPathComponent:record.key];
                        if ([fileManager fileExistsAtPath:desPath]) {
                            [fileManager removeItemAtPath:desPath error:nil];
                        }
                        if ([fileManager fileExistsAtPath:sourcePath]) {
                            [record setDataHash:[IMBBaseClone dataHashfilePath:sourcePath]];
                            int64_t fileSize = [IMBUtilTool fileSizeAtPath:sourcePath];
                            [record changeFileLength:fileSize];
                            [fileManager copyItemAtPath:sourcePath toPath:desPath error:nil];
                        }
                    }
                    [targetRecodArray addObjectsFromArray:mediaRecordArray];
                    [targetRecodArray2 removeObjectsInArray:tarpreviewsRecordArray];
                    [targetRecodArray2 removeObjectsInArray:tarmediaRecordArray];
                    [targetRecodArray addObjectsFromArray:targetRecodArray2];

                }else{
                    //删掉目标设备中 所有的附件信息
                    NSPredicate *cate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                        IMBMBFileRecord *record = (IMBMBFileRecord *)evaluatedObject;
                        if (([record.path hasPrefix:
                             @"Previews"]&&[record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"])||([record.path hasPrefix:
                                                                                                                     @"Media"]&&[record.domain isEqualToString:@"AppDomainGroup-group.com.apple.notes"])) {
                            return YES;
                        }else{
                            return NO;
                        }
                    }];
                    NSArray *attRecord = [_targetrecordArray filteredArrayUsingPredicate:cate];
                    [self deleteRecords:attRecord TargetDB:_targetManifestDBConnection];
                    if ([mediaRecordArray count]==0&&[previewsRecordArray count]==0) {
                        
                    }else{
                        NSMutableArray *attachRecordArray = [NSMutableArray array];
                        [attachRecordArray addObjectsFromArray:previewsRecordArray];
                        [attachRecordArray addObjectsFromArray:mediaRecordArray];
                        [self createAttachmentPlist:attachRecordArray TargetDB:_targetManifestDBConnection];
                    }
                }
            }else if (_sourcedbType || _targetdbType){
                //高到低
                [_logHandle writeInfoLog:@"Clone Note Hight To Low"];
                [self deleteNoteData];
                [self cloneHightToLow:_sourceDBConnection targetDB:_targetDBConnection];
            }else{
                [_logHandle writeInfoLog:@"Clone Note Low To Low"];
                [_sourceDBConnection beginTransaction];
                [_targetDBConnection beginTransaction];
                [self deleteNoteData];
                [self insertZNOTE];
                [self insertZNOTEBODY];
            }
        }
        if (![_sourceDBConnection commit]) {
            [_sourceDBConnection rollback];
        }
        if (![_targetDBConnection commit]) {
            [_targetDBConnection rollback];
        }
        [self closeDataBase:_sourceDBConnection];
        [self closeDataBase:_targetDBConnection];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"exception:%@",exception]];
    }
    //修改HashandManifest
    [self modifyHashAndManifest];
}

- (void)cloneHightToHight:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    
    [self transfer12NOTESTable:sourceDB targetDB:targetDB];
    [self transferMETADATATable:sourceDB targetDB:targetDB];
    [self transferZICCLOUDSYNCINGOBJECTTable:sourceDB targetDB:targetDB];
    [self transferMODELCACHETable:sourceDB targetDB:targetDB];
    [self transferZICCLOUDSTATETable:sourceDB targetDB:targetDB];
    if (_targetVersion<10) {
        [self transfer4PREVIEWIMAGESTable:sourceDB targetDB:targetDB];
        [self transferZICAUTHORTable:sourceDB targetDB:targetDB];
        [self transferZICPERSONTable:sourceDB targetDB:targetDB];
        [self transferZICDDEVICETable:sourceDB targetDB:targetDB];
        [self transferZICGROUPTable:sourceDB targetDB:targetDB];
    }
    [self transferZICLOCATIONTable:sourceDB targetDB:targetDB];
    [self transferZICNOTECHANGETable:sourceDB targetDB:targetDB];
    [self transferZICNOTEDATATable:sourceDB targetDB:targetDB];
    [self transferZICSEARCHINDEXTRANSACTIONTable:sourceDB targetDB:targetDB];
    [self transferZICSERVERCHANGETOKENTable:sourceDB targetDB:targetDB];
    [self transferZNEXTIDTable:sourceDB targetDB:targetDB];
    [self updateMax];
}

- (void)updateMax
{
    NSString *sql = @"update Z_PRIMARYKEY set Z_MAX=(select Max(Z_PK) FROM ZICNOTEDATA) WHERE Z_NAME='ICNoteData'";
    [_targetDBConnection executeUpdate:sql];
    NSString *sql1 = @"update Z_PRIMARYKEY set Z_MAX=(select Max(Z_PK) FROM ZICCLOUDSYNCINGOBJECT) WHERE Z_NAME='ICCloudSyncingObject'";
    [_targetDBConnection executeUpdate:sql1];
    NSString *sql2 = @"update Z_PRIMARYKEY set Z_MAX=(select Max(Z_PK) FROM ZICCLOUDSTATE) WHERE Z_NAME='ICCloudState'";
    [_targetDBConnection executeUpdate:sql2];
}


- (void)transfer12NOTESTable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    if (_targetVersion >= 11) {
        return;
    }else if (_targetVersion >= 10) {
        [self clearTable:_targetDBConnection TableName:@"Z_11NOTES"];
    }else{
        [self clearTable:_targetDBConnection TableName:@"Z_12NOTES"];
    }
    NSString *sourceSql = nil;
    NSString *targetSql = nil;
    if (_sourceVersion >= 10) {
        sourceSql = @"SELECT Z_11FOLDERS, Z_8NOTES FROM Z_11NOTES";
    }else{
        sourceSql = @"SELECT Z_12FOLDERS, Z_9NOTES FROM Z_12NOTES";
    }
    if (_targetVersion >= 10) {
        targetSql = @"insert into Z_11NOTES (Z_11NOTES, Z_8NOTES)values(:Z_11NOTES,:Z_8NOTES)";
    }else{
        targetSql = @"insert into Z_12NOTES (Z_12FOLDERS, Z_9NOTES)values(:Z_12FOLDERS,:Z_9NOTES)";
    }
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        if (_targetVersion >= 10 && _sourceVersion>=10) {
            [param setObject:[rs objectForColumnName:@"Z_11FOLDERS"] forKey:@"Z_11FOLDERS"];
            [param setObject:[rs objectForColumnName:@"Z_8NOTES"] forKey:@"Z_8NOTES"];
        }else if (_targetVersion < 10 && _sourceVersion>=10) {
            [param setObject:[rs objectForColumnName:@"Z_11FOLDERS"] forKey:@"Z_12FOLDERS"];
            [param setObject:[rs objectForColumnName:@"Z_8NOTES"] forKey:@"Z_9NOTES"];
        }else if (_targetVersion >= 10 && _sourceVersion<10) {
            [param setObject:[rs objectForColumnName:@"Z_12FOLDERS"] forKey:@"Z_11FOLDERS"];
            [param setObject:[rs objectForColumnName:@"Z_9NOTES"] forKey:@"Z_8NOTES"];
        }else{
            [param setObject:[rs objectForColumnName:@"Z_12FOLDERS"] forKey:@"Z_12FOLDERS"];
            [param setObject:[rs objectForColumnName:@"Z_9NOTES"] forKey:@"Z_9NOTES"];
        }
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferMETADATATable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"Z_METADATA"];
    NSString *sourceSql = @"SELECT Z_VERSION, Z_UUID,Z_PLIST FROM Z_METADATA";
    NSString *targetSql = @"insert into Z_METADATA (Z_VERSION,Z_UUID,Z_PLIST)values(:Z_VERSION, :Z_UUID,:Z_PLIST)";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_VERSION"] forKey:@"Z_VERSION"];
        [param setObject:[rs objectForColumnName:@"Z_UUID"] forKey:@"Z_UUID"];
        [param setObject:[rs objectForColumnName:@"Z_PLIST"] forKey:@"Z_PLIST"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferMODELCACHETable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"Z_MODELCACHE"];
    NSString *sourceSql = @"SELECT Z_CONTENT FROM Z_MODELCACHE";
    NSString *targetSql = @"insert into Z_MODELCACHE (Z_CONTENT)values(:Z_CONTENT)";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_CONTENT"] forKey:@"Z_CONTENT"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferZICCLOUDSTATETable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"ZICCLOUDSTATE"];
    
    int z_CloudState_ent = 2; //默认为2
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICCloudState'";
    FMResultSet *rs1 = [targetDB executeQuery:sql];
    while ([rs1 next]) {
        z_CloudState_ent = [rs1 intForColumnIndex:0];
        break;
    }
    [rs1 close];
    NSString *sourceSql = nil;
    if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
        sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZCURRENTLOCALVERSION,ZINCLOUD,ZLATESTVERSIONSYNCEDTOCLOUD,ZCLOUDSYNCINGOBJECT,Z2_CLOUDSYNCINGOBJECT,ZLOCALVERSIONDATE FROM ZICCLOUDSTATE";
    }else{
        sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZCURRENTLOCALVERSION,ZINCLOUD,ZLATESTVERSIONSYNCEDTOCLOUD,ZCLOUDSYNCINGOBJECT,Z3_CLOUDSYNCINGOBJECT,ZLOCALVERSIONDATE FROM ZICCLOUDSTATE";
    }
    NSString *targetSql = nil;
    if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
        targetSql = @"INSERT INTO ZICCLOUDSTATE(Z_PK, Z_ENT,Z_OPT,ZCURRENTLOCALVERSION,ZINCLOUD,ZLATESTVERSIONSYNCEDTOCLOUD,ZCLOUDSYNCINGOBJECT,Z2_CLOUDSYNCINGOBJECT,ZLOCALVERSIONDATE)VALUES(:Z_ENT,:Z_OPT,:ZCURRENTLOCALVERSION,:ZINCLOUD,:ZLATESTVERSIONSYNCEDTOCLOUD,:ZCLOUDSYNCINGOBJECT,:Z2_CLOUDSYNCINGOBJECT,:ZLOCALVERSIONDATE)";
    }else{
        targetSql = @"insert into ZICCLOUDSTATE (Z_PK, Z_ENT,Z_OPT,ZCURRENTLOCALVERSION,ZINCLOUD,ZLATESTVERSIONSYNCEDTOCLOUD,ZCLOUDSYNCINGOBJECT,Z3_CLOUDSYNCINGOBJECT,ZLOCALVERSIONDATE)values(:Z_PK, :Z_ENT,:Z_OPT,:ZCURRENTLOCALVERSION,:ZINCLOUD,:ZLATESTVERSIONSYNCEDTOCLOUD,:ZCLOUDSYNCINGOBJECT,:Z3_CLOUDSYNCINGOBJECT,:ZLOCALVERSIONDATE)";
    }
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_PK"] forKey:@"Z_PK"];
        int sourceent = [rs intForColumnIndex:7];
        [param setObject:@(z_CloudState_ent) forKey:@"Z_ENT"];
        [param setObject:[rs objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [param setObject:[rs objectForColumnName:@"ZCURRENTLOCALVERSION"] forKey:@"ZCURRENTLOCALVERSION"];
        [param setObject:[rs objectForColumnName:@"ZINCLOUD"] forKey:@"ZINCLOUD"];
        [param setObject:[rs objectForColumnName:@"ZLATESTVERSIONSYNCEDTOCLOUD"] forKey:@"ZLATESTVERSIONSYNCEDTOCLOUD"];
        [param setObject:[rs objectForColumnName:@"ZCLOUDSYNCINGOBJECT"] forKey:@"ZCLOUDSYNCINGOBJECT"];
        int noteID = -1;
        if (sourceent == noteZENT)
        {
            noteID = noteTargetZENT;
        }
        else if (sourceent == mediaZENT)
        {
            noteID = mediaTargetZENT;
        }
        else if (sourceent == attachZENT)
        {
            noteID = attachTargetZENT;
        }
        else if (sourceent == preViewZENT)
        {
            noteID = preViewTargetZENT;
        }
        else if (sourceent == folderZENT)
        {
            noteID = folderTargetZENT;
        }
        else if (sourceent == acountZENT)
        {
            noteID = acountTargetZENT;
        }
        else if (sourceent == legacyZENT)
        {
            noteID = legacyTargetZENT;
        }else
        {
            noteID = sourceent;
        }
        if([_targetFloatVersion isVersionMajorEqual:@"10"])
        {
            [param setObject:@(noteID) forKey:@"Z2_CLOUDSYNCINGOBJECT"];
        }else
        {
            [param setObject:@(noteID) forKey:@"Z3_CLOUDSYNCINGOBJECT"];

        }
        [param setObject:[rs objectForColumnName:@"ZLOCALVERSIONDATE"] forKey:@"ZLOCALVERSIONDATE"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferZICCLOUDSYNCINGOBJECTTable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"ZICCLOUDSYNCINGOBJECT"];
    int zpk = 0;
    {
        NSString *zentStr = @"SELECT Z_ENT,Z_NAME FROM Z_PRIMARYKEY WHERE Z_NAME='ICNote' OR Z_NAME='ICAttachment' OR Z_NAME='ICMedia' OR Z_NAME='ICAttachmentPreviewImage' OR Z_NAME='ICAccount' OR Z_NAME='ICFolder' OR Z_NAME='ICLegacyTombstone'";
        FMResultSet *rs = [_sourceDBConnection executeQuery:zentStr];
        while ([rs next]) {
            zpk = [rs intForColumn:@"Z_ENT"];
            NSString *identifier = [rs stringForColumn:@"Z_NAME"];
            if ([identifier isEqualToString:@"ICNote"]) {
                noteZENT = zpk;
            }else if ([identifier isEqualToString:@"ICAttachment"]) {
                attachZENT = zpk;
            }else if ([identifier isEqualToString:@"ICMedia"]) {
                mediaZENT = zpk;
            }else if ([identifier isEqualToString:@"ICAttachmentPreviewImage"]) {
                preViewZENT = zpk;
            }else if ([identifier isEqualToString:@"ICAccount"]) {
                acountZENT = zpk;
            }else if ([identifier isEqualToString:@"ICFolder"]) {
                folderZENT = zpk;
            }else if ([identifier isEqualToString:@"ICLegacyTombstone"]) {
                legacyZENT = zpk;
            }
        }
        [rs close];
    }
    {
        NSString *zentStr = @"SELECT Z_ENT,Z_NAME FROM Z_PRIMARYKEY WHERE Z_NAME='ICNote' OR Z_NAME='ICAttachment' OR Z_NAME='ICMedia' OR Z_NAME='ICAttachmentPreviewImage' OR Z_NAME='ICAccount' OR Z_NAME='ICFolder' OR Z_NAME='ICLegacyTombstone'";
        FMResultSet *rs = [_targetDBConnection executeQuery:zentStr];
        while ([rs next]) {
            zpk = [rs intForColumn:@"Z_ENT"];
            NSString *identifier = [rs stringForColumn:@"Z_NAME"];
            if ([identifier isEqualToString:@"ICNote"]) {
                noteTargetZENT = zpk;
            }else if ([identifier isEqualToString:@"ICAttachment"]) {
                attachTargetZENT = zpk;
            }else if ([identifier isEqualToString:@"ICMedia"]) {
                mediaTargetZENT = zpk;
            }else if ([identifier isEqualToString:@"ICAttachmentPreviewImage"]) {
                preViewTargetZENT = zpk;
            }else if ([identifier isEqualToString:@"ICAccount"]) {
                acountTargetZENT = zpk;
            }else if ([identifier isEqualToString:@"ICFolder"]) {
                folderTargetZENT = zpk;
            }else if ([identifier isEqualToString:@"ICLegacyTombstone"]) {
                legacyTargetZENT = zpk;
            }
        }
        [rs close];
    }
    NSString *sourceSql = nil;
    if ([_sourceFloatVersion isVersionMajorEqual:@"11"]) {
        sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZMODIFICATIONDATE,ZMODIFIEDDATE,ZPREVIEWUPDATEDATE,ZSTATEMODIFICATIONDATE,ZMODIFICATIONDATEATIMPORT,ZCREATIONDATE1,ZLEGACYMODIFICATIONDATEATIMPORT,ZMODIFICATIONDATE1,ZDATEFORLASTTITLEMODIFICATION,ZPARENTMODIFICATIONDATE,ZMARKEDFORDELETION,ZNEEDSINITIALFETCHFROMCLOUD,ZNEEDSTOBEFETCHEDFROMCLOUD,ZCLOUDSTATE,ZCHECKEDFORLOCATION,ZFILESIZE,ZORIENTATION,ZSECTION,ZLOCATION,ZMEDIA,ZNOTE,ZSCALEWHENDRAWING,ZSTATE,ZACCOUNT,ZTYPE,ZACCOUNT1,ZLEGACYNOTEWASPLAINTEXT,ZNOTEHASCHANGES,ZACCOUNT2,ZNOTEDATA,ZISHIDDENNOTECONTAINER,ZSORTORDER,ZOWNER,ZACCOUNTTYPE,ZDIDCHOOSETOMIGRATE,ZDIDFINISHMIGRATION,ZDIDMIGRATEONMAC,ZFOLDERTYPE,ZIMPORTEDFROMLEGACY,ZACCOUNT3,ZPARENT,ZDURATION,ZORIGINX,ZORIGINY,ZSIZEHEIGHT,ZSIZEWIDTH,ZHEIGHT,ZSCALE,ZWIDTH,ZIDENTIFIER,ZSUMMARY,ZTITLE,ZTYPEUTI,ZURLSTRING,ZDEVICEIDENTIFIER,ZCONTENTHASHATIMPORT,ZFILENAME,ZLEGACYCONTENTHASHATIMPORT,ZLEGACYIMPORTDEVICEIDENTIFIER,ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,ZSNIPPET,ZTHUMBNAILATTACHMENTIDENTIFIER,ZTITLE1,ZACCOUNTNAMEFORACCOUNTLISTSORTING,ZNESTEDTITLEFORSORTING,ZNAME,ZUSERRECORDNAME,ZTITLE2,ZMERGEABLEDATA,ZMETADATA,ZATTACHMENT,ZNEEDSTOSAVEUSERSPECIFICRECORD,ZMINIMUMSUPPORTEDNOTESVERSION,ZATTACHMENTVIEWTYPE FROM ZICCLOUDSYNCINGOBJECT and ZMARKEDFORDELETION!=1 and note.Z_PK not in (";
    }else if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
        sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZMODIFICATIONDATE,ZMODIFIEDDATE,ZPREVIEWUPDATEDATE,ZSTATEMODIFICATIONDATE,ZMODIFICATIONDATEATIMPORT,ZCREATIONDATE1,ZFOLDERSMODIFICATIONDATE,ZLEGACYMODIFICATIONDATEATIMPORT,ZMODIFICATIONDATE1,ZDATEFORLASTTITLEMODIFICATION,ZPARENTMODIFICATIONDATE,ZMARKEDFORDELETION,ZNEEDSINITIALFETCHFROMCLOUD,ZNEEDSTOBEFETCHEDFROMCLOUD,ZCLOUDSTATE,ZCHECKEDFORLOCATION,ZFILESIZE,ZORIENTATION,ZSECTION,ZLOCATION,ZMEDIA,ZNOTE,ZSCALEWHENDRAWING,ZSTATE,ZACCOUNT,ZTYPE,ZACCOUNT1,ZINTEGERID,ZLEGACYNOTEINTEGERID,ZLEGACYNOTEWASPLAINTEXT,ZNOTEHASCHANGES,ZACCOUNT2,ZNOTEDATA,ZISHIDDENNOTECONTAINER,ZSORTORDER,ZOWNER,ZACCOUNTTYPE,ZDIDCHOOSETOMIGRATE,ZDIDFINISHMIGRATION,ZDIDMIGRATEONMAC,ZFOLDERTYPE,ZIMPORTEDFROMLEGACY,ZACCOUNT3,ZPARENT,ZDURATION,ZORIGINX,ZORIGINY,ZSIZEHEIGHT,ZSIZEWIDTH,ZHEIGHT,ZSCALE,ZWIDTH,ZIDENTIFIER,ZSUMMARY,ZTITLE,ZTYPEUTI,ZURLSTRING,ZDEVICEIDENTIFIER,ZCONTENTHASHATIMPORT,ZFILENAME,ZLEGACYCONTENTHASHATIMPORT,ZLEGACYIMPORTDEVICEIDENTIFIER,ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,ZSNIPPET,ZTHUMBNAILATTACHMENTIDENTIFIER,ZTITLE1,ZACCOUNTNAMEFORACCOUNTLISTSORTING,ZNESTEDTITLEFORSORTING,ZNAME,ZUSERRECORDNAME,ZTITLE2,ZSERVERRECORD,ZREMOTEFILEURL,ZMERGEABLEDATA,ZMETADATA,ZATTACHMENT,ZNEEDSTOSAVEUSERSPECIFICRECORD,ZMINIMUMSUPPORTEDNOTESVERSION,ZATTACHMENTVIEWTYPE FROM ZICCLOUDSYNCINGOBJECT and ZMARKEDFORDELETION!=1 and note.Z_PK not in (";
    }else{
        sourceSql = @"SELECT Z_PK,Z_ENT,Z_OPT,ZMODIFICATIONDATE,ZMODIFIEDDATE,ZPREVIEWUPDATEDATE,ZSTATEMODIFICATIONDATE,ZMODIFICATIONDATEATIMPORT,ZCREATIONDATE,ZFOLDERSMODIFICATIONDATE,ZLEGACYMODIFICATIONDATEATIMPORT,ZMODIFICATIONDATE1,ZDATEFORLASTTITLEMODIFICATION,ZPARENTMODIFICATIONDATE,ZMARKEDFORDELETION,ZNEEDSINITIALFETCHFROMCLOUD,ZNEEDSTOBEFETCHEDFROMCLOUD,ZCLOUDSTATE,ZCHECKEDFORLOCATION,ZFILESIZE,ZORIENTATION,ZSECTION,ZLOCATION,ZMEDIA,ZNOTE,ZSCALEWHENDRAWING,ZSTATE,ZACCOUNT,ZTYPE,ZACCOUNT1,ZINTEGERID,ZLEGACYNOTEINTEGERID,ZLEGACYNOTEWASPLAINTEXT,ZNOTEHASCHANGES,ZACCOUNT2,ZNOTEDATA,ZISHIDDENNOTECONTAINER,ZSORTORDER,ZOWNER,ZACCOUNTTYPE,ZDIDCHOOSETOMIGRATE,ZDIDFINISHMIGRATION,ZDIDMIGRATEONMAC,ZFOLDERTYPE,ZIMPORTEDFROMLEGACY,ZACCOUNT3,ZPARENT,ZDURATION,ZORIGINX,ZORIGINY,ZSIZEHEIGHT,ZSIZEWIDTH,ZHEIGHT,ZSCALE,ZWIDTH,ZIDENTIFIER,ZSUMMARY,ZTITLE,ZTYPEUTI,ZURLSTRING,ZDEVICEIDENTIFIER,ZCONTENTHASHATIMPORT,ZFILENAME,ZLEGACYCONTENTHASHATIMPORT,ZLEGACYIMPORTDEVICEIDENTIFIER,ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,ZSNIPPET,ZTHUMBNAILATTACHMENTIDENTIFIER,ZTITLE1,ZACCOUNTNAMEFORACCOUNTLISTSORTING,ZNESTEDTITLEFORSORTING,ZNAME,ZUSERRECORDNAME,ZTITLE2,ZSERVERRECORD,ZREMOTEFILEURL,ZMERGEABLEDATA,ZMETADATA FROM ZICCLOUDSYNCINGOBJECT and ZMARKEDFORDELETION!=1 and note.Z_PK not in (";
    }
    if (_sourceVersion>=10) {
        sourceSql = [sourceSql stringByAppendingString:@"SELECT Z_8NOTES FROM Z_11NOTES WHERE Z_11FOLDERS IN (SELECT Z_PK FROM ZICCLOUDSYNCINGOBJECT WHERE ZIDENTIFIER = 'TrashFolder-LocalAccount'))"];
        
    }else{
        sourceSql = [sourceSql stringByAppendingString:@"SELECT Z_9NOTES FROM Z_12NOTES WHERE Z_12FOLDERS IN (SELECT Z_PK FROM ZICCLOUDSYNCINGOBJECT WHERE ZIDENTIFIER = 'TrashFolder-LocalAccount'))"];
    }
    NSString *targetSql = nil;
    if ([_targetFloatVersion isVersionMajorEqual:@"11"]) {
        targetSql = @"insert into ZICCLOUDSYNCINGOBJECT (Z_PK, Z_ENT,Z_OPT,ZMARKEDFORDELETION,ZNEEDSINITIALFETCHFROMCLOUD,ZNEEDSTOBEFETCHEDFROMCLOUD,ZNEEDSTOSAVEUSERSPECIFICRECORD,ZMINIMUMSUPPORTEDNOTESVERSION,ZATTACHMENTVIEWTYPE,ZCLOUDSTATE,ZCHECKEDFORLOCATION,ZFILESIZE,ZORIENTATION,ZSECTION,ZLOCATION,ZMEDIA,ZNOTE,ZSCALEWHENDRAWING,ZSTATE,ZACCOUNT,ZTYPE,ZACCOUNT1,ZLEGACYNOTEWASPLAINTEXT,ZNOTEHASCHANGES,ZACCOUNT2,ZNOTEDATA,ZISHIDDENNOTECONTAINER,ZSORTORDER,ZOWNER,ZACCOUNTTYPE,ZDIDCHOOSETOMIGRATE,ZDIDFINISHMIGRATION,ZDIDMIGRATEONMAC,ZFOLDERTYPE,ZIMPORTEDFROMLEGACY,ZACCOUNT3,ZPARENT,ZDURATION,ZMODIFICATIONDATE,ZORIGINX,ZORIGINY,ZPREVIEWUPDATEDATE,ZSIZEHEIGHT,ZSIZEWIDTH,ZHEIGHT,ZMODIFIEDDATE,ZSCALE,ZWIDTH,ZSTATEMODIFICATIONDATE,ZMODIFICATIONDATEATIMPORT,ZCREATIONDATE1,ZLEGACYMODIFICATIONDATEATIMPORT,ZMODIFICATIONDATE1,ZDATEFORLASTTITLEMODIFICATION,ZPARENTMODIFICATIONDATE,ZIDENTIFIER,ZSUMMARY,ZTITLE,ZTYPEUTI,ZURLSTRING,ZDEVICEIDENTIFIER,ZCONTENTHASHATIMPORT,ZFILENAME,ZLEGACYCONTENTHASHATIMPORT,ZLEGACYIMPORTDEVICEIDENTIFIER,ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,ZSNIPPET,ZTHUMBNAILATTACHMENTIDENTIFIER,ZTITLE1,ZACCOUNTNAMEFORACCOUNTLISTSORTING,ZNESTEDTITLEFORSORTING,ZNAME,ZUSERRECORDNAME,ZTITLE2,ZMERGEABLEDATA,ZMETADATA,ZATTACHMENT,ZFOLDER)values(:Z_PK, :Z_ENT,:Z_OPT,:ZMARKEDFORDELETION,:ZNEEDSINITIALFETCHFROMCLOUD,:ZNEEDSTOBEFETCHEDFROMCLOUD,:ZNEEDSTOSAVEUSERSPECIFICRECORD,:ZMINIMUMSUPPORTEDNOTESVERSION,:ZATTACHMENTVIEWTYPE,:ZCLOUDSTATE,:ZCHECKEDFORLOCATION,:ZFILESIZE,:ZORIENTATION,:ZSECTION,:ZLOCATION,:ZMEDIA,:ZNOTE,:ZSCALEWHENDRAWING,:ZSTATE,:ZACCOUNT,:ZTYPE,:ZACCOUNT1,:ZLEGACYNOTEWASPLAINTEXT,:ZNOTEHASCHANGES,:ZACCOUNT2,:ZNOTEDATA,:ZISHIDDENNOTECONTAINER,:ZSORTORDER,:ZOWNER,:ZACCOUNTTYPE,:ZDIDCHOOSETOMIGRATE,:ZDIDFINISHMIGRATION,:ZDIDMIGRATEONMAC,:ZFOLDERTYPE,:ZIMPORTEDFROMLEGACY,:ZACCOUNT3,:ZPARENT,:ZDURATION,:ZMODIFICATIONDATE,:ZORIGINX,:ZORIGINY,:ZPREVIEWUPDATEDATE,:ZSIZEHEIGHT,:ZSIZEWIDTH,:ZHEIGHT,:ZMODIFIEDDATE,:ZSCALE,:ZWIDTH,:ZSTATEMODIFICATIONDATE,:ZMODIFICATIONDATEATIMPORT,:ZCREATIONDATE1,:ZLEGACYMODIFICATIONDATEATIMPORT,:ZMODIFICATIONDATE1,:ZDATEFORLASTTITLEMODIFICATION,:ZPARENTMODIFICATIONDATE,:ZIDENTIFIER,:ZSUMMARY,:ZTITLE,:ZTYPEUTI,:ZURLSTRING,:ZDEVICEIDENTIFIER,:ZCONTENTHASHATIMPORT,:ZFILENAME,:ZLEGACYCONTENTHASHATIMPORT,:ZLEGACYIMPORTDEVICEIDENTIFIER,:ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,:ZSNIPPET,:ZTHUMBNAILATTACHMENTIDENTIFIER,:ZTITLE1,:ZACCOUNTNAMEFORACCOUNTLISTSORTING,:ZNESTEDTITLEFORSORTING,:ZNAME,:ZUSERRECORDNAME,:ZTITLE2,:ZMERGEABLEDATA,:ZMETADATA,:ZATTACHMENT,:ZFOLDER)";
    }else if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
        targetSql = @"insert into ZICCLOUDSYNCINGOBJECT (Z_PK, Z_ENT,Z_OPT,ZMARKEDFORDELETION,ZNEEDSINITIALFETCHFROMCLOUD,ZNEEDSTOBEFETCHEDFROMCLOUD,ZNEEDSTOSAVEUSERSPECIFICRECORD,ZMINIMUMSUPPORTEDNOTESVERSION,ZATTACHMENTVIEWTYPE,ZCLOUDSTATE,ZCHECKEDFORLOCATION,ZFILESIZE,ZORIENTATION,ZSECTION,ZLOCATION,ZMEDIA,ZNOTE,ZSCALEWHENDRAWING,ZSTATE,ZACCOUNT,ZTYPE,ZACCOUNT1,ZINTEGERID,ZLEGACYNOTEINTEGERID,ZLEGACYNOTEWASPLAINTEXT,ZNOTEHASCHANGES,ZACCOUNT2,ZNOTEDATA,ZISHIDDENNOTECONTAINER,ZSORTORDER,ZOWNER,ZACCOUNTTYPE,ZDIDCHOOSETOMIGRATE,ZDIDFINISHMIGRATION,ZDIDMIGRATEONMAC,ZFOLDERTYPE,ZIMPORTEDFROMLEGACY,ZACCOUNT3,ZPARENT,ZDURATION,ZMODIFICATIONDATE,ZORIGINX,ZORIGINY,ZPREVIEWUPDATEDATE,ZSIZEHEIGHT,ZSIZEWIDTH,ZHEIGHT,ZMODIFIEDDATE,ZSCALE,ZWIDTH,ZSTATEMODIFICATIONDATE,ZMODIFICATIONDATEATIMPORT,ZCREATIONDATE1,ZFOLDERSMODIFICATIONDATE,ZLEGACYMODIFICATIONDATEATIMPORT,ZMODIFICATIONDATE1,ZDATEFORLASTTITLEMODIFICATION,ZPARENTMODIFICATIONDATE,ZIDENTIFIER,ZSUMMARY,ZTITLE,ZTYPEUTI,ZURLSTRING,ZDEVICEIDENTIFIER,ZCONTENTHASHATIMPORT,ZFILENAME,ZLEGACYCONTENTHASHATIMPORT,ZLEGACYIMPORTDEVICEIDENTIFIER,ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,ZSNIPPET,ZTHUMBNAILATTACHMENTIDENTIFIER,ZTITLE1,ZACCOUNTNAMEFORACCOUNTLISTSORTING,ZNESTEDTITLEFORSORTING,ZNAME,ZUSERRECORDNAME,ZTITLE2,ZSERVERRECORD,ZREMOTEFILEURL,ZMERGEABLEDATA,ZMETADATA,ZATTACHMENT)values(:Z_PK, :Z_ENT,:Z_OPT,:ZMARKEDFORDELETION,:ZNEEDSINITIALFETCHFROMCLOUD,:ZNEEDSTOBEFETCHEDFROMCLOUD,:ZNEEDSTOSAVEUSERSPECIFICRECORD,:ZMINIMUMSUPPORTEDNOTESVERSION,:ZATTACHMENTVIEWTYPE,:ZCLOUDSTATE,:ZCHECKEDFORLOCATION,:ZFILESIZE,:ZORIENTATION,:ZSECTION,:ZLOCATION,:ZMEDIA,:ZNOTE,:ZSCALEWHENDRAWING,:ZSTATE,:ZACCOUNT,:ZTYPE,:ZACCOUNT1,:ZINTEGERID,:ZLEGACYNOTEINTEGERID,:ZLEGACYNOTEWASPLAINTEXT,:ZNOTEHASCHANGES,:ZACCOUNT2,:ZNOTEDATA,:ZISHIDDENNOTECONTAINER,:ZSORTORDER,:ZOWNER,:ZACCOUNTTYPE,:ZDIDCHOOSETOMIGRATE,:ZDIDFINISHMIGRATION,:ZDIDMIGRATEONMAC,:ZFOLDERTYPE,:ZIMPORTEDFROMLEGACY,:ZACCOUNT3,:ZPARENT,:ZDURATION,:ZMODIFICATIONDATE,:ZORIGINX,:ZORIGINY,:ZPREVIEWUPDATEDATE,:ZSIZEHEIGHT,:ZSIZEWIDTH,:ZHEIGHT,:ZMODIFIEDDATE,:ZSCALE,:ZWIDTH,:ZSTATEMODIFICATIONDATE,:ZMODIFICATIONDATEATIMPORT,:ZCREATIONDATE1,:ZFOLDERSMODIFICATIONDATE,:ZLEGACYMODIFICATIONDATEATIMPORT,:ZMODIFICATIONDATE1,:ZDATEFORLASTTITLEMODIFICATION,:ZPARENTMODIFICATIONDATE,:ZIDENTIFIER,:ZSUMMARY,:ZTITLE,:ZTYPEUTI,:ZURLSTRING,:ZDEVICEIDENTIFIER,:ZCONTENTHASHATIMPORT,:ZFILENAME,:ZLEGACYCONTENTHASHATIMPORT,:ZLEGACYIMPORTDEVICEIDENTIFIER,:ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,:ZSNIPPET,:ZTHUMBNAILATTACHMENTIDENTIFIER,:ZTITLE1,:ZACCOUNTNAMEFORACCOUNTLISTSORTING,:ZNESTEDTITLEFORSORTING,:ZNAME,:ZUSERRECORDNAME,:ZTITLE2,:ZSERVERRECORD,:ZREMOTEFILEURL,:ZMERGEABLEDATA,:ZMETADATA,:ZATTACHMENT)";
    }else{
        targetSql = @"insert into ZICCLOUDSYNCINGOBJECT (Z_PK, Z_ENT,Z_OPT,ZMARKEDFORDELETION,ZNEEDSINITIALFETCHFROMCLOUD,ZNEEDSTOBEFETCHEDFROMCLOUD,ZCLOUDSTATE,ZCHECKEDFORLOCATION,ZFILESIZE,ZORIENTATION,ZSECTION,ZLOCATION,ZMEDIA,ZNOTE,ZSCALEWHENDRAWING,ZSTATE,ZACCOUNT,ZTYPE,ZACCOUNT1,ZINTEGERID,ZLEGACYNOTEINTEGERID,ZLEGACYNOTEWASPLAINTEXT,ZNOTEHASCHANGES,ZACCOUNT2,ZNOTEDATA,ZISHIDDENNOTECONTAINER,ZSORTORDER,ZOWNER,ZACCOUNTTYPE,ZDIDCHOOSETOMIGRATE,ZDIDFINISHMIGRATION,ZDIDMIGRATEONMAC,ZFOLDERTYPE,ZIMPORTEDFROMLEGACY,ZACCOUNT3,ZPARENT,ZDURATION,ZMODIFICATIONDATE,ZORIGINX,ZORIGINY,ZPREVIEWUPDATEDATE,ZSIZEHEIGHT,ZSIZEWIDTH,ZHEIGHT,ZMODIFIEDDATE,ZSCALE,ZWIDTH,ZSTATEMODIFICATIONDATE,ZMODIFICATIONDATEATIMPORT,ZCREATIONDATE,ZFOLDERSMODIFICATIONDATE,ZLEGACYMODIFICATIONDATEATIMPORT,ZMODIFICATIONDATE1,ZDATEFORLASTTITLEMODIFICATION,ZPARENTMODIFICATIONDATE,ZIDENTIFIER,ZSUMMARY,ZTITLE,ZTYPEUTI,ZURLSTRING,ZDEVICEIDENTIFIER,ZCONTENTHASHATIMPORT,ZFILENAME,ZLEGACYCONTENTHASHATIMPORT,ZLEGACYIMPORTDEVICEIDENTIFIER,ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,ZSNIPPET,ZTHUMBNAILATTACHMENTIDENTIFIER,ZTITLE1,ZACCOUNTNAMEFORACCOUNTLISTSORTING,ZNESTEDTITLEFORSORTING,ZNAME,ZUSERRECORDNAME,ZTITLE2,ZSERVERRECORD,ZREMOTEFILEURL,ZMERGEABLEDATA,ZMETADATA)values(:Z_PK, :Z_ENT,:Z_OPT,:ZMARKEDFORDELETION,:ZNEEDSINITIALFETCHFROMCLOUD,:ZNEEDSTOBEFETCHEDFROMCLOUD,:ZCLOUDSTATE,:ZCHECKEDFORLOCATION,:ZFILESIZE,:ZORIENTATION,:ZSECTION,:ZLOCATION,:ZMEDIA,:ZNOTE,:ZSCALEWHENDRAWING,:ZSTATE,:ZACCOUNT,:ZTYPE,:ZACCOUNT1,:ZINTEGERID,:ZLEGACYNOTEINTEGERID,:ZLEGACYNOTEWASPLAINTEXT,:ZNOTEHASCHANGES,:ZACCOUNT2,:ZNOTEDATA,:ZISHIDDENNOTECONTAINER,:ZSORTORDER,:ZOWNER,:ZACCOUNTTYPE,:ZDIDCHOOSETOMIGRATE,:ZDIDFINISHMIGRATION,:ZDIDMIGRATEONMAC,:ZFOLDERTYPE,:ZIMPORTEDFROMLEGACY,:ZACCOUNT3,:ZPARENT,:ZDURATION,:ZMODIFICATIONDATE,:ZORIGINX,:ZORIGINY,:ZPREVIEWUPDATEDATE,:ZSIZEHEIGHT,:ZSIZEWIDTH,:ZHEIGHT,:ZMODIFIEDDATE,:ZSCALE,:ZWIDTH,:ZSTATEMODIFICATIONDATE,:ZMODIFICATIONDATEATIMPORT,:ZCREATIONDATE,:ZFOLDERSMODIFICATIONDATE,:ZLEGACYMODIFICATIONDATEATIMPORT,:ZMODIFICATIONDATE1,:ZDATEFORLASTTITLEMODIFICATION,:ZPARENTMODIFICATIONDATE,:ZIDENTIFIER,:ZSUMMARY,:ZTITLE,:ZTYPEUTI,:ZURLSTRING,:ZDEVICEIDENTIFIER,:ZCONTENTHASHATIMPORT,:ZFILENAME,:ZLEGACYCONTENTHASHATIMPORT,:ZLEGACYIMPORTDEVICEIDENTIFIER,:ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION,:ZSNIPPET,:ZTHUMBNAILATTACHMENTIDENTIFIER,:ZTITLE1,:ZACCOUNTNAMEFORACCOUNTLISTSORTING,:ZNESTEDTITLEFORSORTING,:ZNAME,:ZUSERRECORDNAME,:ZTITLE2,:ZSERVERRECORD,:ZREMOTEFILEURL,:ZMERGEABLEDATA,:ZMETADATA)";
    }
    NSMutableDictionary *preAttachList = [NSMutableDictionary dictionary];
    if ([_sourceFloatVersion isVersionLess:@"10"]) {
        NSString *sql = @"SELECT Z_4ATTACHMENTS, Z_5PREVIEWIMAGES FROM Z_4PREVIEWIMAGES";
        FMResultSet *rs = [_sourceDBConnection executeQuery:sql];
        while ([rs next]) {
            id attaId = [rs objectForColumnName:@"Z_4ATTACHMENTS"];
            id preId = [rs objectForColumnName:@"Z_5PREVIEWIMAGES"];
            if (![preAttachList.allKeys containsObject:preId]) {
                [preAttachList setObject:attaId forKey:preId];
            }
            
        }
        [rs close];
        
        
    }else{
        NSString *sql = @"select Z_PK,ZATTACHMENT FROM ZICCLOUDSYNCINGOBJECT WHERE ZMARKEDFORDELETION==0 AND Z_ENT=(select Z_ENT FROM Z_PRIMARYKEY WHERE Z_NAME='ICAttachmentPreviewImage')";
        FMResultSet *rs = [_sourceDBConnection executeQuery:sql];
        while ([rs next]) {
            id attaId = [rs objectForColumnName:@"ZATTACHMENT"];
            id preId = [rs objectForColumnName:@"Z_PK"];
            if (![preAttachList.allKeys containsObject:preId]) {
                [preAttachList setObject:attaId forKey:preId];
            }
            
        }
        [rs close];
    }
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        int z_ent = [rs intForColumn:@"Z_ENT"];
        if (z_ent == noteZENT)
        {
            [param setObject:@(noteTargetZENT) forKey:@"Z_ENT"];
        }
        else if (z_ent == mediaZENT)
        {
            [param setObject:@(mediaTargetZENT) forKey:@"Z_ENT"];
        }
        else if (z_ent == attachZENT)
        {
            [param setObject:@(attachTargetZENT) forKey:@"Z_ENT"];
        }
        else if (z_ent == preViewZENT)
        {
            [param setObject:@(preViewTargetZENT) forKey:@"Z_ENT"];
        }
        else if (z_ent == folderZENT)
        {
            [param setObject:@(folderTargetZENT) forKey:@"Z_ENT"];
        }
        else if (z_ent == acountZENT)
        {
            [param setObject:@(acountTargetZENT) forKey:@"Z_ENT"];
        }
        else if (z_ent == legacyZENT)
        {
            [param setObject:@(legacyTargetZENT) forKey:@"Z_ENT"];
        }
        else
        {
            [param setObject:@(z_ent) forKey:@"Z_ENT"];
        }
        int z_pk = [rs intForColumn:@"Z_PK"];
        [param setObject:[rs objectForColumnName:@"Z_PK"] forKey:@"Z_PK"];
        [param setObject:[rs objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [param setObject:[rs objectForColumnName:@"ZMARKEDFORDELETION"] forKey:@"ZMARKEDFORDELETION"];
        [param setObject:[rs objectForColumnName:@"ZNEEDSINITIALFETCHFROMCLOUD"] forKey:@"ZNEEDSINITIALFETCHFROMCLOUD"];
        [param setObject:[rs objectForColumnName:@"ZNEEDSTOBEFETCHEDFROMCLOUD"] forKey:@"ZNEEDSTOBEFETCHEDFROMCLOUD"];
        [param setObject:[rs objectForColumnName:@"ZCLOUDSTATE"] forKey:@"ZCLOUDSTATE"];
        [param setObject:[rs objectForColumnName:@"ZCHECKEDFORLOCATION"] forKey:@"ZCHECKEDFORLOCATION"];
        [param setObject:[rs objectForColumnName:@"ZFILESIZE"] forKey:@"ZFILESIZE"];
        [param setObject:[rs objectForColumnName:@"ZORIENTATION"] forKey:@"ZORIENTATION"];
        [param setObject:[rs objectForColumnName:@"ZSECTION"] forKey:@"ZSECTION"];
        [param setObject:[rs objectForColumnName:@"ZLOCATION"] forKey:@"ZLOCATION"];
        [param setObject:[rs objectForColumnName:@"ZMEDIA"] forKey:@"ZMEDIA"];
        [param setObject:[rs objectForColumnName:@"ZNOTE"] forKey:@"ZNOTE"];
        [param setObject:[rs objectForColumnName:@"ZSCALEWHENDRAWING"] forKey:@"ZSCALEWHENDRAWING"];
        [param setObject:[rs objectForColumnName:@"ZVERSION"] forKey:@"ZVERSION"];
        [param setObject:[rs objectForColumnName:@"ZVERSIONOUTOFDATE"] forKey:@"ZVERSIONOUTOFDATE"];
        [param setObject:[rs objectForColumnName:@"ZSTATE"] forKey:@"ZSTATE"];
        [param setObject:[rs objectForColumnName:@"ZACCOUNT"] forKey:@"ZACCOUNT"];
        [param setObject:[rs objectForColumnName:@"ZTYPE"] forKey:@"ZTYPE"];
        [param setObject:[rs objectForColumnName:@"ZACCOUNT1"] forKey:@"ZACCOUNT1"];
        [param setObject:[rs objectForColumnName:@"ZLEGACYNOTEWASPLAINTEXT"] forKey:@"ZLEGACYNOTEWASPLAINTEXT"];
        [param setObject:[rs objectForColumnName:@"ZNOTEHASCHANGES"] forKey:@"ZNOTEHASCHANGES"];
        [param setObject:[rs objectForColumnName:@"ZACCOUNT2"] forKey:@"ZACCOUNT2"];
        [param setObject:[rs objectForColumnName:@"ZNOTEDATA"] forKey:@"ZNOTEDATA"];
        [param setObject:[rs objectForColumnName:@"ZSORTORDER"] forKey:@"ZSORTORDER"];
        [param setObject:[rs objectForColumnName:@"ZISHIDDENNOTECONTAINER"] forKey:@"ZISHIDDENNOTECONTAINER"];
        [param setObject:[rs objectForColumnName:@"ZOWNER"] forKey:@"ZOWNER"];
        [param setObject:[rs objectForColumnName:@"ZACCOUNTTYPE"] forKey:@"ZACCOUNTTYPE"];
        [param setObject:[rs objectForColumnName:@"ZDIDCHOOSETOMIGRATE"] forKey:@"ZDIDCHOOSETOMIGRATE"];
        [param setObject:[rs objectForColumnName:@"ZDIDFINISHMIGRATION"] forKey:@"ZDIDFINISHMIGRATION"];
        [param setObject:[rs objectForColumnName:@"ZDIDMIGRATEONMAC"] forKey:@"ZDIDMIGRATEONMAC"];
        [param setObject:[rs objectForColumnName:@"ZFOLDERTYPE"] forKey:@"ZFOLDERTYPE"];
        [param setObject:[rs objectForColumnName:@"ZIMPORTEDFROMLEGACY"] forKey:@"ZIMPORTEDFROMLEGACY"];
        [param setObject:[rs objectForColumnName:@"ZACCOUNT3"] forKey:@"ZACCOUNT3"];
        [param setObject:[rs objectForColumnName:@"ZPARENT"] forKey:@"ZPARENT"];
        [param setObject:[rs objectForColumnName:@"ZDURATION"] forKey:@"ZDURATION"];
        [param setObject:[rs objectForColumnName:@"ZMODIFICATIONDATE"] forKey:@"ZMODIFICATIONDATE"];
        [param setObject:[rs objectForColumnName:@"ZORIGINX"] forKey:@"ZORIGINX"];
        [param setObject:[rs objectForColumnName:@"ZORIGINY"] forKey:@"ZORIGINY"];
        [param setObject:[rs objectForColumnName:@"ZPREVIEWUPDATEDATE"] forKey:@"ZPREVIEWUPDATEDATE"];
        [param setObject:[rs objectForColumnName:@"ZSIZEHEIGHT"] forKey:@"ZSIZEHEIGHT"];
        [param setObject:[rs objectForColumnName:@"ZSIZEWIDTH"] forKey:@"ZSIZEWIDTH"];
        [param setObject:[rs objectForColumnName:@"ZHEIGHT"] forKey:@"ZHEIGHT"];
        [param setObject:[rs objectForColumnName:@"ZMODIFIEDDATE"] forKey:@"ZMODIFIEDDATE"];
        [param setObject:[rs objectForColumnName:@"ZSCALE"] forKey:@"ZSCALE"];
        [param setObject:[rs objectForColumnName:@"ZWIDTH"] forKey:@"ZWIDTH"];
        [param setObject:[rs objectForColumnName:@"ZSTATEMODIFICATIONDATE"] forKey:@"ZSTATEMODIFICATIONDATE"];
        [param setObject:[rs objectForColumnName:@"ZMODIFICATIONDATEATIMPORT"] forKey:@"ZMODIFICATIONDATEATIMPORT"];
        [param setObject:[rs objectForColumnName:@"ZCREATIONDATE"] forKey:@"ZCREATIONDATE"];
        [param setObject:[rs objectForColumnName:@"ZLEGACYMODIFICATIONDATEATIMPORT"] forKey:@"ZLEGACYMODIFICATIONDATEATIMPORT"];
        [param setObject:[rs objectForColumnName:@"ZMODIFICATIONDATE1"] forKey:@"ZMODIFICATIONDATE1"];
        [param setObject:[rs objectForColumnName:@"ZDATEFORLASTTITLEMODIFICATION"] forKey:@"ZDATEFORLASTTITLEMODIFICATION"];
        [param setObject:[rs objectForColumnName:@"ZPARENTMODIFICATIONDATE"] forKey:@"ZPARENTMODIFICATIONDATE"];
        NSString *identifier = [rs objectForColumnName:@"ZIDENTIFIER"];

        [param setObject:identifier forKey:@"ZIDENTIFIER"];
        [param setObject:[rs objectForColumnName:@"ZSUMMARY"] forKey:@"ZSUMMARY"];
        [param setObject:[rs objectForColumnName:@"ZTITLE"] forKey:@"ZTITLE"];
        [param setObject:[rs objectForColumnName:@"ZTYPEUTI"] forKey:@"ZTYPEUTI"];
        [param setObject:[rs objectForColumnName:@"ZURLSTRING"] forKey:@"ZURLSTRING"];
        [param setObject:[rs objectForColumnName:@"ZDEVICEIDENTIFIER"] forKey:@"ZDEVICEIDENTIFIER"];
        [param setObject:[rs objectForColumnName:@"ZCONTENTHASHATIMPORT"] forKey:@"ZCONTENTHASHATIMPORT"];
        NSString *fileName = [rs objectForColumnName:@"ZFILENAME"];
        [param setObject:fileName forKey:@"ZFILENAME"];
        if (z_ent == preViewZENT) {
            NSString *identiPath = [NSString stringWithFormat:@"Previews/%@.png",identifier];
            [_attachmentIdentifierList addObject:identiPath];
        }else if (z_ent == mediaZENT){
            NSString *identifolderPath = [NSString stringWithFormat:@"Media/%@",identifier];
            [_attachmentIdentifierList addObject:identifolderPath];
            NSString *identiPath = [NSString stringWithFormat:@"Media/%@/%@",identifier,fileName];
            [_attachmentIdentifierList addObject:identiPath];
        }
        [param setObject:[rs objectForColumnName:@"ZLEGACYCONTENTHASHATIMPORT"] forKey:@"ZLEGACYCONTENTHASHATIMPORT"];
        [param setObject:[rs objectForColumnName:@"ZLEGACYIMPORTDEVICEIDENTIFIER"] forKey:@"ZLEGACYIMPORTDEVICEIDENTIFIER"];
        [param setObject:[rs objectForColumnName:@"ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION"] forKey:@"ZLEGACYMANAGEDOBJECTIDURIREPRESENTATION"];
        [param setObject:[rs objectForColumnName:@"ZSNIPPET"] forKey:@"ZSNIPPET"];
        [param setObject:[rs objectForColumnName:@"ZTHUMBNAILATTACHMENTIDENTIFIER"] forKey:@"ZTHUMBNAILATTACHMENTIDENTIFIER"];
        [param setObject:[rs objectForColumnName:@"ZTITLE1"] forKey:@"ZTITLE1"];
        [param setObject:[rs objectForColumnName:@"ZACCOUNTNAMEFORACCOUNTLISTSORTING"] forKey:@"ZACCOUNTNAMEFORACCOUNTLISTSORTING"];
        [param setObject:[rs objectForColumnName:@"ZNESTEDTITLEFORSORTING"] forKey:@"ZNESTEDTITLEFORSORTING"];
        [param setObject:[rs objectForColumnName:@"ZNAME"] forKey:@"ZNAME"];
        [param setObject:[rs objectForColumnName:@"ZUSERRECORDNAME"] forKey:@"ZUSERRECORDNAME"];
        [param setObject:[rs objectForColumnName:@"ZTITLE2"] forKey:@"ZTITLE2"];
        [param setObject:[rs objectForColumnName:@"ZMERGEABLEDATA"] forKey:@"ZMERGEABLEDATA"];
        [param setObject:[rs objectForColumnName:@"ZMETADATA"] forKey:@"ZMETADATA"];
        
        if ([_targetFloatVersion isVersionMajorEqual:@"11"]) {
            if (z_ent == noteZENT) {
                [param setObject:@(_defaultFolderZPK) forKey:@"ZFOLDER"];
            }else{
                [param setObject:[NSNull null] forKey:@"ZFOLDER"];
            }
        }else{
            if ([_sourceFloatVersion isVersionLess:@"11"]) {
                [param setObject:[rs objectForColumnName:@"ZFOLDERSMODIFICATIONDATE"] forKey:@"ZFOLDERSMODIFICATIONDATE"];
                [param setObject:[rs objectForColumnName:@"ZLEGACYNOTEINTEGERID"] forKey:@"ZLEGACYNOTEINTEGERID"];
                [param setObject:[rs objectForColumnName:@"ZINTEGERID"] forKey:@"ZINTEGERID"];
                [param setObject:[rs objectForColumnName:@"ZSERVERRECORD"] forKey:@"ZSERVERRECORD"];
                [param setObject:[rs objectForColumnName:@"ZREMOTEFILEURL"] forKey:@"ZREMOTEFILEURL"];
            }else{
                [param setObject:[NSNull null] forKey:@"ZFOLDERSMODIFICATIONDATE"];
                [param setObject:[NSNull null] forKey:@"ZLEGACYNOTEINTEGERID"];
                [param setObject:[NSNull null] forKey:@"ZINTEGERID"];
                [param setObject:[NSNull null] forKey:@"ZSERVERRECORD"];
                [param setObject:[NSNull null] forKey:@"ZREMOTEFILEURL"];
            }
        }
        if ([_sourceFloatVersion isVersionMajorEqual:@"10"] && [_targetFloatVersion isVersionMajorEqual:@"10"]) {
            [param setObject:[rs objectForColumnName:@"ZATTACHMENT"] forKey:@"ZATTACHMENT"];
        }else if ([_sourceFloatVersion isVersionMajorEqual:@"10"] && [_targetFloatVersion isVersionLess:@"10"])
        {
            int attach = [rs intForColumn:@"ZATTACHMENT"];
            if (z_ent == preViewZENT) {
                [self InsertClone4PREVIEWIMAGESTable:attach previewId:zpk targetDB:_targetDBConnection];
            }
        }else if ([_sourceFloatVersion isVersionLessEqual:@"10"] && [_targetFloatVersion isVersionMajorEqual:@"10"]){
            if (z_ent == preViewZENT) {
                if ([preAttachList.allKeys containsObject:@(z_pk)]) {
                    [param setObject:[preAttachList objectForKey:@(z_pk)] forKey:@"ZATTACHMENT"];
                }
            }
        }
        if ([_targetFloatVersion isVersionMajorEqual:@"10"] && z_ent == noteZENT) {
            [param setObject:[NSNull null] forKey:@"ZATTACHMENTVIEWTYPE"];
            [param setObject:[NSNull null] forKey:@"ZNEEDSTOSAVEUSERSPECIFICRECORD"];
            [param setObject:@(0) forKey:@"ZMINIMUMSUPPORTEDNOTESVERSION"];
        }else if ([_targetFloatVersion isVersionMajorEqual:@"10"] && z_ent != noteZENT){
            [param setObject:@(0) forKey:@"ZATTACHMENTVIEWTYPE"];
            [param setObject:@(1) forKey:@"ZNEEDSTOSAVEUSERSPECIFICRECORD"];
            [param setObject:@(0) forKey:@"ZMINIMUMSUPPORTEDNOTESVERSION"];
        }
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)InsertClone4PREVIEWIMAGESTable:(int)attachId previewId:(int)previewId targetDB:(FMDatabase *)targetDB
{
    NSString *sql = @"insert into Z_4PREVIEWIMAGES (Z_4ATTACHMENTS, Z_5PREVIEWIMAGES)values(:Z_4ATTACHMENTS, :Z_5PREVIEWIMAGES)";
    [targetDB executeUpdate:sql withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(attachId),@"Z_4ATTACHMENTS",@(previewId),@"Z_5PREVIEWIMAGES", nil]];
}

- (void)transfer4PREVIEWIMAGESTable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"Z_4PREVIEWIMAGES"];
    NSString *sourceSql = @"SELECT Z_4ATTACHMENTS, Z_5PREVIEWIMAGES FROM Z_4PREVIEWIMAGES";
    NSString *targetSql = @"insert into Z_4PREVIEWIMAGES (Z_4ATTACHMENTS, Z_5PREVIEWIMAGES)values(:Z_4ATTACHMENTS, :Z_5PREVIEWIMAGES)";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_4ATTACHMENTS"] forKey:@"Z_4ATTACHMENTS"];
        [param setObject:[rs objectForColumnName:@"Z_5PREVIEWIMAGES"] forKey:@"Z_5PREVIEWIMAGES"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferZICAUTHORTable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"ZICAUTHOR"];
    int z_ent = 2;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICAuthor'";
    FMResultSet *rs1 = [targetDB executeQuery:sql];
    while ([rs1 next]) {
        z_ent = [rs1 intForColumnIndex:0];
        break;
    }
    [rs1 close];
    NSString *sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZSTATUS,ZGROUP,ZPERSON FROM ZICAUTHOR";
    NSString *targetSql = @"insert into ZICAUTHOR (Z_PK, Z_ENT,Z_OPT,ZSTATUS,ZGROUP,ZPERSON)values(:Z_PK, :Z_ENT,:Z_OPT,:ZSTATUS,:ZGROUP,:ZPERSON)";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_PK"] forKey:@"Z_PK"];
        [param setObject:@(z_ent) forKey:@"Z_ENT"];
        [param setObject:[rs objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [param setObject:[rs objectForColumnName:@"ZGROUP"] forKey:@"ZGROUP"];
        [param setObject:[rs objectForColumnName:@"ZPERSON"] forKey:@"ZPERSON"];
        [param setObject:[rs objectForColumnName:@"ZSTATUS"] forKey:@"ZSTATUS"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferZICPERSONTable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"ZICPERSON"];
    int z_ent = 2;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICPerson'";
    FMResultSet *rs1 = [targetDB executeQuery:sql];
    while ([rs1 next]) {
        z_ent = [rs1 intForColumnIndex:0];
        break;
    }
    [rs1 close];
    NSString *sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZIDENTIFIER,ZNAME,ZPUBLICCLOUDKITRECORDNAME FROM ZICPERSON";
    NSString *targetSql = @"insert into ZICPERSON (Z_PK, Z_ENT,Z_OPT,ZIDENTIFIER,ZNAME,ZPUBLICCLOUDKITRECORDNAME)values(:Z_PK, :Z_ENT,:Z_OPT,:ZIDENTIFIER,:ZNAME,:ZPUBLICCLOUDKITRECORDNAME)";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_PK"] forKey:@"Z_PK"];
        [param setObject:@(z_ent) forKey:@"Z_ENT"];
        [param setObject:[rs objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [param setObject:[rs objectForColumnName:@"ZIDENTIFIER"] forKey:@"ZIDENTIFIER"];
        [param setObject:[rs objectForColumnName:@"ZNAME"] forKey:@"ZNAME"];
        [param setObject:[rs objectForColumnName:@"ZPUBLICCLOUDKITRECORDNAME"] forKey:@"ZPUBLICCLOUDKITRECORDNAME"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferZICDDEVICETable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"ZICDDEVICE"];
    int z_ent = 2;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICDDevice'";
    FMResultSet *rs1 = [targetDB executeQuery:sql];
    while ([rs1 next]) {
        z_ent = [rs1 intForColumnIndex:0];
        break;
    }
    [rs1 close];
    NSString *sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZSHARINGEXTENSIONDEVICE,ZPERSON,ZIDENTIFIER,ZNAME FROM ZICDDEVICE";
    NSString *targetSql = @"insert into ZICDDEVICE (Z_PK, Z_ENT,Z_OPT,ZSHARINGEXTENSIONDEVICE,ZPERSON,ZIDENTIFIER,ZNAME)values(:Z_PK,:Z_ENT,:Z_OPT,:ZSHARINGEXTENSIONDEVICE,:ZPERSON,:ZIDENTIFIER,:ZNAME)";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_PK"] forKey:@"Z_PK"];
        [param setObject:@(z_ent) forKey:@"Z_ENT"];
        [param setObject:[rs objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [param setObject:[rs objectForColumnName:@"ZSHARINGEXTENSIONDEVICE"] forKey:@"ZSHARINGEXTENSIONDEVICE"];
        [param setObject:[rs objectForColumnName:@"ZPERSON"] forKey:@"ZPERSON"];
        [param setObject:[rs objectForColumnName:@"ZIDENTIFIER"] forKey:@"ZIDENTIFIER"];
        [param setObject:[rs objectForColumnName:@"ZNAME"] forKey:@"ZNAME"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferZICGROUPTable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"ZICGROUP"];
    int z_ent = 2;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICGroup'";
    FMResultSet *rs1 = [targetDB executeQuery:sql];
    while ([rs1 next]) {
        z_ent = [rs1 intForColumnIndex:0];
        break;
    }
    [rs1 close];
    NSString *sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZSHARETIMESTAMP,ZNOTES,ZIDENTIFIER FROM ZICGROUP";
    NSString *targetSql = @"insert into ZICGROUP (Z_PK, Z_ENT,Z_OPT,ZSHARETIMESTAMP,ZNOTES,ZIDENTIFIER)values(:Z_PK, :Z_ENT,:Z_OPT,:ZSHARETIMESTAMP,:ZNOTES,:ZIDENTIFIER)";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_PK"] forKey:@"Z_PK"];
        [param setObject:@(z_ent) forKey:@"Z_ENT"];
        [param setObject:[rs objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [param setObject:[rs objectForColumnName:@"ZSHARETIMESTAMP"] forKey:@"ZSHARETIMESTAMP"];
        [param setObject:[rs objectForColumnName:@"ZNOTES"] forKey:@"ZNOTES"];
        [param setObject:[rs objectForColumnName:@"ZIDENTIFIER"] forKey:@"ZIDENTIFIER"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferZICLOCATIONTable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"ZICLOCATION"];
    int z_ent = 2;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICLocation'";
    FMResultSet *rs1 = [targetDB executeQuery:sql];
    while ([rs1 next]) {
        z_ent = [rs1 intForColumnIndex:0];
        break;
    }
    [rs1 close];
    NSString *sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZPLACEUPDATED,ZATTACHMENT,ZLATITUDE,ZLONGITUDE,ZPLACEMARK FROM ZICLOCATION";
    NSString *targetSql = @"insert into ZICLOCATION (Z_PK, Z_ENT,Z_OPT,ZPLACEUPDATED,ZATTACHMENT,ZLATITUDE,ZLONGITUDE,ZPLACEMARK)values(:Z_PK, :Z_ENT,:Z_OPT,:ZPLACEUPDATED,:ZATTACHMENT,:ZLATITUDE,:ZLONGITUDE,:ZPLACEMARK)";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_PK"] forKey:@"Z_PK"];
        [param setObject:@(z_ent) forKey:@"Z_ENT"];
        [param setObject:[rs objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [param setObject:[rs objectForColumnName:@"ZPLACEUPDATED"] forKey:@"ZPLACEUPDATED"];
        [param setObject:[rs objectForColumnName:@"ZATTACHMENT"] forKey:@"ZATTACHMENT"];
        [param setObject:[rs objectForColumnName:@"ZLATITUDE"] forKey:@"ZLATITUDE"];
        [param setObject:[rs objectForColumnName:@"ZLONGITUDE"] forKey:@"ZLONGITUDE"];
        [param setObject:[rs objectForColumnName:@"ZPLACEMARK"] forKey:@"ZPLACEMARK"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferZICNOTECHANGETable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"ZICNOTECHANGE"];
    int z_ent = 2;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICNoteChange'";
    FMResultSet *rs1 = [targetDB executeQuery:sql];
    while ([rs1 next]) {
        z_ent = [rs1 intForColumnIndex:0];
        break;
    }
    [rs1 close];
    NSString *sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZCHANGETYPE,ZFOLDER,ZLEGACYNOTEINTEGERIDS,ZNOTEIDENTIFIERS FROM ZICNOTECHANGE";
    NSString *targetSql = @"insert into ZICNOTECHANGE (Z_PK, Z_ENT,Z_OPT,ZCHANGETYPE,ZFOLDER,ZLEGACYNOTEINTEGERIDS,ZNOTEIDENTIFIERS)values(:Z_PK, :Z_ENT,:Z_OPT,:ZCHANGETYPE,:ZFOLDER,:ZLEGACYNOTEINTEGERIDS,:ZNOTEIDENTIFIERS)";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_PK"] forKey:@"Z_PK"];
        [param setObject:@(z_ent) forKey:@"Z_ENT"];
        [param setObject:[rs objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [param setObject:[rs objectForColumnName:@"ZCHANGETYPE"] forKey:@"ZCHANGETYPE"];
        [param setObject:[rs objectForColumnName:@"ZFOLDER"] forKey:@"ZFOLDER"];
        [param setObject:[rs objectForColumnName:@"ZLEGACYNOTEINTEGERIDS"] forKey:@"ZLEGACYNOTEINTEGERIDS"];
        [param setObject:[rs objectForColumnName:@"ZNOTEIDENTIFIERS"] forKey:@"ZNOTEIDENTIFIERS"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferZICNOTEDATATable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"ZICNOTEDATA"];
    int z_ent = 2;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICNoteData'";
    FMResultSet *rs1 = [targetDB executeQuery:sql];
    while ([rs1 next]) {
        z_ent = [rs1 intForColumnIndex:0];
        break;
    }
    [rs1 close];
    NSString *sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZNOTE,ZDATA FROM ZICNOTEDATA";
    NSString *targetSql = @"insert into ZICNOTEDATA (Z_PK, Z_ENT,Z_OPT,ZNOTE,ZDATA)values(:Z_PK, :Z_ENT,:Z_OPT,:ZNOTE,:ZDATA)";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_PK"] forKey:@"Z_PK"];
        [param setObject:@(z_ent) forKey:@"Z_ENT"];
        [param setObject:[rs objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [param setObject:[rs objectForColumnName:@"ZNOTE"] forKey:@"ZNOTE"];
        [param setObject:[rs objectForColumnName:@"ZDATA"] forKey:@"ZDATA"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferZICSEARCHINDEXTRANSACTIONTable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"ZICSEARCHINDEXTRANSACTION"];
    int z_ent = 2;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICSearchIndexTransaction'";
    FMResultSet *rs1 = [targetDB executeQuery:sql];
    while ([rs1 next]) {
        z_ent = [rs1 intForColumnIndex:0];
        break;
    }
    [rs1 close];
    NSString *sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZLASTTRANSACTIONID,ZIDENTIFIER FROM ZICSEARCHINDEXTRANSACTION";
    NSString *targetSql = @"insert into ZICSEARCHINDEXTRANSACTION (Z_PK, Z_ENT,Z_OPT,ZLASTTRANSACTIONID,ZIDENTIFIER) values (:Z_PK, :Z_ENT,:Z_OPT,:ZLASTTRANSACTIONID,:ZIDENTIFIER)";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_PK"] forKey:@"Z_PK"];
        [param setObject:@(z_ent) forKey:@"Z_ENT"];
        [param setObject:[rs objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [param setObject:[rs objectForColumnName:@"ZLASTTRANSACTIONID"] forKey:@"ZLASTTRANSACTIONID"];
        [param setObject:[rs objectForColumnName:@"ZIDENTIFIER"] forKey:@"ZIDENTIFIER"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferZICSERVERCHANGETOKENTable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"ZICSERVERCHANGETOKEN"];
    int z_ent = 2;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='ICServerChangeToken'";
    FMResultSet *rs1 = [targetDB executeQuery:sql];
    while ([rs1 next]) {
        z_ent = [rs1 intForColumnIndex:0];
        break;
    }
    [rs1 close];
    NSString *sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZACCOUNT,ZZONENAME,ZCKSERVERCHANGETOKEN FROM ZICSERVERCHANGETOKEN";
    NSString *targetSql = @"insert into ZICSERVERCHANGETOKEN (Z_PK, Z_ENT,Z_OPT,ZACCOUNT,ZZONENAME,ZCKSERVERCHANGETOKEN)values(:Z_PK, :Z_ENT,:Z_OPT,:ZACCOUNT,:ZZONENAME,:ZCKSERVERCHANGETOKEN)";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_PK"] forKey:@"Z_PK"];
        [param setObject:@(z_ent) forKey:@"Z_ENT"];
        [param setObject:[rs objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [param setObject:[rs objectForColumnName:@"ZACCOUNT"] forKey:@"ZACCOUNT"];
        [param setObject:[rs objectForColumnName:@"ZZONENAME"] forKey:@"ZZONENAME"];
        [param setObject:[rs objectForColumnName:@"ZCKSERVERCHANGETOKEN"] forKey:@"ZCKSERVERCHANGETOKEN"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}

- (void)transferZNEXTIDTable:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    [self clearTable:_targetDBConnection TableName:@"ZNEXTID"];
    int z_ent = 2;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='NextId'";
    FMResultSet *rs1 = [targetDB executeQuery:sql];
    while ([rs1 next]) {
        z_ent = [rs1 intForColumnIndex:0];
        break;
    }
    [rs1 close];
    NSString *sourceSql = @"SELECT Z_PK, Z_ENT,Z_OPT,ZCOUNTER FROM ZNEXTID";
    NSString *targetSql = @"insert into ZNEXTID (Z_PK, Z_ENT,Z_OPT,ZCOUNTER)values(:Z_PK, :Z_ENT,:Z_OPT,:ZCOUNTER)";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sourceSql];
    while ([rs next]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[rs objectForColumnName:@"Z_PK"] forKey:@"Z_PK"];
        [param setObject:@(z_ent) forKey:@"Z_ENT"];
        [param setObject:[rs objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
        [param setObject:[rs objectForColumnName:@"ZCOUNTER"] forKey:@"ZCOUNTER"];
        [_targetDBConnection executeUpdate:targetSql withParameterDictionary:param];
    }
    [rs close];
}


- (void)cloneHightToLow:(FMDatabase *)sourceDB  targetDB:(FMDatabase *)targetDB
{
    [self transferAvove9ToZNOTERecords:sourceDB targetDB:targetDB];
    [self updatePrimerKey:targetDB];
}

- (void)transferAvove9ToZNOTERecords:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    NSString *IOS9SelectStr = @"SELECT note.Z_OPT,ZMARKEDFORDELETION,ZNOTEDATA,ZDATA,ZCREATIONDATE,ZMODIFICATIONDATE1,ZIDENTIFIER,ZSNIPPET,ZTITLE1 FROM ZICCLOUDSYNCINGOBJECT as note,ZICNOTEDATA as noteData where note.Z_ENT==9 and note.ZNOTEDATA=noteData.Z_PK and ZMARKEDFORDELETION!=1 and note.Z_PK not in (";
    if (_sourceVersion>=10) {
        IOS9SelectStr = [IOS9SelectStr stringByAppendingString:@"SELECT Z_8NOTES FROM Z_11NOTES WHERE Z_11FOLDERS IN (SELECT Z_PK FROM ZICCLOUDSYNCINGOBJECT WHERE ZIDENTIFIER = 'TrashFolder-LocalAccount'))"];

    }else{
        IOS9SelectStr = [IOS9SelectStr stringByAppendingString:@"SELECT Z_9NOTES FROM Z_12NOTES WHERE Z_12FOLDERS IN (SELECT Z_PK FROM ZICCLOUDSYNCINGOBJECT WHERE ZIDENTIFIER = 'TrashFolder-LocalAccount'))"];
    }
    
    NSString *IOS6InsertStr = @"insert into ZNOTE(Z_ENT, Z_OPT, ZCONTAINSCJK, ZCONTENTTYPE, ZDELETEDFLAG, ZEXTERNALFLAGS,  ZEXTERNALSERVERINTID, ZINTEGERID, ZISBOOKKEEPINGENTRY, ZBODY, ZSTORE, ZCREATIONDATE, ZMODIFICATIONDATE, ZGUID, ZSUMMARY, ZTITLE) values(:Z_ENT, :Z_OPT, :ZCONTAINSCJK, :ZCONTENTTYPE, :ZDELETEDFLAG,:ZEXTERNALFLAGS,:ZEXTERNALSERVERINTID,:ZINTEGERID, :ZISBOOKKEEPINGENTRY, :ZBODY, :ZSTORE, :ZCREATIONDATE, :ZMODIFICATIONDATE, :ZGUID, :ZSUMMARY, :ZTITLE)";
    int z_ent = 3;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='Note'";
    FMResultSet *rs = [targetDB executeQuery:sql];
    while ([rs next]) {
        z_ent = [rs intForColumn:@"Z_ENT"];
    }
    [rs close];
    int storeId = 1;
    NSString *sql1 = @"select Z_PK from ZSTORE where ZNAME='LOCAL_NOTES_STORE'";
    FMResultSet *rs1 = [targetDB executeQuery:sql1];
    while ([rs1 next]) {
        storeId = [rs1 intForColumn:@"Z_PK"];
    }
    [rs1 close];
    FMResultSet *noters = [sourceDB executeQuery:IOS9SelectStr];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    while ([noters next]) {
        int newNoteID = -1;
        [param setObject:@(z_ent) forKey:@"Z_ENT"];
        [param setObject:@(1) forKey:@"Z_OPT"];
        
        [param setObject:@(0) forKey:@"ZCONTAINSCJK"];
        [param setObject:@(0) forKey:@"ZCONTENTTYPE"];
        [param setObject:@(0) forKey:@"ZEXTERNALFLAGS"];
        [param setObject:@(0) forKey:@"ZEXTERNALSERVERINTID"];
        [param setObject:@(0) forKey:@"ZINTEGERID"];
        [param setObject:@(0) forKey:@"ZISBOOKKEEPINGENTRY"];
        [param setObject:@"" forKey:@"ZSUMMARY"];
        [param setObject:@(0) forKey:@"ZDELETEDFLAG"];
        [param setObject:@(0) forKey:@"ZBODY"];
        [param setObject:@(storeId) forKey:@"ZSTORE"];
        [param setObject:@([noters doubleForColumn:@"ZCREATIONDATE"]) forKey:@"ZCREATIONDATE"];
        [param setObject:@([noters doubleForColumn:@"ZCREATIONDATE"]) forKey:@"ZMODIFICATIONDATE"];
        [param setObject:[noters objectForColumnName:@"ZIDENTIFIER"] forKey:@"ZGUID"];
        [param setObject:[noters objectForColumnName:@"ZTITLE1"] forKey:@"ZTITLE"];
        if ([targetDB executeUpdate:IOS6InsertStr withParameterDictionary:param]) {
            NSString *sql = @"select last_insert_rowid() from ZNOTE";
            FMResultSet *rs = [_targetDBConnection executeQuery:sql];
            while ([rs next]) {
                newNoteID = [rs intForColumn:@"last_insert_rowid()"];
            }
            [rs close];
            
            NSString *sql1 = @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
            [targetDB executeUpdate:sql1 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(newNoteID),@"Z_MAX",@"Note",@"Z_NAME", nil]];
            
            int z_NoteBody_ent = 4;
            NSString *sql2 = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='NoteBody'";
            FMResultSet *rs2 = [targetDB executeQuery:sql2];
            while ([rs2 next]) {
                z_NoteBody_ent = [rs2 intForColumn:@"Z_ENT"];
            }
            [rs2 close];
            NSString *sql3 = @"insert into ZNOTEBODY(Z_ENT, Z_OPT, ZOWNER, ZCONTENT) values( :Z_ENT, :Z_OPT, :ZOWNER, :ZCONTENT)";
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:@(z_NoteBody_ent) forKey:@"Z_ENT"];
            [param setObject:@([noters intForColumn:@"Z_OPT"]) forKey:@"Z_OPT"];
            [param setObject:@(newNoteID) forKey:@"ZOWNER"];
            
            NSData *titleData = [noters dataForColumn:@"ZDATA"];
            NSString *content = [self analysisNoteData:titleData withIsCompress:YES];
            if (content.length>0) {
                [param setObject:content forKey:@"ZCONTENT"];
            }else{
                [param setObject:[noters objectForColumnName:@"ZTITLE1"] forKey:@"ZCONTENT"];
            }
            if ([targetDB executeUpdate:sql3 withParameterDictionary:param]) {
                NSString *sql = @"select z_pk from znotebody where ZOWNER=:zowner";
                FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:[NSDictionary dictionaryWithObject:@(newNoteID) forKey:@"zowner"]];
                while ([rs next]) {
                    int notebodyID = [rs intForColumn:@"z_pk"];
                    NSString *sql1 = @"update Z_PRIMARYKEY set Z_MAX=:Z_MAX WHERE Z_NAME=:Z_NAME";
                    [targetDB executeUpdate:sql1 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(notebodyID),@"Z_MAX",@"NoteBody",@"Z_NAME", nil]];
                    
                    NSString *sql2 = @"update znote set zbody=:zbody where z_pk=:z_pk";
                    [targetDB executeUpdate:sql2 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(notebodyID),@"zbody",@(newNoteID),@"z_pk", nil]];
                }
                [rs close];
            }
        }
    }
    [noters close];
}

- (void)updatePrimerKey:(FMDatabase *)targetDB
{
    NSString *sql = @"update Z_PRIMARYKEY set Z_MAX=(select Max(Z_PK) FROM ZNOTE) WHERE Z_NAME='Note'";
    [targetDB executeUpdate:sql];
    NSString *sql1 = @"pdate Z_PRIMARYKEY set Z_MAX=(select Max(Z_PK) FROM ZNOTEBODY) WHERE Z_NAME='NoteBody'";
    [targetDB executeUpdate:sql1];
}

- (void)clearTable:(FMDatabase *)targetDB TableName:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@",tableName];
    [targetDB executeUpdate:sql];
}

- (void)deleteNoteData
{
    NSString *sql1 = @"delete from ZNOTE";
    NSString *sql2 = @"delete from ZNOTEBODY";
    [_targetDBConnection executeUpdate:sql1];
    [_targetDBConnection executeUpdate:sql2];
}

- (int)getStoreID
{
    int storeID=1;
    NSString *sql = @"select Z_PK from ZSTORE where ZNAME='LOCAL_NOTES_STORE'";
    FMResultSet *set = [_targetDBConnection executeQuery:sql];
    while ([set next]) {
        storeID = [set intForColumn:@"Z_PK"];
    }
    [set close];
    return storeID;
}

- (int)getZENT
{
    int Z_ENT = 4;
    NSString *sql = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='NoteBody'";
    FMResultSet *set = [_targetDBConnection executeQuery:sql];
    while ([set next]) {
        Z_ENT = [set intForColumn:@"Z_ENT"];
    }
    [set close];
    return Z_ENT;
}
//表ZACCOUNT
- (void)insertZACCOUNT
{
    [_logHandle writeInfoLog:@"insert Note table ZACCOUNT enter"];
    //face_time_data
    NSString *sql1 = @"select * from ZACCOUNT";
    NSString *sql2 = @"insert into ZACCOUNT(Z_PK,Z_ENT,Z_OPT,ZTYPE,ZDEFAULTSTORE,ZACCOUNTIDENTIFIER,ZCONSTRAINTSPATH,ZNAME) values(?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger Z_PK = [rs intForColumn:@"Z_PK"];
        NSInteger Z_ENT = [rs intForColumn:@"Z_ENT"];
        NSInteger Z_OPT = [rs intForColumn:@"Z_OPT"];
        NSInteger ZTYPE = [rs intForColumn:@"ZTYPE"];
        NSInteger ZDEFAULTSTORE = [rs intForColumn:@"ZDEFAULTSTORE"];
        NSString *ZACCOUNTIDENTIFIER = [rs stringForColumn:@"ZACCOUNTIDENTIFIER"];
        NSString *ZCONSTRAINTSPATH = [rs stringForColumn:@"ZCONSTRAINTSPATH"];
        NSString *ZNAME = [rs stringForColumn:@"ZNAME"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:Z_PK],[NSNumber numberWithInt:Z_ENT],[NSNumber numberWithInt:Z_OPT],[NSNumber numberWithInt:ZTYPE],[NSNumber numberWithInt:ZDEFAULTSTORE],ZACCOUNTIDENTIFIER,ZCONSTRAINTSPATH,ZNAME];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Note table ZACCOUNT exit"];
}
//表ZNEXTID
- (void)insertZNEXTID
{
    [_logHandle writeInfoLog:@"insert Note table ZNEXTID enter"];
    //face_time_data
    NSString *sql1 = @"select * from ZNEXTID";
    NSString *sql2 = @"insert into ZNEXTID(Z_PK,Z_ENT,Z_OPT,ZCOUNTER) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger Z_PK = [rs intForColumn:@"Z_PK"];
        NSInteger Z_ENT = [rs intForColumn:@"Z_ENT"];
        NSInteger Z_OPT = [rs intForColumn:@"Z_OPT"];
        NSInteger ZCOUNTER = [rs intForColumn:@"ZCOUNTER"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:Z_PK],[NSNumber numberWithInt:Z_ENT],[NSNumber numberWithInt:Z_OPT],[NSNumber numberWithInt:ZCOUNTER]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Note table ZNEXTID exit"];
}
//表ZNEXTID
- (void)insertZNOTE
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Note table ZNOTE enter"];
    NSString *sql1 = @"select * from ZNOTE";
    NSString *sql2 = @"insert into ZNOTE(Z_PK,Z_ENT,Z_OPT,ZCONTAINSCJK,ZCONTENTTYPE,ZDELETEDFLAG,ZEXTERNALFLAGS,ZEXTERNALSERVERINTID,ZINTEGERID,ZISBOOKKEEPINGENTRY,ZBODY,ZSTORE,ZCREATIONDATE,ZMODIFICATIONDATE,ZGUID,ZSERVERID,ZSUMMARY,ZTITLE) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger Z_PK = [rs intForColumn:@"Z_PK"];
        NSInteger Z_ENT = [rs intForColumn:@"Z_ENT"];
        NSInteger Z_OPT = [rs intForColumn:@"Z_OPT"];
        NSInteger ZCONTAINSCJK = [rs intForColumn:@"ZCONTAINSCJK"];
        NSInteger ZCONTENTTYPE = [rs intForColumn:@"ZCONTENTTYPE"];
        NSInteger ZDELETEDFLAG = [rs intForColumn:@"ZDELETEDFLAG"];
        NSInteger ZEXTERNALFLAGS = [rs intForColumn:@"ZEXTERNALFLAGS"];
        //NSInteger ZEXTERNALSEQUENCENUMBER = [rs intForColumn:@"ZEXTERNALSEQUENCENUMBER"];
        NSInteger ZEXTERNALSERVERINTID = [rs intForColumn:@"ZEXTERNALSERVERINTID"];
        NSInteger ZINTEGERID = [rs intForColumn:@"ZINTEGERID"];
        NSInteger ZISBOOKKEEPINGENTRY = [rs intForColumn:@"ZISBOOKKEEPINGENTRY"];
        NSInteger ZBODY = [rs intForColumn:@"ZBODY"];
        NSInteger ZSTORE = [self getStoreID];
        double ZCREATIONDATE = [rs doubleForColumn:@"ZCREATIONDATE"];
        double ZMODIFICATIONDATE = [rs doubleForColumn:@"ZMODIFICATIONDATE"];
        NSString *ZGUID = [rs stringForColumn:@"ZGUID"];
        NSString *ZSERVERID = [rs stringForColumn:@"ZSERVERID"];
        NSString *ZSUMMARY = [rs stringForColumn:@"ZSUMMARY"];
        NSString *ZTITLE = [rs stringForColumn:@"ZTITLE"];
       
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:Z_PK],[NSNumber numberWithInt:Z_ENT],[NSNumber numberWithInt:Z_OPT],[NSNumber numberWithInt:ZCONTAINSCJK],[NSNumber numberWithInt:ZCONTENTTYPE],[NSNumber numberWithInt:ZDELETEDFLAG],[NSNumber numberWithInt:ZEXTERNALFLAGS],[NSNumber numberWithInt:ZEXTERNALSERVERINTID],[NSNumber numberWithInt:ZINTEGERID],[NSNumber numberWithInt:ZISBOOKKEEPINGENTRY],[NSNumber numberWithInt:ZBODY],[NSNumber numberWithInt:ZSTORE],[NSNumber numberWithDouble:ZCREATIONDATE],[NSNumber numberWithDouble:ZMODIFICATIONDATE],ZGUID,ZSERVERID,ZSUMMARY,ZTITLE];
       
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Note table ZNOTE exit"];
}

//表ZNOTEBODY
- (void)insertZNOTEBODY
{
    //face_time_data
     [_logHandle writeInfoLog:@"insert Note table ZNOTEBODY enter"];
    NSString *sql1 = @"select * from ZNOTEBODY";
    NSString *sql2 = @"insert into ZNOTEBODY(Z_PK,Z_ENT,Z_OPT,ZOWNER,ZCONTENT,ZEXTERNALCONTENTREF,ZEXTERNALREPRESENTATION) values(?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger Z_PK = [rs intForColumn:@"Z_PK"];
        NSInteger Z_ENT = [self getZENT];
        NSInteger Z_OPT = [rs intForColumn:@"Z_OPT"];
        NSInteger ZOWNER = [rs intForColumn:@"ZOWNER"];
        NSString *ZCONTENT = [rs stringForColumn:@"ZCONTENT"];
        NSString *ZEXTERNALCONTENTREF = [rs stringForColumn:@"ZEXTERNALCONTENTREF"];
        NSData *ZEXTERNALREPRESENTATION = [rs dataForColumn:@"ZEXTERNALREPRESENTATION"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:Z_PK],[NSNumber numberWithInt:Z_ENT],[NSNumber numberWithInt:Z_OPT],[NSNumber numberWithInt:ZOWNER],ZCONTENT,ZEXTERNALCONTENTREF,ZEXTERNALREPRESENTATION];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Note table ZNOTEBODY exit"];
}

//表ZNOTECHANGE
- (void)insertZNOTECHANGE
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Note table ZNOTECHANGE enter"];
    NSString *sql1 = @"select * from ZNOTECHANGE";
    NSString *sql2 = @"insert into ZNOTECHANGE(Z_PK,Z_ENT,Z_OPT,ZCHANGETYPE,ZSTORE,ZNOTEINTEGERIDS,ZNOTESERVERIDS,ZNOTESERVERINTIDS) values(?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger Z_PK = [rs intForColumn:@"Z_PK"];
        NSInteger Z_ENT = [rs intForColumn:@"Z_ENT"];
        NSInteger Z_OPT = [rs intForColumn:@"Z_OPT"];
        NSInteger ZCHANGETYPE = [rs intForColumn:@"ZCHANGETYPE"];
        NSInteger ZSTORE = [rs intForColumn:@"ZSTORE"];
        NSData *ZNOTEINTEGERIDS = [rs dataForColumn:@"ZNOTEINTEGERIDS"];
        NSData *ZNOTESERVERIDS = [rs dataForColumn:@"ZNOTESERVERIDS"];
        NSData *ZNOTESERVERINTIDS = [rs dataForColumn:@"ZNOTESERVERINTIDS"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:Z_PK],[NSNumber numberWithInt:Z_ENT],[NSNumber numberWithInt:Z_OPT],[NSNumber numberWithInt:ZCHANGETYPE],[NSNumber numberWithInt:ZSTORE],ZNOTEINTEGERIDS,ZNOTESERVERIDS,ZNOTESERVERINTIDS];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Note table ZNOTECHANGE exit"];
}

//表ZPROPERTY
- (void)insertZPROPERTY
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Note table ZPROPERTY enter"];
    NSString *sql1 = @"select * from ZPROPERTY";
    NSString *sql2 = @"insert into ZPROPERTY(Z_PK,Z_ENT,Z_OPT,ZPROPERTY,ZPROPERTYVALUE) values(?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger Z_PK = [rs intForColumn:@"Z_PK"];
        NSInteger Z_ENT = [rs intForColumn:@"Z_ENT"];
        NSInteger Z_OPT = [rs intForColumn:@"Z_OPT"];
        NSString *ZPROPERTY = [rs stringForColumn:@"ZPROPERTY"];
        NSData *ZPROPERTYVALUE = [rs dataForColumn:@"ZPROPERTYVALUE"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:Z_PK],[NSNumber numberWithInt:Z_ENT],[NSNumber numberWithInt:Z_OPT],ZPROPERTY,ZPROPERTYVALUE];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Note table ZPROPERTY exit"];
}

//表ZSTORE
- (void)insertZSTORE
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Note table ZSTORE enter"];
    NSString *sql1 = @"select * from ZSTORE";
    NSString *sql2 = @"insert into ZSTORE(Z_PK,Z_ENT,Z_OPT,ZACCOUNT,ZEXTERNALIDENTIFIER,ZNAME,ZSYNCANCHOR) values(?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger Z_PK = [rs intForColumn:@"Z_PK"];
        NSInteger Z_ENT = [rs intForColumn:@"Z_ENT"];
        NSInteger Z_OPT = [rs intForColumn:@"Z_OPT"];
        NSInteger ZACCOUNT = [rs intForColumn:@"ZACCOUNT"];
        NSString *ZEXTERNALIDENTIFIER = [rs stringForColumn:@"ZEXTERNALIDENTIFIER"];
        NSString *ZNAME = [rs stringForColumn:@"ZNAME"];
        NSString *ZSYNCANCHOR = [rs stringForColumn:@"ZSYNCANCHOR"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:Z_PK],[NSNumber numberWithInt:Z_ENT],[NSNumber numberWithInt:Z_OPT],[NSNumber numberWithInt:ZACCOUNT],ZEXTERNALIDENTIFIER,ZNAME,ZSYNCANCHOR];
    }
    [rs close];
     [_logHandle writeInfoLog:@"insert Note table ZSTORE exit"];
}

//表Z_METADATA
- (void)insertZ_METADATA
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Note table Z_METADATA enter"];
    NSString *sql1 = @"select * from Z_METADATA";
    NSString *sql2 = @"insert into Z_METADATA(Z_VERSION,Z_UUID,Z_PLIST) values(?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger Z_VERSION = [rs intForColumn:@"Z_VERSION"];
        NSString *Z_UUID = [rs stringForColumn:@"Z_UUID"];
        NSData *Z_PLIST = [rs dataForColumn:@"Z_PLIST"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:Z_VERSION],Z_UUID,Z_PLIST];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Note table Z_METADATA exit"];
}

//表Z_METADATA
- (void)insertZ_PRIMARYKEY
{
    //face_time_data
     [_logHandle writeInfoLog:@"insert Note table Z_PRIMARYKEY enter"];
    NSString *sql1 = @"select * from Z_PRIMARYKEY";
    NSString *sql2 = @"insert into Z_PRIMARYKEY(Z_ENT,Z_NAME,Z_SUPER,Z_MAX) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger Z_ENT = [rs intForColumn:@"Z_ENT"];
        NSString *Z_NAME = [rs stringForColumn:@"Z_NAME"];
        NSInteger Z_SUPER = [rs intForColumn:@"Z_SUPER"];
        NSInteger Z_MAX = [rs intForColumn:@"Z_MAX"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:Z_ENT],Z_NAME,[NSNumber numberWithInt:Z_SUPER],[NSNumber numberWithInt:Z_MAX]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Note table Z_PRIMARYKEY exit"];

}
@end

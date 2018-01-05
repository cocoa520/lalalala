//
//  IMBiTunesPrefs.m
//  iMobieTrans
//
//  Created by Pallas on 10/20/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBiTunesPrefs.h"
#import "IMBSession.h"
#import "IMBFileSystem.h"
#import "IMBBigEndianBitConverter.h"
#import "TempHelper.h"

@implementation IMBiTunesPrefs
@synthesize iPodSetUp = _iPodSetUp;
@synthesize openiTunesWhenAttach = _openiTunesWhenAttach;
@synthesize manualSyncFlag = _manualSyncFlag;
@synthesize syncType = _syncType;
@synthesize enableDiskUse = _enableDiskUse;
@synthesize updateChecked = _updateChecked;
@synthesize showArtwork = _showArtwork;
@synthesize synchronizePhotos = _synchronizePhotos;
@synthesize storeHiresPhotosOniPod = _storeHiresPhotosOniPod;
@synthesize transcode = _transcode;
@synthesize keepiPodInTheSourceList = _keepiPodInTheSourceList;
@synthesize selectedPodcastSyncOnly = _selectedPodcastSyncOnly;
@synthesize manualPodcastSync = _manualPodcastSync;

- (id)initWithiPod:(IMBiPod*)ipod {
    if (self = [super init]) {
        _iPod = [ipod retain];
        fm = [NSFileManager defaultManager];
        remoteiTunesPrefsPath = [[_iPod.fileSystem iPodControlPath] stringByAppendingPathComponent:@"iTunes/iTunesPrefs"];
        localiTunesPrefsPath = [[[_iPod.session sessionFolderPath] stringByAppendingPathComponent:@"iTunesPrefs"] retain];
        [self readiTunesPrefs];
    }
    return self;
}

- (void)dealloc {
    if (_iPod != nil) {
        [_iPod release];
        _iPod = nil;
    }
    if (localiTunesPrefsPath != nil) {
        [localiTunesPrefsPath release];
        localiTunesPrefsPath = nil;
    }
    if (_headerIdentifier != nil) {
        [_headerIdentifier release];
        _headerIdentifier = nil;
    }
    if (_unk1 != nil) {
        [_unk1 release];
        _unk1 = nil;
    }
    if (_unk2 != nil) {
        [_unk2 release];
        _unk2 = nil;
    }
    if (_iPodSetUpByte != nil) {
        [_iPodSetUpByte release];
        _iPodSetUpByte = nil;
    }
    if (_openiTunesWhenAttachByte != nil) {
        [_openiTunesWhenAttachByte release];
        _openiTunesWhenAttachByte = nil;
    }
    if (_manualAutomaticSyncFlagByte != nil) {
        [_manualAutomaticSyncFlagByte release];
        _manualAutomaticSyncFlagByte = nil;
    }
    if (_syncTypeByte != nil) {
        [_syncTypeByte release];
        _syncTypeByte = nil;
    }
    if (_iTunesMusicLibraryLinkIdentifier != nil) {
        [_iTunesMusicLibraryLinkIdentifier release];
        _iTunesMusicLibraryLinkIdentifier = nil;
    }
    if (_unk3 != nil) {
        [_unk3 release];
        _unk3 = nil;
    }
    if (_unk4 != nil) {
        [_unk4 release];
        _unk4 = nil;
    }
    if (_unk5 != nil) {
        [_unk5 release];
        _unk5 = nil;
    }
    if (_unk6 != nil) {
        [_unk6 release];
        _unk6 = nil;
    }
    if (_unk7 != nil) {
        [_unk7 release];
        _unk7 = nil;
    }
    if (_enableDiskUseByte != nil) {
        [_enableDiskUseByte release];
        _enableDiskUseByte = nil;
    }
    if (_unk8 != nil) {
        [_unk8 release];
        _unk8 = nil;
    }
    if (_unk9 != nil) {
        [_unk9 release];
        _unk9 = nil;
    }
    if (_updateCheckedByte != nil) {
        [_updateCheckedByte release];
        _updateCheckedByte = nil;
    }
    if (_unk10 != nil) {
        [_unk10 release];
        _unk10 = nil;
    }
    if (_unk11 != nil) {
        [_unk11 release];
        _unk11 = nil;
    }
    if (_padding1 != nil) {
        [_padding1 release];
        _padding1 = nil;
    }
    if (_showArtworkByte != nil) {
        [_showArtworkByte release];
        _showArtworkByte = nil;
    }
    if (_padding2 != nil) {
        [_padding2 release];
        _padding2 = nil;
    }
    if (_synchronizePhotosByte != nil) {
        [_synchronizePhotosByte release];
        _synchronizePhotosByte = nil;
    }
    if (_unk12 != nil) {
        [_unk12 release];
        _unk12 = nil;
    }
    if (_storeHiresPhotosOniPodByte != nil) {
        [_storeHiresPhotosOniPodByte release];
        _storeHiresPhotosOniPodByte = nil;
    }
    if (_padding3 != nil) {
        [_padding3 release];
        _padding3 = nil;
    }
    if (_transcodeByte != nil) {
        [_transcodeByte release];
        _transcodeByte = nil;
    }
    if (_keepiPodInTheSourceListByte != nil) {
        [_keepiPodInTheSourceListByte release];
        _keepiPodInTheSourceListByte = nil;
    }
    if (_unk13 != nil) {
        [_unk13 release];
        _unk13 = nil;
    }
    if (_selectedPodcastSyncOnlyByte != nil) {
        [_selectedPodcastSyncOnlyByte release];
        _selectedPodcastSyncOnlyByte = nil;
    }
    if (_manualAutomaticPodcastSyncByte != nil) {
        [_manualAutomaticPodcastSyncByte release];
        _manualAutomaticPodcastSyncByte = nil;
    }
    if (_unk14 != nil) {
        [_unk14 release];
        _unk14 = nil;
    }
    if (_identifier != nil) {
        [_identifier release];
        _identifier = nil;
    }
    if (_songsOniPod != nil) {
        [_songsOniPod release];
        _songsOniPod = nil;
    }
    if (_padding4 != nil) {
        [_padding4 release];
        _padding4 = nil;
    }
    if (_doNotAskAgainFlags != nil) {
        [_doNotAskAgainFlags release];
        _doNotAskAgainFlags = nil;
    }
    if (_padding5 != nil) {
        [_padding5 release];
        _padding5 = nil;
    }
    if (_soundCheck != nil) {
        [_soundCheck release];
        _soundCheck = nil;
    }
    if (_padding6 != nil) {
        [_padding6 release];
        _padding6 = nil;
    }
    [super dealloc];
}

- (BOOL)refreshiTunesPrefs {
    return [self readiTunesPrefs];
}

- (BOOL)readiTunesPrefs {
    BOOL retVal = YES;
    if (_iPod != nil) {
        if ([_iPod.fileSystem fileExistsAtPath:remoteiTunesPrefsPath]) {
            if ([fm fileExistsAtPath:localiTunesPrefsPath]) {
                [fm removeItemAtPath:localiTunesPrefsPath error:nil];
            }
            [_iPod.fileSystem copyRemoteFile:remoteiTunesPrefsPath toLocalFile:localiTunesPrefsPath];
        }
    }
    
    if ([fm fileExistsAtPath:localiTunesPrefsPath]) {
        _fHandle = [[NSFileHandle fileHandleForReadingAtPath:localiTunesPrefsPath] retain];
    } else {
        _fHandle = nil;
        return NO;
    }
    if (_fHandle != nil) {
        int64_t fileLength = [_fHandle seekToEndOfFile];
        int64_t remainingLen = fileLength;
        [_fHandle seekToFileOffset:0];
        if (remainingLen <= 4) {
            goto endlable;
        }
        _headerIdentifier = [[_fHandle readDataOfLength:4] retain];
        remainingLen -= 4;
        if (![self validateHeader:@"frpd"]) {
            goto endlable;
        }
        if (remainingLen < 2) {
            goto endlable;
        }
        _unk1 = [[_fHandle readDataOfLength:2] retain];
        remainingLen -= 2;
        if (remainingLen < 2) {
            goto endlable;
        }
        _unk2 = [[_fHandle readDataOfLength:2] retain];
        remainingLen -= 2;
        if (remainingLen < 1) {
            goto endlable;
        }
        _iPodSetUpByte = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (_iPodSetUpByte != nil && _iPodSetUpByte.length > 0) {
            Byte b = ((Byte*)_iPodSetUpByte.bytes)[0];
            if (b == 0x00) {
                [self setIPodSetUp:NO];
            } else {
                [self setIPodSetUp:YES];
            }
        }
        if (remainingLen < 1) {
            goto endlable;
        }
        _openiTunesWhenAttachByte = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (_openiTunesWhenAttachByte != nil && _openiTunesWhenAttachByte.length > 0) {
            Byte b = ((Byte*)_openiTunesWhenAttachByte.bytes)[0];
            if (b == 0x00) {
                [self setOpeniTunesWhenAttach:NO];
            } else {
                [self setOpeniTunesWhenAttach:YES];
            }
        }
        if (remainingLen < 1) {
            goto endlable;
        }
        _manualAutomaticSyncFlagByte = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (_manualAutomaticSyncFlagByte != nil && _manualAutomaticSyncFlagByte.length > 0) {
            Byte b = ((Byte*)_manualAutomaticSyncFlagByte.bytes)[0];
            if (b == 0x00) {
                [self setManualSyncFlag:YES];
            } else {
                [self setManualSyncFlag:NO];
            }
        }
        if (remainingLen < 1) {
            goto endlable;
        }
        _syncTypeByte = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (_syncTypeByte != nil && _syncTypeByte.length > 0) {
            Byte *b = ((Byte*)_syncTypeByte.bytes)[0];
            [self setSyncType:(int)b];
        }
        if (remainingLen < 8) {
            goto endlable;
        }
        _iTunesMusicLibraryLinkIdentifier = [[_fHandle readDataOfLength:8] retain];
        remainingLen -= 8;
        if (remainingLen < 4) {
            goto endlable;
        }
        _unk3 = [[_fHandle readDataOfLength:4] retain];
        remainingLen -= 4;
        if (remainingLen < 4) {
            goto endlable;
        }
        _unk4 = [[_fHandle readDataOfLength:4] retain];
        remainingLen -= 4;
        if (remainingLen < 1) {
            goto endlable;
        }
        _unk5 = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (remainingLen < 1) {
            goto endlable;
        }
        _unk6 = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (remainingLen < 1) {
            goto endlable;
        }
        _unk7 = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (remainingLen < 1) {
            goto endlable;
        }
        _enableDiskUseByte = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (_enableDiskUseByte != nil && _enableDiskUseByte.length > 0) {
            Byte b = ((Byte*)_enableDiskUseByte.bytes)[0];
            if (b == 0x00) {
                [self setEnableDiskUse:NO];
            } else {
                [self setEnableDiskUse:YES];
            }
        }
        if (remainingLen < 1) {
            goto endlable;
        }
        _unk8 = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (remainingLen < 1) {
            goto endlable;
        }
        _unk9 = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (remainingLen < 1) {
            goto endlable;
        }
        _updateCheckedByte = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (_updateCheckedByte != nil && _updateCheckedByte.length > 0) {
            Byte b = ((Byte*)_updateCheckedByte.bytes)[0];
            if (b == 0x00) {
                [self setUpdateChecked:NO];
            } else {
                [self setUpdateChecked:YES];
            }
        }
        if (remainingLen < 1) {
            goto endlable;
        }
        _unk10 = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (remainingLen < 1) {
            goto endlable;
        }
        _unk11 = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (remainingLen < 12) {
            goto endlable;
        }
        _padding1 = [[_fHandle readDataOfLength:12] retain];
        remainingLen -= 12;
        if (remainingLen < 1) {
            goto endlable;
        }
        _showArtworkByte = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (_showArtworkByte != nil && _showArtworkByte.length > 0) {
            Byte b = ((Byte*)_showArtworkByte.bytes)[0];
            if (b == 0x00) {
                [self setShowArtwork:NO];
            } else {
                [self setShowArtwork:YES];
            }
        }
        if (remainingLen < 2) {
            goto endlable;
        }
        _padding2 = [[_fHandle readDataOfLength:2] retain];
        remainingLen -= 2;
        if (remainingLen < 1) {
            goto endlable;
        }
        _synchronizePhotosByte = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (_synchronizePhotosByte != nil && _synchronizePhotosByte.length > 0) {
            Byte b = ((Byte*)_synchronizePhotosByte.bytes)[0];
            if (b == 0x00) {
                [self setSynchronizePhotos:NO];
            } else {
                [self setSynchronizePhotos:YES];
            }
        }
        if (remainingLen < 2) {
            goto endlable;
        }
        _unk12 = [[_fHandle readDataOfLength:2] retain];
        remainingLen -= 2;
        if (remainingLen < 1) {
            goto endlable;
        }
        _storeHiresPhotosOniPodByte = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (_storeHiresPhotosOniPodByte != nil && _storeHiresPhotosOniPodByte.length > 0) {
            Byte b = ((Byte*)_storeHiresPhotosOniPodByte.bytes)[0];
            if (b == 0x00) {
                [self setSynchronizePhotos:NO];
            } else {
                [self setSynchronizePhotos:YES];
            }
        }
        if (remainingLen < 16) {
            goto endlable;
        }
        _padding3 = [[_fHandle readDataOfLength:16] retain];
        remainingLen -= 16;
        if (remainingLen < 1) {
            goto endlable;
        }
        _transcodeByte = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (_transcodeByte != nil && _transcodeByte.length > 0) {
            Byte b = ((Byte*)_transcodeByte.bytes)[0];
            if (b == 0x00) {
                [self setTranscode:NO];
            } else {
                [self setTranscode:YES];
            }
        }
        if (remainingLen < 1) {
            goto endlable;
        }
        _keepiPodInTheSourceListByte = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (_keepiPodInTheSourceListByte != nil && _keepiPodInTheSourceListByte.length > 0) {
            Byte b = ((Byte*)_keepiPodInTheSourceListByte.bytes)[0];
            if (b == 0x00) {
                [self setKeepiPodInTheSourceList:NO];
            } else {
                [self setKeepiPodInTheSourceList:YES];
            }
        }
        if (remainingLen < 15) {
            goto endlable;
        }
        _unk13 = [[_fHandle readDataOfLength:15] retain];
        remainingLen -= 15;
        if (remainingLen < 1) {
            goto endlable;
        }
        _selectedPodcastSyncOnlyByte = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (_selectedPodcastSyncOnlyByte != nil && _selectedPodcastSyncOnlyByte.length > 0) {
            Byte b = ((Byte*)_selectedPodcastSyncOnlyByte.bytes)[0];
            [self setSelectedPodcastSyncOnly:(int)b];
        }
        if (remainingLen < 1) {
            goto endlable;
        }
        _manualAutomaticPodcastSyncByte = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (_manualAutomaticPodcastSyncByte != nil && _manualAutomaticPodcastSyncByte.length > 0) {
            Byte b = ((Byte*)_manualAutomaticPodcastSyncByte.bytes)[0];
            if (b == 0x00) {
                [self setManualPodcastSync:NO];
            } else {
                [self setManualPodcastSync:YES];
            }
        }
        if (remainingLen < 5) {
            goto endlable;
        }
        _unk14 = [[_fHandle readDataOfLength:5] retain];
        remainingLen -= 5;
        if (remainingLen < 8) {
            goto endlable;
        }
        _identifier = [[_fHandle readDataOfLength:8] retain];
        remainingLen -= 8;
        if (remainingLen < 2) {
            goto endlable;
        }
        _songsOniPod = [[_fHandle readDataOfLength:2] retain];
        remainingLen -= 2;
        if (remainingLen <2) {
            goto endlable;
        }
        _filespaceSavedOniPod = [[_fHandle readDataOfLength:2] retain];
        remainingLen -= 2;
        if (remainingLen < 8) {
            goto endlable;
        }
        _padding4 = [[_fHandle readDataOfLength:8] retain];
        remainingLen -= 8;
        if (remainingLen < 4) {
            goto endlable;
        }
        _doNotAskAgainFlags = [[_fHandle readDataOfLength:4] retain];
        remainingLen -= 4;
        if (remainingLen < 4) {
            goto endlable;
        }
        _padding5 = [[_fHandle readDataOfLength:4] retain];
        remainingLen -= 4;
        if (remainingLen < 1) {
            goto endlable;
        }
        _soundCheck = [[_fHandle readDataOfLength:1] retain];
        remainingLen -= 1;
        if (remainingLen <= 0) {
            goto endlable;
        }
        _padding6 = [[_fHandle readDataOfLength:(int)remainingLen] retain];
        remainingLen -= remainingLen;
    endlable:;
        [_fHandle closeFile];
        [_fHandle release];
        _fHandle = nil;
    } else {
        NSLog(@"iTunesPrefs open failed!");
        retVal = NO;
    }

    return retVal;
}

- (BOOL)saveiTunesPrefs {
    BOOL retVal = YES;
    NSString *tmpiTunesPrefsPath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"iTunesPrefs"];
    tmpiTunesPrefsPath = [TempHelper getFilePathAlias:tmpiTunesPrefsPath];
    [fm createFileAtPath:tmpiTunesPrefsPath contents:nil attributes:nil];
    if ([fm fileExistsAtPath:tmpiTunesPrefsPath]) {
        if ([fm fileExistsAtPath:localiTunesPrefsPath]) {
            _fHandle = [[NSFileHandle fileHandleForWritingAtPath:localiTunesPrefsPath] retain];
        } else {
            _fHandle = nil;
            return NO;
        }
        if (_fHandle != nil) {
            if (_headerIdentifier != nil && _headerIdentifier.length > 0) {
                [_fHandle writeData:_headerIdentifier];
            }
            if (_unk1 != nil && _unk1.length > 0) {
               [_fHandle writeData:_unk1];
            }
            if (_unk2 != nil && _unk2.length > 0) {
                [_fHandle writeData:_unk2];
            }
            if (_iPodSetUpByte != nil && _iPodSetUpByte.length > 0) {
                [_fHandle writeData:_iPodSetUpByte];
            }
            if (_openiTunesWhenAttachByte != nil && _openiTunesWhenAttachByte.length > 0) {
                [_fHandle writeData:_openiTunesWhenAttachByte];
            }
            if (_manualAutomaticSyncFlagByte != nil && _manualAutomaticSyncFlagByte.length > 0) {
                [_fHandle writeData:_manualAutomaticSyncFlagByte];
            }
            if (_syncTypeByte != nil && _syncTypeByte.length > 0) {
                [_fHandle writeData:_syncTypeByte];
            }
            if (_iTunesMusicLibraryLinkIdentifier != nil && _iTunesMusicLibraryLinkIdentifier.length > 0) {
                [_fHandle writeData:_iTunesMusicLibraryLinkIdentifier];
            }
            if (_unk3 != nil && _unk3.length > 0) {
                [_fHandle writeData:_unk3];
            }
            if (_unk4 != nil && _unk4.length > 0) {
                [_fHandle writeData:_unk4];
            }
            if (_unk5 != nil && _unk5.length > 0) {
                [_fHandle writeData:_unk5];
            }
            if (_unk6 != nil && _unk6.length > 0) {
                [_fHandle writeData:_unk6];
            }
            if (_unk7 != nil && _unk7.length > 0) {
                [_fHandle writeData:_unk7];
            }
            if (_enableDiskUseByte != nil && _enableDiskUseByte.length > 0) {
                [_fHandle writeData:_enableDiskUseByte];
            }
            if (_unk8 != nil && _unk8.length > 0) {
                [_fHandle writeData:_unk8];
            }
            if (_unk9 != nil && _unk9.length > 0) {
                [_fHandle writeData:_unk9];
            }
            if (_updateCheckedByte != nil && _updateCheckedByte.length > 0) {
                [_fHandle writeData:_updateCheckedByte];
            }
            if (_unk10 != nil && _unk10.length > 0) {
                [_fHandle writeData:_unk10];
            }
            if (_unk11 != nil && _unk11.length > 0) {
                [_fHandle writeData:_unk11];
            }
            if (_padding1 != nil && _padding1.length > 0) {
                [_fHandle writeData:_padding1];
            }
            if (_showArtworkByte != nil && _showArtworkByte.length > 0) {
                [_fHandle writeData:_showArtworkByte];
            }
            if (_padding2 != nil && _padding2.length > 0) {
                [_fHandle writeData:_padding2];
            }
            if (_synchronizePhotosByte != nil && _synchronizePhotosByte.length > 0) {
                [_fHandle writeData:_synchronizePhotosByte];
            }
            if (_unk12 != nil && _unk12.length > 0) {
                [_fHandle writeData:_unk12];
            }
            if (_storeHiresPhotosOniPodByte != nil && _storeHiresPhotosOniPodByte.length > 0) {
                [_fHandle writeData:_storeHiresPhotosOniPodByte];
            }
            if (_padding3 != nil && _padding3.length > 0) {
                [_fHandle writeData:_padding3];
            }
            if (_transcodeByte != nil && _transcodeByte.length > 0) {
                [_fHandle writeData:_transcodeByte];
            }
            if (_keepiPodInTheSourceListByte != nil && _keepiPodInTheSourceListByte.length > 0) {
                [_fHandle writeData:_keepiPodInTheSourceListByte];
            }
            if (_unk13 != nil && _unk13.length > 0) {
                [_fHandle writeData:_unk13];
            }
            if (_selectedPodcastSyncOnlyByte != nil && _selectedPodcastSyncOnlyByte.length > 0) {
                [_fHandle writeData:_selectedPodcastSyncOnlyByte];
            }
            if (_manualAutomaticPodcastSyncByte != nil && _manualAutomaticPodcastSyncByte.length > 0) {
                [_fHandle writeData:_manualAutomaticPodcastSyncByte];
            }
            if (_unk14 != nil && _unk14.length > 0) {
                [_fHandle writeData:_unk14];
            }
            if (_identifier != nil && _identifier.length > 0) {
                [_fHandle writeData:_identifier];
            }
            if (_songsOniPod != nil && _songsOniPod.length > 0) {
                [_fHandle writeData:_songsOniPod];
            }
            if (_filespaceSavedOniPod != nil && _filespaceSavedOniPod.length > 0) {
                [_fHandle writeData:_filespaceSavedOniPod];
            }
            if (_padding4 != nil && _padding4.length > 0) {
                [_fHandle writeData:_padding4];
            }
            if (_doNotAskAgainFlags != nil && _doNotAskAgainFlags.length > 0) {
                [_fHandle writeData:_doNotAskAgainFlags];
            }
            if (_padding5 != nil && _padding5.length > 0) {
                [_fHandle writeData:_padding5];
            }
            if (_soundCheck != nil && _soundCheck.length > 0) {
                [_fHandle writeData:_soundCheck];
            }
            if (_padding6 != nil && _padding6.length > 0) {
                [_fHandle writeData:_padding6];
            }
            [_fHandle closeFile];
            [_fHandle release];
            _fHandle = nil;
            if ([_iPod.fileSystem fileExistsAtPath:remoteiTunesPrefsPath]) {
                [_iPod.fileSystem unlink:remoteiTunesPrefsPath];
            }
            [_iPod.fileSystem copyLocalFile:tmpiTunesPrefsPath toRemoteFile:remoteiTunesPrefsPath];
        } else {
            retVal = NO;
        }
    } else {
        retVal = NO;
    }
    return retVal;
}

-(BOOL)validateHeader:(NSString *)validIdentifier{
    BOOL retVal = NO;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSString* strIndentfier = [[NSString alloc] initWithData:_headerIdentifier encoding:enc];
    if ([strIndentfier isEqualToString:validIdentifier] == NO) {
        retVal = NO;
    } else {
        retVal = YES;
    }
    [strIndentfier release];
    return retVal;
}

- (void)setIPodSetUp:(BOOL)iPodSetUp {
    if (iPodSetUp != _iPodSetUp) {
        _iPodSetUp = iPodSetUp;
    }
    if (_iPodSetUpByte != nil) {
        [_iPodSetUpByte release];
        _iPodSetUpByte = nil;
    }
    if (_iPodSetUp == YES) {
        Byte b[] = { 0x01 };
        _iPodSetUpByte = [[NSData dataWithBytes:b length:1] retain];
    } else {
        Byte b[] = { 0x00 };
        _iPodSetUpByte = [[NSData dataWithBytes:b length:1] retain];
    }
}

- (BOOL)iPodSetUp {
    return _iPodSetUp;
}

- (void)setOpeniTunesWhenAttach:(BOOL)openiTunesWhenAttach {
    if (openiTunesWhenAttach != _openiTunesWhenAttach) {
        _openiTunesWhenAttach = openiTunesWhenAttach;
    }
    if (_openiTunesWhenAttachByte != nil) {
        [_openiTunesWhenAttachByte release];
        _openiTunesWhenAttachByte = nil;
    }
    if (_openiTunesWhenAttach == YES) {
        Byte b[] = { 0x01 };
        _openiTunesWhenAttachByte = [[NSData dataWithBytes:b length:1] retain];
    } else {
        Byte b[] = { 0x00 };
        _openiTunesWhenAttachByte = [[NSData dataWithBytes:b length:1] retain];
    }
}

- (BOOL)openiTunesWhenAttach {
    return _openiTunesWhenAttach;
}

- (void)setManualSyncFlag:(BOOL)manualSyncFlag {
    if (manualSyncFlag != _manualSyncFlag) {
        _manualSyncFlag = manualSyncFlag;
    }
    if (_manualAutomaticSyncFlagByte != nil) {
        [_manualAutomaticSyncFlagByte release];
        _manualAutomaticSyncFlagByte = nil;
    }
    if (_manualSyncFlag == YES) {
        Byte b[] = { 0x00 };
        _manualAutomaticSyncFlagByte = [[NSData dataWithBytes:b length:1] retain];
    } else {
        Byte b[] = { 0x01 };
        _manualAutomaticSyncFlagByte = [[NSData dataWithBytes:b length:1] retain];
    }
}

- (BOOL)manualSyncFlag {
    return _manualSyncFlag;
}

- (void)setSyncType:(int)syncType {
    if (syncType != _syncType) {
        if (syncType >= 2) {
            _syncType = 2;
        } else {
            _syncType = 1;
        }
    }
    if (_syncTypeByte != nil) {
        [_syncTypeByte release];
        _syncTypeByte = nil;
    }
    Byte b[] = { (Byte)_syncType };
    _syncTypeByte = [[NSData dataWithBytes:b length:1] retain];
}

- (int)syncType {
    return (int)_syncTypeByte;
}

- (void)setEnableDiskUse:(BOOL)enableDiskUse {
    if (enableDiskUse != _enableDiskUse) {
        _enableDiskUse = enableDiskUse;
    }
    if (_enableDiskUseByte != nil) {
        [_enableDiskUseByte release];
        _enableDiskUseByte = nil;
    }
    if (_enableDiskUse == YES) {
        Byte b[] = { 0x01 };
        _enableDiskUseByte = [[NSData dataWithBytes:b length:1] retain];
    } else {
        Byte b[] = { 0x00 };
        _enableDiskUseByte = [[NSData dataWithBytes:b length:1] retain];
    }
}

- (BOOL)enableDiskUse {
    return _enableDiskUse;
}

- (void)setUpdateChecked:(BOOL)updateChecked {
    if (updateChecked != _updateChecked) {
        _updateChecked = updateChecked;
    }
    if (_updateCheckedByte != nil) {
        [_updateCheckedByte release];
        _updateCheckedByte = nil;
    }
    if (_updateChecked == YES) {
        Byte b[] = { 0x01 };
        _updateCheckedByte = [[NSData dataWithBytes:b length:1] retain];
    } else {
        Byte b[] = { 0x00 };
        _updateCheckedByte = [[NSData dataWithBytes:b length:1] retain];
    }
}

- (BOOL)updateChecked {
    return _updateChecked;
}

- (void)setShowArtwork:(BOOL)showArtwork {
    if (showArtwork != _showArtwork) {
        _showArtwork = showArtwork;
    }
    if (_showArtworkByte != nil) {
        [_showArtworkByte release];
        _showArtworkByte = nil;
    }
    if (_showArtwork == YES) {
        Byte b[] = { 0x01 };
        _showArtworkByte = [[NSData dataWithBytes:b length:1] retain];
    } else {
        Byte b[] = { 0x00 };
        _showArtworkByte = [[NSData dataWithBytes:b length:1] retain];
    }
}

- (BOOL)showArtwork {
    return _showArtwork;
}

- (void)setSynchronizePhotos:(BOOL)synchronizePhotos {
    if (synchronizePhotos != _synchronizePhotos) {
        _synchronizePhotos = synchronizePhotos;
    }
    if (_synchronizePhotosByte != nil) {
        [_synchronizePhotosByte release];
        _synchronizePhotosByte = nil;
    }
    if (_synchronizePhotos == YES) {
        Byte b[] = { 0x01 };
        _synchronizePhotosByte = [[NSData dataWithBytes:b length:1] retain];
    } else {
        Byte b[] = { 0x00 };
        _synchronizePhotosByte = [[NSData dataWithBytes:b length:1] retain];
    }
}

- (BOOL)synchronizePhotos {
    return _synchronizePhotos;
}

- (void)setStoreHiresPhotosOniPod:(BOOL)storeHiresPhotosOniPod {
    if (storeHiresPhotosOniPod != _storeHiresPhotosOniPod) {
        _storeHiresPhotosOniPod = storeHiresPhotosOniPod;
    }
    if (_storeHiresPhotosOniPodByte != nil) {
        [_storeHiresPhotosOniPodByte release];
        _storeHiresPhotosOniPodByte = nil;
    }
    if (_storeHiresPhotosOniPod == YES) {
        Byte b[] = { 0x01 };
        _storeHiresPhotosOniPodByte = [[NSData dataWithBytes:b length:1] retain];
    } else {
        Byte b[] = { 0x00 };
        _storeHiresPhotosOniPodByte = [[NSData dataWithBytes:b length:1] retain];
    }
}

- (BOOL)storeHiresPhotosOniPod {
    return _storeHiresPhotosOniPod;
}

- (void)setTranscode:(BOOL)transcode {
    if (transcode != _transcode) {
        _transcode = transcode;
    }
    if (_transcodeByte != nil) {
        [_transcodeByte release];
        _transcodeByte = nil;
    }
    if (_transcode == YES) {
        Byte b[] = { 0x01 };
        _transcodeByte = [[NSData dataWithBytes:b length:1] retain];
    } else {
        Byte b[] = { 0x00 };
        _transcodeByte = [[NSData dataWithBytes:b length:1] retain];
    }
}

- (BOOL)transcode {
    return _transcode;
}

- (void)setKeepiPodInTheSourceList:(BOOL)keepiPodInTheSourceList {
    if (keepiPodInTheSourceList != _keepiPodInTheSourceList) {
        _keepiPodInTheSourceList = keepiPodInTheSourceList;
    }
    if (_keepiPodInTheSourceListByte != nil) {
        [_keepiPodInTheSourceListByte release];
        _keepiPodInTheSourceListByte = nil;
    }
    if (_keepiPodInTheSourceList == YES) {
        Byte b[] = { 0x01 };
        _keepiPodInTheSourceListByte = [[NSData dataWithBytes:b length:1] retain];
    } else {
        Byte b[] = { 0x00 };
        _keepiPodInTheSourceListByte = [[NSData dataWithBytes:b length:1] retain];
    }
}

- (BOOL)keepiPodInTheSourceList {
    return _keepiPodInTheSourceList;
}

- (void)setSelectedPodcastSyncOnly:(int)selectedPodcastSyncOnly {
    if (selectedPodcastSyncOnly != _selectedPodcastSyncOnly) {
        if (selectedPodcastSyncOnly >= 2) {
            _selectedPodcastSyncOnly = 2;
        } else {
            _selectedPodcastSyncOnly = 1;
        }
    }
    if (_selectedPodcastSyncOnlyByte != nil) {
        [_selectedPodcastSyncOnlyByte release];
        _selectedPodcastSyncOnlyByte = nil;
    }
    Byte b[] = { (Byte)_selectedPodcastSyncOnly };
    _selectedPodcastSyncOnlyByte = [[NSData dataWithBytes:b length:1] retain];
}

- (int)selectedPodcastSyncOnly {
    return (int)_selectedPodcastSyncOnlyByte;
}

- (void)setManualPodcastSync:(BOOL)manualPodcastSync {
    if (manualPodcastSync != _manualPodcastSync) {
        _manualPodcastSync = manualPodcastSync;
    }
    if (_manualAutomaticPodcastSyncByte != nil) {
        [_manualAutomaticPodcastSyncByte release];
        _manualAutomaticPodcastSyncByte = nil;
    }
    
    if (_manualPodcastSync == YES) {
        Byte b[] = { 0x01 };
        _manualAutomaticPodcastSyncByte = [[NSData dataWithBytes:b length:1] retain];
    } else {
        Byte b[] = { 0x00 };
        _manualAutomaticPodcastSyncByte = [[NSData dataWithBytes:b length:1] retain];
    }
}

- (BOOL)manualPodcastSync {
    return _manualPodcastSync;
}

@end

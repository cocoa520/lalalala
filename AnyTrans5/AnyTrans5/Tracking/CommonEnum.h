//
//  CommonEnum.h
//  AnyTransTrack
//
//  Created by JGehry on 10/13/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#ifndef AnyTransTrack_CommonEnum_h
#define AnyTransTrack_CommonEnum_h

//事件类别
typedef enum CategoryEnum {
    iTunes_Library,
    iTunes_Backup,
    Air_Backup,
    iCloud_Content,
    Device_Content,
    Move_To_iOS,
    Android_Connect,
    Video_Download,
    Skin_Theme,
    AnyTrans_Activation,
    AnyTrans_OpenOrClose,
    Merge_Device,
    Content_To_iTunes,
    Content_To_Computer,
    Fast_Drive,
    Content_To_Device,
    Add_Content,
    Clone_Device,
    Device_toiCloud,
    None
}EventCategory;

//事件操作
typedef enum ActionEnum {
    ToDevice,
    ToiTunes,
    Import,
    Delete,
    ContentToMac,
//    AddContent,
    SkinApply,
    Analyze,
    Automatic_Download,
    Manual_Download,
    ReDownload,
    Remove,
    Find,
    CleanList,
    Automatic_Import,
    Manual_Import,
    Analyze_Success,
    Analyze_Error,
    Download_Error,
    Download_Success,
    Stop_Analysis,
    Stop_Download,
    Stop_Transfer,
    iCloud_Drive,
    iCloud_Backup,
    iCloud_Import,
    iCloud_Export,
    iCloud_Sync,
    Login,
    ToiCloud,
    AirBackup,
    AdAnnoy,
    ActionNone
}EventAction;

//事件标签
typedef enum LabelEnum {
    Open,
    Exit,
    FirstLaunch,
    Buy,
    Register,
    Activate,
    Switch,
    Click,
    Start,
    Finish,
    Stop,
    Error,
    LabelNone
}EventLabel;

typedef enum ScreenEnum {
    Lock_Screen_Removals,
}Screen;

#endif

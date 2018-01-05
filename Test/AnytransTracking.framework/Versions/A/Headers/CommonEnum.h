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
    iCloud_Content,
    Device_Content,
    AnyTrans_Activation,
    CatetoryNone
}EventCategory;

//事件操作
typedef enum ActionEnum {
    ToDevice,
    ToiTunes,
    Import,
    Delete,
    ContentToMac,
    ContentToiTunes,
    AddContent,
    ActionNone
}EventAction;

//事件标签
typedef enum LabelEnum {
    Open,
    Exit,
    Buy,
    Register,
    Switch,
    Click,
    Start,
    Finish,
    Stop,
    Error
}EventLabel;

//主题皮肤颜色
typedef enum ThemeColorEnum {
    Black,
    White,
    AsianBlack
}EventThemeColor;

#endif

/*  Copyright (c) MediaArea.net SARL. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license that can
 *  be found in the License.html file in the root of the source tree.
 */

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Example for MediaInfoLib
// Command line version
//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#include <string>
#include <iostream>
#import "HowToUse.h"
#import "NSData+Base64.h"

#include "ZenLib/Ztring.h" //Note : I need it for universal atoi, but you have not to use it for be able to use MediaInfoLib
#include "MediaInfo/MediaInfo.h"

using namespace MediaInfoLib;
using namespace ZenLib;

#ifdef __MINGW32__
    #ifdef _UNICODE
        #define _itot _itow
    #else //_UNICODE
        #define _itot itoa
    #endif //_UNICODE
#endif //__MINGW32


@implementation HowToUse

- (int) testmain:(int)argc  argv:(char *)argv;
{
    //Information about MediaInfo
    MediaInfo MI;
    
    ZenLib::Ztring To_Display=MI.Option(__T("Info_Version"), __T("0.7.0.0;MediaInfoDLL_Example_MSVC;0.7.0.0")).c_str();
    
    To_Display += __T("\r\n\r\nInfo_Parameters\r\n");
    To_Display += MI.Option(__T("Info_Parameters")).c_str();
    
    To_Display += __T("\r\n\r\nInfo_Capacities\r\n");
    To_Display += MI.Option(__T("Info_Capacities")).c_str();
    
    To_Display += __T("\r\n\r\nInfo_Codecs\r\n");
    To_Display += MI.Option(__T("Info_Codecs")).c_str();
    
    //An example of how to use the library
    To_Display += __T("\r\n\r\nOpen\r\n");
    
    MI.Open(__T("/Users/iMobie/Documents/cocos2d-x-3.0alpha1/samples/Javascript/Shared/games/CocosDragonJS/Published files HTML5/Music.mp3"));
    
    To_Display += __T("\r\n\r\nInform with Complete=false\r\n");
    MI.Option(__T("Complete"));
    To_Display += MI.Inform().c_str();
    
    To_Display += __T("\r\n\r\nInform with Complete=true\r\n");
    MI.Option(__T("Complete"), __T("1"));
    To_Display += MI.Inform().c_str();
    
    To_Display += __T("\r\n\r\nCustom Inform\r\n");
    MI.Option(__T("Inform"), __T("General;Example : FileSize=%FileSize%"));
    To_Display += MI.Inform().c_str();
    
    To_Display += __T("\r\n\r\nGet with Stream=General and Parameter=\"FileSize\"\r\n");
    To_Display += MI.Get(Stream_General, 0, __T("FileSize"), Info_Text, Info_Name).c_str();
    
    To_Display += __T("\r\n\r\nGetI with Stream=General and Parameter=46\r\n");
    To_Display += MI.Get(Stream_General, 0, 46, Info_Text).c_str();
    
    To_Display += __T("\r\n\r\nCount_Get with StreamKind=Stream_Audio\r\n");
    To_Display += ZenLib::Ztring::ToZtring(MI.Count_Get(Stream_Audio, -1)); //Warning : this is an integer
    
    To_Display += __T("\r\n\r\nGet with Stream=General and Parameter=\"AudioCount\"\r\n");
    To_Display += MI.Get(Stream_General, 0, __T("AudioCount"), Info_Text, Info_Name).c_str();
    
    To_Display += __T("\r\n\r\nGet with Stream=Audio and Parameter=\"StreamCount\"\r\n");
    To_Display += MI.Get(Stream_Audio, 0, __T("StreamCount"), Info_Text, Info_Name).c_str();
    
    To_Display += __T("\r\n\r\nCover_Data\r\n");
    const wchar_t *string = MI.Get(Stream_General, 0, __T("Cover_Data"), Info_Text, Info_Name).c_str(); // returns Blank
    long strLength = wcslen(string) * sizeof(char*);
    NSString *str = [[NSString alloc] initWithBytes:string length:strLength encoding:NSUTF32LittleEndianStringEncoding];
    const wchar_t *suffix = MI.Get(Stream_General, 0, __T("Cover_Mime"), Info_Text, Info_Name).c_str();
    NSString *extention = [[NSString alloc] initWithBytes:suffix length:sizeof(suffix) encoding:NSUTF32LittleEndianStringEncoding];;
    NSData *data = [NSData dataFromBase64String:str];
//    if (extention == nil || extention.length ==0) {
        extention = @"jpg";
//    }
    NSString *path = [NSString stringWithFormat:@"/Users/iMobie/Desktop/123.%@",extention];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:NULL];
    }
    [data writeToFile:[NSString stringWithFormat:@"/Users/iMobie/Desktop/123.%@",extention] atomically:YES];
    To_Display += __T("\r\n\r\nClose\r\n");
    MI.Close();
    
    std::cout<<To_Display.To_Local().c_str()<<std::endl;
    
    return 0;
    
}







//***************************************************************************
// By buffer example
//***************************************************************************
/*
//---------------------------------------------------------------------------
//Note: you can replace file operations by your own buffer management class
#include <stdio.h>
int main (int argc, Char *argv[])
{

    //From: preparing an example file for reading
    FILE* F=fopen("Example.ogg", "rb"); //You can use something else than a file
    if (F==0)
        return 1;

    //From: preparing a memory buffer for reading
    unsigned char* From_Buffer=new unsigned char[7*188]; //Note: you can do your own buffer
    size__T From_Buffer_Size; //The size of the read file buffer

    //From: retrieving file size
    fseek(F, 0, SEEK_END);
    long F_Size=ftell(F);
    fseek(F, 0, SEEK_SET);

    //Initializing MediaInfo
    MediaInfo MI;

    //Preparing to fill MediaInfo with a buffer
    MI.Open_Buffer_Init(F_Size, 0);

    //The parsing loop
    do
    {
        //Reading data somewhere, do what you want for this.
        From_Buffer_Size=fread(From_Buffer, 1, 7*188, F);

        //Sending the buffer to MediaInfo
        size__T Status=MI.Open_Buffer_Continue(From_Buffer, From_Buffer_Size);
        if (Status&0x08) //Bit3=Finished
            break;

        //Testing if there is a MediaInfo request to go elsewhere
        if (MI.Open_Buffer_Continue_GoTo_Get()!=(MediaInfo_int64u)-1)
        {
            fseek(F, (long)MI.Open_Buffer_Continue_GoTo_Get(), SEEK_SET);   //Position the file
            MI.Open_Buffer_Init(F_Size, ftell(F));                          //Informing MediaInfo we have seek
        }
    }
    while (From_Buffer_Size>0);

    //Finalizing
    MI.Open_Buffer_Finalize(); //This is the end of the stream, MediaInfo must finnish some work

    //Get() example
    String To_Display=MI.Get(Stream_General, 0, ___T("Format"));

    #ifdef _UNICODE
        std::wcout << To_Display;
    #else
        std::cout  << To_Display;
    #endif
}
*/
@end

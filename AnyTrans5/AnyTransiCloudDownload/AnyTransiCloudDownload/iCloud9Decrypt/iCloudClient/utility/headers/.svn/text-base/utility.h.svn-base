//
//  utility.h
//  libantivirus
//
//  Created by Pallas on 6/8/15.
//  Copyright (c) 2015 Pallas. All rights reserved.
//

#ifndef libantivirus_utility_h
#define libantivirus_utility_h

#define BUF_SIZE 1024
#define READ 0
#define WRITE 1

#include "common.h"

/*
 获取文件夹的总大小
 path（In）：文件夹路径
 return：该文件夹的总大小
 */
EXTERN INT64 get_folder_size(char* path);

/*
 获取路径下的总文件个数(包括隐藏文件，子文件夹)
 path（In）：文件夹路径
 return：该文件夹所有文件的个数
 */
EXTERN INT64 get_file_count(char* path);

/*
 获取路径下所有项的个数(不包括隐藏文件和子文件夹下的项)
 path（In）：文件夹路径
 return：该文件夹所有项的个数(不包括隐藏文件和子文件夹下的项)
 */
EXTERN INT64 get_item_count_not_contain_sub_item(char* path);

/*
 过滤掉c语言下路径在Command环境下的特殊字符
 path（In）：文件夹路径
 return：过滤后在Command环境下的路径（外部需要对其返回值手动释放）
 */
EXTERN char* filter_special_character_dos(char *path);

/*
 连接两个字符串
 a（In/Out）：目标的字符串，需要外部不用的时候释放
 b（In）：拼接字符串
 */
EXTERN void join_string(char **a, char *b);

/*
 判断该路径文件是否是一个可执行的文件
 path（In）：检查的文件路径
 return：True为该文件是可执行文件，False为该文件不是可执行文件
 */
EXTERN Bool is_exec_file(char *path);

/*
 执行命令行的命令
 str（In）：要执行的命令
 rw（In）：r只读模式，w只写模式，rw读写模式
 return：True命令执行成功，False命令执行失败
 */
EXTERN Bool exec_cmd(char* str, char* rw);

/*
 执行命令行并返回结果
 str（In）：要执行的命令
 rw（In）：r只读模式，w只写模式，rw读写模式
 return：执行返回回来的字符串
 */
EXTERN char* exec_cmd_ex(char *str,char *rw);

/*
 获取文件或者文件夹的权限
 b[]（Out）：4Byte的内存字符串空间
 path（In）：文件/文件夹路径
 */
EXTERN void get_file_permit(char b[],char *path);

/*
 将可变参数的字符串合并成一个字符串
 len（In）：预设合并后的字符串长度
 return：返回合并后的字符串（有内存分配动作，需要手动释放）
 */
EXTERN char *combine_strings(int len, char *fmt, ... );

/*
 对指定的文件赋予可执行的权限
 path（In）：赋予执行权限的文件
 return：True函数执行成功，False函数执行失败
 */
EXTERN Bool given_execute_permit_in_path(char *path);

/*
 解压指定的压缩文件(zip,tar,tar.gz,tar.bz2,tar.Z,tar.xz)到目标文件夹
 path（In）：压缩包的存放路径
 type（In）：压缩包类型（zip,tar,tar.gz,tar.bz2,tar.Z,tar.xz）
 tofolder（In）：压缩包解压的目标路径
 return：True表示解压成功，False表示解压失败
 */
EXTERN Bool unpack(char *path, char *type,char *tofolder);

/*
 执行shell编译程序脚本
 bash_path（In）：需要执行的脚本路径
 callback（In）：执行过程中回调的函数
 sourcefolder（In）：源程序的所在的Folder
 */
EXTERN void compile_by_shell(char *bash_path, compilecallback callback, char *sourcefolder);

/*
 用管道调用执行命令
 command（In）：要执行的命令
 infp（Out）：输入的管道
 outfp（Out）：输出的管道
 */
EXTERN pid_t popen2(const char *command, int *infp, int *outfp);

/*
 判断字符串是否为数字
 p（In）：源字符串
 return：False为非数字，True为数字
 */
EXTERN Bool is_digit_string(char *p);

/*
 判断sStr是否包含cStr
 sStr（In）：源字符串
 cStr（In）：被包含字符串
 Return：False为没有包含，True为包含
 */
EXTERN Bool contains(char *sStr,char *cStr);

/*
 将源字符串按照分割字符串分割成字符串数组
 str（In）：源字符串
 seps（In）：分割字符串
 count（Out）：统计分割的字符串数组的大小
 return：字符串数组（有内存分配操作，需要手动释放）
 */
EXTERN string_array* seperate(char* str, char* seps, size_t *count);

/*
 截取字符串左端的空格及控制字符
 s（In）：源字符串
 return：截取后的字符串，无内存分配，不需要释放
 */
EXTERN char *ltrim(char *s);

/*
 截取字符串右端的空格及控制字符
 s（In）：源字符串
 return：截取后的字符串，无内存分配，不需要释放
 */
EXTERN char *rtrim(char *s);

/*
 截取字符串左右两端的空格及控制字符
 s（In）：源字符串
 return：截取后的字符串，无内存分配，不需要释放
 */
EXTERN char *trim(char *s);

/*
 判断字符串是否以子字符串开头
 fstr（In）：源字符串
 estr（In）：子字符串
 return：0为False，1为True
 */
EXTERN int starwith(char *fstr,char *sstr);

/*
 判断字符串是否以子字符串结尾
 fstr（In）：源字符串
 estr（In）：子字符串
 return：0为False，1为True
 */
EXTERN int endwith(char *fstr, char *estr);

/*
 将小写字符转换为大写字符
 src（In）：源字符串
 dst（Out）：目标字符串
 */
EXTERN void str_to_upper(char *src, char *dst);

/*
 将大写字符转换为小写字符
 src（In）：源字符串
 dst（Out）：目标字符串
 */
EXTERN void str_to_lower(char *src, char *dst);

/*
 获取字符子串
 ch（In）：源字符串
 pos（In）：从截取位置起始点
 length（In）：从起始点截取多长
 return：返回截取的字符串，在程序外部不使用的时候需要将其内存释放
 */
EXTERN char* substring(char* ch,int pos,int length);

/*
 获取文件的后缀名
 path（In）：文件名字或者路径
 type（In）：文件类型
 */
EXTERN char* extensions(char* path, file_types type);

/*
 获取路径的文件名字
 path（In）：文件名字或者路径
 */
EXTERN char* get_file_name(char* path);

/*
 获取不含后缀名的文件名字
 path（In）：文件名字或者路径
 ext（In）：文件的后缀名字
 */
EXTERN char* get_file_short_name(char* path, char* ext);

/*
 释放C语言字符串数组
 stringarr（In）：字符串数组指针
 */
EXTERN void free_string_arrary(string_array *stringarray);

typedef enum spotlightstatus {
    ServerNotOpened = 0,
    IndexDisabled = 1,
    IndexEnabled = 2,
    IndexReady = 3
} SpotlightStatus;

/*
 判断Spotlight服务开启的状态
 Return：Enum->SpotlightStatus
 */
EXTERN SpotlightStatus is_serv_opened();

#endif

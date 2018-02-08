//
//  utility.c
//  libantivirus
//
//  Created by Pallas on 6/8/15.
//  Copyright (c) 2015 Pallas. All rights reserved.
//

#include <stdio.h>
#include "utility.h"
#include <ctype.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

/*
 获取文件夹的总大小
 path（In）：文件夹路径
 return：该文件夹的总大小
 */
INT64 get_folder_size(char* path) {
    INT64 size = 0;
    /*需要判断文件夹是否存在*/
    if (path == NULL || strlen(path) == 0 || access(path,F_OK) != 0) {
        return size;
    }
    FILE *stream = NULL;
    char *buf[255] = {'\0'};
    char *cmd = "du -h -d 0 ";
    char *frmtpth = NULL;
    frmtpth = filter_special_character_dos(path);
    join_string(&cmd, frmtpth);
    
    char *str = NULL;
    stream = popen(cmd, "r");
    int i = 0;
    while (str == NULL || strlen(str) == 0) {   //会读2次
        i++;
        if (i > 2) {
            break;
        }
        if ((str = fgets((char *)buf, sizeof(buf), stream)) != NULL) {
            sscanf(str, "%lld ",&size);
            //size = size*1.024 * 1024;
            size = size * 1000;
        }
    }
    
    free(cmd);
    free(frmtpth);
    pclose(stream);
    return size;
}

/*
 获取路径下的总文件个数(包括隐藏文件，子文件夹)
 path（In）：文件夹路径
 return：该文件夹所有文件的个数
 */
INT64 get_file_count(char* path) {
    INT64 count = 0;
    /*需要判断文件夹是否存在*/
    if (path == NULL || strlen(path) == 0 || access(path,F_OK) != 0) {
        return count;
    }
    FILE *stream = NULL;
    char *buf[255] = {'\0'};
    char *frmtpth = NULL;
    frmtpth = filter_special_character_dos(path);
    if (frmtpth == NULL) {
        return count;
    }
    char *cmd = calloc(30 + strlen(frmtpth), sizeof(char));
    sprintf(cmd, "find '%s' -type f | wc -l", frmtpth);
    
    char *str = NULL;
    stream = popen(cmd, "r");
    int i = 0;
    while (str == NULL || strlen(str) == 0) {   //会读2次
        i++;
        if (i > 2) {
            break;
        }
        if ((str = fgets((char *)buf, sizeof(buf), stream)) != NULL) {
            sscanf(str, "%lld ",&count);
        }
    }
    
    free(cmd);
    free(frmtpth);
    pclose(stream);
    return count;
}

/*
 获取路径下所有项的个数(不包括隐藏文件和子文件夹下的项)
 path（In）：文件夹路径
 return：该文件夹所有项的个数(不包括隐藏文件和子文件夹下的项)
 */
INT64 get_item_count_not_contain_sub_item(char* path) {
    INT64 count = 0;
    /*需要判断文件夹是否存在*/
    if (path == NULL || strlen(path) == 0 || access(path,F_OK) != 0) {
        return count;
    }
    FILE *stream = NULL;
    char *buf[255] = {'\0'};
    char *frmtpth = NULL;
    frmtpth = filter_special_character_dos(path);
    if (frmtpth == NULL) {
        return count;
    }
    char *cmd = calloc(30 + strlen(frmtpth), sizeof(char));
    sprintf(cmd, "ls -l '%s' |wc -l", frmtpth);
    
    char *str = NULL;
    stream = popen(cmd, "r");
    int i = 0;
    while (str == NULL || strlen(str) == 0) {   //会读2次
        i++;
        if (i > 2) {
            break;
        }
        if ((str = fgets((char *)buf, sizeof(buf), stream)) != NULL) {
            sscanf(str, "%lld ",&count);
        }
        count = count - 1;
    }
    
    free(cmd);
    free(frmtpth);
    pclose(stream);
    return count;
}

/*
 过滤掉c语言下路径在Command环境下的特殊字符
 path（In）：文件夹路径
 return：过滤后在Command环境下的路径（外部需要对其返回值手动释放）
 */
char* filter_special_character_dos(char *path) {
    if (path == NULL || strlen(path) == 0) {
        char *frmt_str = (char *)malloc(1);
        frmt_str[0] = '\0';
        return frmt_str;
    }
    char arr[] = {' ','$','[',']','(',')',';','&'};
    int i = 0,j = 0;
    char *frmt_str = (char *)malloc(255);
    memset(frmt_str, 0x00, strlen(frmt_str));
    for (; path[i] != '\0'; i++) {
        for (int k = 0; k < sizeof(arr); k++) {
            if (path[i] == arr[k]) {
                frmt_str[j] = '\\';
                j ++;
                break;
            }
        }
        frmt_str[j] = path[i];
        j++;
    }
    frmt_str[j] = '\0';
    return frmt_str;
}

/*
 连接两个字符串
 a（In/Out）：目标的字符串，需要外部不用的时候释放
 b（In）：拼接字符串
 */
void join_string(char **a, char *b) {
    int i,j;
    ULONG32 lena = strlen(*a);
    ULONG32 lenb = strlen(b);
    char *newstr = (char *)malloc(sizeof(char)*(lena+lenb+1));
    memset(newstr, 0x00, lena + lenb + 1);
    
    for (i = 0; i < lena; i++) {
        newstr[i] = (*a)[i];
    }
    for (j = 0; j < lenb; j++) {
        newstr[i+j] = b[j];
    }
    newstr[i+j] = '\0';
    *a = newstr;
}

/*
 判断该路径文件是否是一个可执行的文件
 path（In）：检查的文件路径
 return：True为该文件是可执行文件，False为该文件不是可执行文件
 */
Bool is_exec_file(char *path) {
    struct stat s;
    if (access(path, X_OK) == 0) {
        if (stat(path, &s) == 0) {
            if (S_ISREG(s.st_mode)) {
                return True;
            } else {
                return False;
            }
        } else {
            return False;
        }
    } else {
        return False;
    }
}

/*
 执行命令行的命令
 str（In）：要执行的命令
 rw（In）：r只读模式，w只写模式，rw读写模式
 return：True命令执行成功，False命令执行失败
 */
Bool exec_cmd(char* str, char* rw) {
    Bool retVal = False;
    FILE *stream;
    
    ULONG32 lenPth = strlen(str);
    if (!lenPth) {
        return False;
    }
    char *cmd = str;
    stream = popen(cmd, rw);
    int status, code;
    status = pclose(stream);
    if( status != -1 ) {
        if( WIFEXITED(status) ) {  // normal exit
            code = WEXITSTATUS(status);
            if( code != 0 ) {
                // 通常表明出现了一个错误
                retVal = False;
            } else {
                retVal = True;
            }
        } else {
            // 异常终止，例如收到进程终止的信号
            retVal = False;
        }
    }
    return retVal;
}

/*
 执行命令行并返回结果
 str（In）：要执行的命令
 rw（In）：r只读模式，w只写模式，rw读写模式
 return：执行返回回来的字符串
 */
char* exec_cmd_ex(char *str,char *rw) {
    FILE *stream;
    
    char *buf = malloc(BUF_SIZE);
    memset(buf,'\0',BUF_SIZE);
    ULONG32 lenPth = strlen(str);
    if (!lenPth) {
        return 0;
    }
    char *cmd = str;
    stream = popen(cmd, rw);
    size_t len = fread(buf, sizeof(char), BUF_SIZE, stream);
    pclose(stream);
    
    if (len <= 0) {
        free(buf);
        buf = NULL;
    }
    return buf;
}

/*
 用管道调用执行命令
 command（In）：要执行的命令
 infp（Out）：输入的管道
 outfp（Out）：输出的管道
 */
pid_t popen2(const char *command, int *infp, int *outfp) {
    int p_stdin[2], p_stdout[2];
    pid_t pid;
    
    if (pipe(p_stdin) != 0 || pipe(p_stdout) != 0)
        return -1;
    pid = fork();
    
    if (pid < 0)
        return pid;
    else if (pid == 0) {
        close(p_stdin[WRITE]);
        //将标准输出重定向到管道的读端
        dup2(p_stdin[READ], READ);
        close(p_stdout[READ]);
        //将标准输入重定向到管道的写端
        dup2(p_stdout[WRITE], WRITE);
        execl("/bin/sh", "sh", "-c", command, NULL);
        perror("execl"); exit(1);
    }
    
    if (infp == NULL)
        close(p_stdin[WRITE]);
    else
        *infp = p_stdin[WRITE];
    
    if (outfp == NULL)
        close(p_stdout[READ]);
    else
        *outfp = p_stdout[READ];
    return pid;
}

/*
 获取文件或者文件夹的权限
 b[]（Out）：4Byte的内存字符串空间
 path（In）：文件/文件夹路径
 */
void get_file_permit(char b[],char *path) {
    int i = 0;
    b[0] = '\0';
    b[1] = '\0';
    b[2] = '\0';
    b[3] = '\0';
    
    int r = access(path, R_OK) == 0;
    int w = access(path, W_OK) == 0;
    int x = access(path, X_OK) == 0;
    if (r) {
        b[i] = 'r';
        i++;
    }
    if (w) {
        b[i] = 'w';
        i++;
    }
    if (x) {
        b[i] = 'x';
        i++;
    }
    
    b[3] = '\0';
}

/*
 将可变参数的字符串合并成一个字符串
 len（In）：预设合并后的字符串长度
 return：返回合并后的字符串（有内存分配动作，需要手动释放）
 */
char *combine_strings(int len, char *fmt, ... ) {
    va_list ap;
    char *ptr;
    ptr = (char *)malloc(len * sizeof(char));
    if(ptr == NULL)
    {
        fprintf(stderr, "malloc failed\n");
        return NULL;
    }
    memset(ptr, 0, len);
    va_start(ap, fmt);
    vsprintf(ptr, fmt, ap);
    va_end(ap);
    ptr[len-1] = '\0';
    return ptr;
}

/*
 根据App的路径打开对应的程序
 */
Bool open_app_in_path(char *path){
    if (path == NULL || strlen(path) ==0 || access(path, F_OK) != 0) {
        return False;
    }
    char *frmtpth = filter_special_character_dos(path);
    size_t len = strlen(path) + 30;
    char *buf = combine_strings((int)len, "open %s",frmtpth);
    char* exestr = exec_cmd_ex(buf, "r");
    free(buf);
    free(frmtpth);
    free(exestr);
    return True;
}

/*
 对指定的文件赋予可执行的权限
 path（In）：赋予执行权限的文件
 return：True函数执行成功，False函数执行失败
 */
Bool given_execute_permit_in_path(char *path) {
    if (path == NULL || strlen(path) ==0 || access(path, F_OK) != 0) {
        return False;
    }
    int ret = chmod(path, S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH);
    return ret == 0 ? True : False;
}

/*
 解压指定的压缩文件(zip,tar,tar.gz,tar.bz2,tar.Z,tar.xz)到目标文件夹
 path（In）：压缩包的存放路径
 type（In）：压缩包类型（zip,tar,tar.gz,tar.bz2,tar.Z,tar.xz）
 tofolder（In）：压缩包解压的目标路径
 return：True表示解压成功，False表示解压失败
 */
Bool unpack(char *path, char *type,char *tofolder) {
    if (path == NULL || strlen(path) ==0 || access(path, F_OK) != 0) {
        return False;
    }
    size_t len = strlen(path) + strlen(tofolder) + 30;
    char *buf = NULL;
    if (strcmp(type, "zip") == 0) {
        buf = combine_strings((int)len, "unzip %s -d %s",path,tofolder);
    } else if (strcmp(type, "tar") == 0) {
        buf = combine_strings((int)len, "tar -xvf %s -C %s",path,tofolder);
    } else if (strcmp(type, "tar.gz") == 0) {
        buf = combine_strings((int)len, "tar -xzvf %s -C %s",path,tofolder);
    } else if (strcmp(type, "tar.bz2") == 0) {
        buf = combine_strings((int)len, "tar -xjvf %s -C %s",path,tofolder);
    } else if (strcmp(type, "tar.Z") == 0) {
        buf = combine_strings((int)len, "tar -xZvf %s -C %s",path,tofolder);
    } else if (strcmp(type, "tar.xz") == 0) {
        buf = combine_strings((int)len, "tar -Jxvf %s -C %s",path,tofolder);
    } else {
        return False;
    }
    Bool retVal = exec_cmd(buf, "r");
    free(buf);
    return retVal;
}

/*
 执行shell编译程序脚本
 bash_path（In）：需要执行的脚本路径
 callback（In）：执行过程中回调的函数
 sourcefolder（In）：源程序的所在的Folder
 */
void compile_by_shell(char *bash_path, compilecallback callback, char *sourcefolder) {
    FILE *stream = NULL;
    
    char buf[1024];
    memset(buf,'\0',sizeof(buf));

    size_t len = (bash_path != NULL ? strlen(bash_path) : 0) + (sourcefolder != NULL ? strlen(sourcefolder) : 0) + 30;
    char *cmd = combine_strings((int)len, "'%s' '%s'",bash_path,sourcefolder);
    stream = popen(cmd, "r");
    free(cmd);
    
    char *str = NULL;
    // 防止无法读取数据
    while ((str = fgets(buf, sizeof(buf), stream)) == NULL);
    // 读取所有的进度信息
    if (callback != NULL) {
        callback(str);
    }
    while ((str = fgets(buf, sizeof(buf), stream)) != NULL) {
        if (callback != NULL) {
            callback(str);
        }
    }
}

/*
 判断字符串是否为数字
 p（In）：源字符串
 return：False为非数字，True为数字
 */
Bool is_digit_string(char *p) {
    Bool retVal = False;
    size_t length;
    length = strlen(p);//统计输入字符串的有效字符长度
    while((*p)!=0) { //逐个字符检查
        if((*p)>='0' && (*p)<='9')//如果出现数字，则字符串长度减1
            length--;
        p++;//指向下一个字符
    }
    if(length == 0) {
        retVal = True;
    } else {
        retVal = False;
    }
    return retVal;
}

/*
 判断sStr是否包含cStr
 sStr（In）：源字符串
 cStr（In）：被包含字符串
 Return：False为没有包含，True为包含
 */
Bool contains(char *sStr,char *cStr) {
    int i,j,k = 0;
    int rs = 0;
    ULONG32 slen = strlen(sStr);
    ULONG32 clen = strlen(cStr);
    if (slen == 0 || cStr == 0) {
        return rs;
    }
    for (i = 0; sStr[i] != '\0'; i++) {
        for (j = 0; cStr[j] != '\0'; j++) {
            int cmpindx = i + j;
            if (cmpindx >= slen) {
                rs = 0;
                break;
            }
            if (sStr[i+j] == cStr[j]) {
                k++;
            }
            else{
                k = 0;
            }
            if (k == clen && k != 0) {
                rs = 1;
                break;
            }
        }
        if (rs == 1) {
            break;
        }
    }
    return rs;
}

/*
 将源字符串按照分割字符串分割成字符串数组
 str（In）：源字符串
 seps（In）：分割字符串
 count（Out）：统计分割的字符串数组的大小
 return：字符串数组（有内存分配操作，需要手动释放）
 */
string_array* seperate(char* str, char* seps, size_t *count) {
    *count = 0;
    char *token = strtok(str, seps);
    string_array *start = (string_array *)malloc(sizeof(string_array));
    memset(start, 0x00, sizeof(string_array));
    string_array *previous = start;
    while (token) {
        if (token != NULL) {
            string_array *node = (string_array *)malloc(sizeof(string_array));
            memset(node, 0x00, sizeof(string_array));
            node->content = (char*)malloc(strlen(token)+1);
            strcpy(node->content, token);
            *count += 1;
            previous->next = node;
            previous = previous -> next;
        }
        token = strtok(NULL, seps);
    }
    if (start->next) {
        string_array *resArr = NULL;
        resArr = start->next;
        free(start);
        start = NULL;
        return resArr;
    }
    else{
        free(start);
        start = NULL;
        return NULL;
    }
}

/*
 截取字符串左端的空格及控制字符
 s（In）：源字符串
 return：截取后的字符串，无内存分配，不需要释放
 */
char *ltrim(char *s) {
    while(isspace(*s)) s++;
    return s;
}

/*
 截取字符串右端的空格及控制字符
 s（In）：源字符串
 return：截取后的字符串，无内存分配，不需要释放
 */
char *rtrim(char *s) {
    char* back;
    size_t len = strlen(s);
    
    if(len == 0)
        return(s);
    
    back = s + len;
    while(isspace(*--back));
    *(back+1) = '\0';
    return s;
}

/*
 截取字符串左右两端的空格及控制字符
 s（In）：源字符串
 return：截取后的字符串，无内存分配，不需要释放
 */
char *trim(char *s) {
    return rtrim(ltrim(s));
}

/*
 判断字符串是否以子字符串开头
 fstr（In）：源字符串
 estr（In）：子字符串
 return：0为False，1为True
 */
int starwith(char *fstr,char *sstr){
    int rs = 0;
    if (fstr == NULL || sstr == NULL) {
        return rs;
    }
    ULONG32 flen = strlen(fstr);
    ULONG32 slen = strlen(sstr);
    if (flen < slen) {
        return rs;
    }
    if ((flen == 0 && slen == 0) || (flen > 0 && slen == 0)) {
        return 1;
    }
    int i = 0,j = 0;
    rs = 1;
    for (; fstr[i] != 0; i++) {
        if (fstr[i] == sstr[j]) {
            j++;
            if (j == slen) {
                break;
            }
            continue;
        }
        rs = 0;
        break;
    }
    if (!(rs == 1 && j == slen)) {
        rs = 0;
    }
    return rs;
}

/*
 判断字符串是否以子字符串结尾
 fstr（In）：源字符串
 estr（In）：子字符串
 return：0为False，1为True
 */
int endwith(char *fstr, char *estr){
    int rs = 0;
    if (fstr == NULL || estr == NULL) {
        return rs;
    }
    
    ULONG32 flen = strlen(fstr);
    ULONG32 elen = strlen(estr);
    if (flen <  elen) {
        return rs;
    }
    if ((flen == 0 && elen == 0) || (flen > 0 && elen == 0)) {
        return 1;
    }
    long i = flen - 1,j = elen - 1;
    rs = 1;
    for (; i >= 0 && j >= 0; i --,j -- ){
        if(fstr[i] != estr[j])
        {
            rs = 0;
            break;
        }
    }
    if (j < 0 && rs) {
        rs = 1;
    }
    return rs;
}

/*
 将小写字符转换为大写字符
 src（In）：源字符串
 dst（Out）：目标字符串
 */
void str_to_upper(char *src, char *dst)
{
    while (*src) {
        *dst++ = *src++;
        if (dst[-1] >= 'a' && dst[-1] <= 'z')
            dst[-1] ^= 0x20;
    }
}

/*
 将大写字符转换为小写字符
 src（In）：源字符串
 dst（Out）：目标字符串
 */
void str_to_lower(char *src, char *dst)
{
    while (*src) {
        *dst++ = *src++;
        if (dst[-1] >= 'A' && dst[-1] <= 'Z')
            dst[-1] ^= 0x20;
    }
}

/*
 获取字符子串
 ch（In）：源字符串
 pos（In）：从截取位置起始点
 length（In）：从起始点截取多长
 return：返回截取的字符串，在程序外部不使用的时候需要将其内存释放
 */
char* substring(char* ch,int pos,int length)
{
    char* pch=ch;
    //定义一个字符指针，指向传递进来的ch地址。
    char* subch=calloc(sizeof(char),length+1);
    //通过calloc来分配一个length长度的字符数组，返回的是字符指针。
    int i;
    //只有在C99下for循环中才可以声明变量，这里写在外面，提高兼容性。
    pch=pch+pos;
    //是pch指针指向pos位置。
    for(i=0;i<length;i++)
    {
        subch[i]=*(pch++);
        //循环遍历赋值数组。
    }
    subch[length]='\0'; //加上字符串结束符。
    return subch;       //返回分配的字符数组地址。
}


/*
 获取文件的后缀名
 path（In）：文件名字或者路径
 type（In）：文件类型
 */
char* extensions(char* path, file_types type) {
    char *ptr, c = '.', *dptr, d = '/';
    int pos;
    ptr = strrchr(path, c);
    dptr = strrchr(path, d);
    if (ptr == NULL) {
        return NULL;
    }
    pos = (int)(ptr - path);
    if (dptr != NULL) {
        int dPos = (int)(dptr - path);
        if (dPos > pos) {
            return NULL;
        }
    }
    char* substr = NULL;
    if (pos > 0) {
        substr = substring(path, pos + 1, (int)(strlen(path) - (pos + 1)));
    }
    if (substr != NULL && type == TYPES_DIR) {
        if (!(strcmp(substr, "download") == 0 || strcmp(substr, "app") == 0 || strcmp(substr, "pages") == 0 || strcmp(substr, "vmwarevm") == 0 || strcmp(substr, "xcworkspace") == 0 || strcmp(substr, "xcuserdatad") == 0 || strcmp(substr, "xcworkspace") == 0 || strcmp(substr, "xcodeproj") == 0 || strcmp(substr, "photolibrary") == 0 || strcmp(substr, "workflow") == 0 || strcmp(substr, "scptd") == 0 || strcmp(substr, "framework") == 0 || strcmp(substr, "localized") == 0 || strcmp(substr, "dictionary") == 0 || strcmp(substr, "kext") == 0 || strcmp(substr, "plugin") == 0 || strcmp(substr, "bundle") == 0 || strcmp(substr, "prefPane") == 0 || strcmp(substr, "mdimporter") == 0 || strcmp(substr, "wdgt") == 0 || strcmp(substr, "component") == 0 || strcmp(substr, "qlgenerator") == 0 || strcmp(substr, "icons") == 0 || strcmp(substr, "ccl") == 0 || strcmp(substr, "action") == 0)) {
            substr = NULL;
        }
    }
    return substr;
}

/*
 获取路径的文件名字
 path（In）：文件名字或者路径
 */
char* get_file_name(char* path) {
    char *fileName = NULL;
    char *ptr, c = '/';
    if (path != NULL) {
        size_t len = strlen(path);
        if (len <= 0) return NULL;
        else {
            int pos;
            ptr = strrchr(path, c);
            if (ptr != NULL) {
                pos = (int)(ptr - path) + 1;
                fileName = substring(path, pos, (int)(len - pos));
            } else {
                fileName = path;
            }
        }
    }
    return fileName;
}

/*
 获取不含后缀名的文件名字
 path（In）：文件名字或者路径
 ext（In）：文件的后缀名字
 */
char* get_file_short_name(char* path, char* ext) {
    char* shortName = NULL;
    char *fileName = get_file_name(path);
    if (fileName != NULL) {
        if (ext != NULL) {
            size_t fnLen = strlen(fileName);
            size_t extLen = strlen(ext);
            size_t endPos = fnLen - extLen;
            if (endPos > 0) {
                shortName = substring(fileName, 0, (int)(endPos - 1));
            }
        } else {
            shortName = fileName;
        }
    }
    return shortName;
}


/*
 释放C语言字符串数组
 stringarr（In）：字符串数组指针
 */
void free_string_arrary(string_array *stringarr){
    if (stringarr != NULL) {
        string_array *next = stringarr;
        string_array *node;
        while (next) {
            node = next;
            next = next->next;
            free(node->content);
            node->content =NULL;
            free(node);
            node = NULL;
        }
    }
}

/*
 判断Spotlight服务开启的状态
 Return：Enum->SpotlightStatus
 */
SpotlightStatus is_serv_opened(){
    SpotlightStatus status = IndexDisabled;
    FILE *stream = NULL;
    char buf[1024] = {0};
    memset(buf, '\0', sizeof(buf));
    char *cmd = "mdutil -a -i on";
    while (strlen(buf) == 0||(!contains(buf,"Index") && !contains(buf, "server"))) {
        usleep(50);
        pclose(stream);
        stream = popen(cmd,"r");
        fread(buf, sizeof(char), sizeof(buf), stream);
    }
    if (contains(buf,"Spotlight server is disabled")) {
        status = ServerNotOpened;
    }
    else{
        if (contains(buf, "Indexing disabled")) {
            status = IndexDisabled;
        }
        else if (contains(buf, "Indexing enabled")){
            status = IndexEnabled;
        }
    }
    pclose(stream);
    return status;
}

#######################



/*
 
 解析CDB文件到底应该怎么解析，看着项目里解析还是挺复杂的
 
 */

########
########解析CDB文件分别调用的文件的类的read方法顺序及其步骤
1、_dataArray = [[NSMutableArray alloc] initWithArray:[_information getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:Category_Music]]];
2、NSArray *trackArray = [self trackArray];
3、[self refreshMedia];     IMBInformation   - trackArray
4、[_mediaDatabase parse];  IMBInformation   - refreshMedia
5、[self readDatabase:databaseRoot]; IBMusicDataBase  - parse
6、[root read:iPod reader:reader currPosition:0];  IMBBaseDataBase  - readDatabase:
7、decCurrPostion = [containerHeader read:iPod reader:decompressionData currPosition:decCurrPostion];    IMBItunesCDBRoot   - (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition
8、currPosition = [_childElement read:iPod reader:reader currPosition:currPosition];  IMBListContainerHeader  - (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition
9、currPosition = [_childSection read:iPod reader:reader currPosition:currPosition];
   IMBListContainer  - (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition
10、currPosition = [track read:iPod reader:reader currPosition:currPosition];
    IMBTrackList   - (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition
11、IMBTrack  - (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition



# import cv2
import numpy as np
import sys
import shlex
import os
import subprocess
import pprint
import random
import string
import shutil

reload(sys)
sys.setdefaultencoding("utf-8")


class HEICConverter:
    """A simple converter to take HEIC files from ios11 and convert them into raster images, such as PNG"""

    def __init__(self, inputFilename, inputPath, outputPath, fileType, pyPath):
        self.inputFilename = inputFilename
        self.inputFilenameNoExtension = inputFilename.lower().split('.heic')[0]
        self.nameNoExtentsion = self.inputFilenameNoExtension.split('/')[-1]
        self.tmpheicFilePath = pyPath.split('/Resources/heicConvert.py')[0]
        self.heicFilePath = self.tmpheicFilePath + "/MacOS"
        self.heicFFmpegFilePath = self.tmpheicFilePath + "/Resources"
        self.numbTiles = self.findNumberOfTiles()
        self.fileType = fileType
        self.newNameExtension = self.nameNoExtentsion + ".bmp"
        self.convertNewNameExtension = self.nameNoExtentsion + "." + self.fileType
        self.outputPath = outputPath + "/"
        self.tempPath = inputPath + "/" + self.nameNoExtentsion
        # cleanup old files first
        if os.path.exists(self.tempPath):
            shutil.rmtree(self.tempPath)

        if not os.path.exists(self.tempPath + "/bmps"):
            os.makedirs(self.tempPath + "/bmps")

        self.extractHEVC()
        self.convertHEVCToBMP()
        self.tilesToSingleFile()
        # self.cropBlackBars()
        self.rotateMetadata()
        self.cropMetadata()
        self.rotateReverseMetadata()

        self.convertBMPToPNG()

        self.copyMetadata()  # does nothing at the moment, see todo below

        # #cleanup temp files
        if os.path.exists(self.tempPath):
            shutil.rmtree(self.tempPath)

        print "heicConvert Completed"

    # def cropBlackBars(self):
    #     img = cv2.imread(self.tempPath + "/" + self.newNameExtension)
    #     gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    #     _, thresh = cv2.threshold(gray, 10, 255, cv2.THRESH_BINARY)
    #     contours = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    #     cnt = contours[0]
    #     x, y, w, h = cv2.boundingRect(cnt)
    #     crop = img[y:y + h, x:x + w]
    #     cv2.imwrite(self.tempPath + "/" + self.newNameExtension, crop)

    def cropMetadata(self):
        if self.numbTiles is 48 or self.numbTiles is 49:
            command = '"%s/ffmpeg" -i "%s/%s" -vf crop=4032:3024:4096:3072 -y "%s/%s"' % (
                self.heicFFmpegFilePath, self.tempPath, self.newNameExtension, self.tempPath, self.newNameExtension)
        elif self.numbTiles is 36 or self.numbTiles is 35:
            if os.path.exists(self.bmpFileName):
                command = '"%s/ffmpeg" -i "%s/%s" -vf crop=3024:3024:3072:3072 -y "%s/%s"' % (
                self.heicFFmpegFilePath, self.tempPath, self.newNameExtension, self.tempPath, self.newNameExtension)
            else:
                command = '"%s/ffmpeg" -i "%s/%s" -vf crop=3088:2320:3584:2560 -y "%s/%s"' % (
                self.heicFFmpegFilePath, self.tempPath, self.newNameExtension, self.tempPath, self.newNameExtension)
        else:
            if self.numbTiles > 200 and self.numbTiles % 8 == 0:
                command = '"%s/ffmpeg" -i "%s/%s" -vf crop=16384:3634:16384:4096 -y "%s/%s"' % (
                    self.heicFFmpegFilePath, self.tempPath, self.newNameExtension, self.tempPath, self.newNameExtension)
        subprocess.call(shlex.split(command))

    def rotateMetadata(self):
        command = '"%s/ffmpeg" -i "%s/%s" -vf "transpose=1, transpose=1" -y "%s/%s"' % (
        self.heicFFmpegFilePath, self.tempPath, self.newNameExtension, self.tempPath, self.newNameExtension)
        subprocess.call(shlex.split(command))

    def rotateReverseMetadata(self):
        command = '"%s/ffmpeg" -i "%s/%s" -vf "transpose=2" -y "%s/%s"' % (
        self.heicFFmpegFilePath, self.tempPath, self.newNameExtension, self.tempPath, self.newNameExtension)
        subprocess.call(shlex.split(command))
        if self.numbTiles > 200 and self.numbTiles % 8 == 0:
            command = '"%s/ffmpeg" -i "%s/%s" -vf "transpose=2" -y "%s/%s"' % (
            self.heicFFmpegFilePath, self.tempPath, self.newNameExtension, self.tempPath, self.newNameExtension)
            subprocess.call(shlex.split(command))

    # MP4Box -info
    def findNumberOfTiles(self):
        proc = subprocess.Popen(["%s/MP4Box" % (self.heicFilePath), "-info", self.inputFilename],
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output = proc.stderr.readlines()
        itemLines = [x for x, x in enumerate(output) if x.startswith('Item #')]
        # the last 3 items in the list are not tiles, n-2 is a grid, n-1 is a thumbnail and n is EXIF data
        return len(itemLines) - 3

    # MP4Box -dump-item $i:path=item$i.hevc IMG_5915.HEIC
    def extractHEVC(self):
        for i in range(1, self.numbTiles+1):
            command = '"%s/MP4Box" -dump-item %s:path="%s/tile%s.hevc" "%s"' % (
            self.heicFilePath, i, self.tempPath, str(i).zfill(2), self.inputFilename)
            subprocess.call(shlex.split(command))

    # ffmpeg -i item$i.hevc -frames:v 1 -vsync vfr -q:v 1 -an image$i.bmp
    def convertHEVCToBMP(self):
        for i in range(1, self.numbTiles+1):
            command = '"%s/ffmpeg" -i "%s/tile%s.hevc" -frames:v 1 -q:v 1 -an "%s/bmps/tile%s.bmp"' % (
            self.heicFFmpegFilePath, self.tempPath, str(i).zfill(2), self.tempPath, str(i).zfill(2))
            subprocess.call(shlex.split(command))

    def tilesToSingleFile(self):
        # This is probably a huge bug, i am assuming that there is always 8 tiles per row, because this is the files i was working with on this project
        # But i'm nearly 100% positive that sometimes there is more tiles than this per row, so we need a way to determin how many tiles per row
        # And i don't know how to determin this
        title = ''
        for i in range(1, self.numbTiles+1):
            title += '"%s/bmps/tile%s.bmp" ' % (self.tempPath, str(i).zfill(2))
        # title = title[:-1]
        if self.numbTiles is 48 or self.numbTiles is 49:
            command = '"%s/montage" %s-tile 8x -geometry +0+0 "%s/%s"' % (
                self.heicFilePath, title, self.tempPath, self.newNameExtension)
        elif self.numbTiles is 36 or self.numbTiles is 35:
            self.bmpFileName = self.tempPath + "/bmps/" + "tile36.bmp"
            if os.path.exists(self.bmpFileName):
                command = '"%s/montage" %s-tile 6x -geometry +0+0 "%s/%s"' % (
                    self.heicFilePath, title, self.tempPath, self.newNameExtension)
            else:
                command = '"%s/montage" %s-tile 7x -geometry +0+0 "%s/%s"' % (
                self.heicFilePath, title, self.tempPath, self.newNameExtension)
        else:
            if self.numbTiles > 200 and self.numbTiles % 8 == 0:
                command = '"%s/montage" %s-tile %sx -geometry +0+0 "%s/%s"' % (
                    self.heicFilePath, title, self.numbTiles/8, self.tempPath, self.newNameExtension)
        subprocess.call(shlex.split(command))

    def convertBMPToPNG(self):
        command = '"%s/ffmpeg" -i "%s/%s" -y "%s/%s"' % (
        self.heicFFmpegFilePath, self.tempPath, self.newNameExtension, self.tempPath, self.convertNewNameExtension)
        subprocess.call(shlex.split(command))
    def copyMetadata(self):
        # TODO: grab the metadata from the last tile in the set, and write it to the output file
        if os.path.isfile(self.tempPath + "/" + self.convertNewNameExtension):
            shutil.copy2(self.tempPath + "/" + self.convertNewNameExtension, self.outputPath)
        return


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print "Usage: python heic.py image.heic tmemPath savePath fileType"
        exit()
    pyName = sys.argv[0]
    argvs = sys.argv[1]
    inputFilename = argvs.split(',,,')[0]
    inputFilePath = argvs.split(',,,')[1]
    outputFilePath = argvs.split(',,,')[2]
    fileType = sys.argv[2]
    if not os.path.isfile(inputFilename):
        print "Please specify a correct filepath"
        exit()
    convert = HEICConverter(inputFilename, inputFilePath, outputFilePath, fileType, pyName)

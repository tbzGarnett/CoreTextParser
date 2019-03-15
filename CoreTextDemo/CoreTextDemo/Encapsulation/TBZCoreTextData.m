//
//  TBZCoreTextData.m
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TBZCoreTextData.h"
#import "TBZCoreImageData.h"

@implementation TBZCoreTextData

//CTFrameRef不支持ARC
- (void)setCtFrame:(CTFrameRef)ctFrame{
    if (_ctFrame != ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
    }
    CFRetain(ctFrame);
    _ctFrame = ctFrame;
}

- (void)dealloc{
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

-(void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    [self fillImagePosition];
    
}
//填充图片
-(void)fillImagePosition{
    if (self.imageArray.count==0) {
        return;
    }
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    NSInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int imgIndex = 0;
    TBZCoreImageData *imageData = self.imageArray[0];
    for (int i=0; i<lineCount; i++) {
        if (imageData==nil) {
            break;
        }
        //获得line对象
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray *runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        //遍历该line对象中的run对象
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            //如果该run对象没有CTRunDelegate对象，则结束本次循环，继续下一次循环
            if (delegate == nil) {
                continue;
            }
            //得到CTRunDelegate对象绑定的数据，CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)dict);
            NSDictionary *metaDic = CTRunDelegateGetRefCon(delegate);
            //验证数据的格式
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            //计算图片的rect
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat x0ffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + x0ffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            imageData.imagePostion = delegateBounds;
            imgIndex ++;
            if (imgIndex == self.imageArray.count) {
                //所有图片都处理完 结束遍历
                imageData = nil;
                break;
            }else{
                imageData = self.imageArray[imgIndex];
            }
        }
    }
}


@end

//
//  TBZMixedFrameParser.m
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TBZUrlFrameParser.h"
#import <CoreText/CoreText.h>
#import "TBZFrameParserConfig.h"
#import "TBZCoreTextData.h"
#import "TBZCoreImageData.h"
#import "TBZCoreUrlData.h"

@implementation TBZUrlFrameParser

+ (TBZCoreTextData *)parseTemplateFile:(NSString *)path config:(TBZFrameParserConfig *)config{
    NSMutableArray *mArr = [NSMutableArray array];
    NSMutableArray *linkArr = [NSMutableArray array];
    NSAttributedString *attString = [self loadTemplateFile:path config:config imageArray:mArr linkArray:linkArr];
    TBZCoreTextData *data = [self parseAttributedContent:attString config:config];
    data.imageArray = mArr;
    data.linkArray = linkArr;
    return data;
}

//方法二：读取JSON文件内容，并且调用方法三获得从NSDcitionay到NSAttributedString的转换结果
+ (NSAttributedString *)loadTemplateFile:(NSString *)path config:(TBZFrameParserConfig *)config imageArray:(NSMutableArray *)imageArray linkArray:(NSMutableArray *)linkArray{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (data) {
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                
                NSString *type = dict[@"type"];
                //区分文本和图片
                if ([type isEqualToString:@"txt"]) {
                    
                    NSAttributedString *as = [self parseAttributeContentFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                    
                }else if ([type isEqualToString:@"img"]){
                    
                    //创建TBZCoreImageData,保存图片到imageArray数组中
                    TBZCoreImageData *imageData = [[TBZCoreImageData alloc] init];
                    //设置图片的名字字符串；
                    imageData.name = dict[@"name"];
                    //设置图片的插入位置
                    imageData.position = [result length];
                    [imageArray addObject:imageData];
                    
                    //创建空白占位符，并且设置它的CTRunDelegate信息
                    NSAttributedString *as = [self parseImageDataFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                }else if ([type isEqualToString:@"link"]){
                    
                    NSUInteger startPo = [result length];
                    NSAttributedString *as = [self parseAttributeContentFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                    
                    NSRange linkRange = NSMakeRange(startPo, result.length - startPo);
                    
                    TBZCoreUrlData *urlData = [[TBZCoreUrlData alloc] init];
                    urlData.title = dict[@"content"];
                    urlData.url = dict[@"url"];
                    urlData.range = linkRange;
                    [linkArray addObject:urlData];
                }
            }
        }
    }
    return  result;
}

//接受一个NSAttributedString和一个Config参数，将NSAttributedString转换成CoreTextData返回
+ (TBZCoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(TBZFrameParserConfig *)config{
    
    //创建CTFrameStterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    //获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [content length]), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    //生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    //将生成好的CTFrameRef实例和计算好的绘制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    TBZCoreTextData *data = [[TBZCoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    //释放内存
    CFRelease(framesetter);
    CFRelease(frame);
    
    return data;
}

//一个辅助函数
+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter config:(TBZFrameParserConfig *)config height:(CGFloat)height{
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

//将NSDcitionay内容转换为NSAttributedString
+(NSAttributedString *)parseAttributeContentFromNSDictionary:(NSDictionary*)dict config:(TBZFrameParserConfig *)config{
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesWithConfig:config]];
    
    //设置颜色
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    
    //设置字号
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize>0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

//提供将NSString转换为UIColor的功能
+(UIColor *)colorFromTemplate:(NSString *)name{
    
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    }else if ([name isEqualToString:@"red"]){
        return [UIColor redColor];
    }else if ([name isEqualToString:@"black"]){
        return [UIColor blackColor];
    }else if ([name isEqualToString:@"purple"]){
        return [UIColor purpleColor];
    }else{
        return nil;
    }
}

+ (NSDictionary *)attributesWithConfig:(TBZFrameParserConfig *)config{
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpec = config.lineSpace;
    const CFIndex kNumberOfSetting = 3;
    CTParagraphStyleSetting theSetting[kNumberOfSetting] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&lineSpec},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpec},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpec}
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSetting, kNumberOfSetting);
    
    UIColor *textColor = config.textColor;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //这里注意NSForegroundColorAttributeName和kCTForegroundColorAttributeName
    [dict setValue:(id)textColor.CGColor forKey:(id)kCTForegroundColorAttributeName];
    [dict setValue:(__bridge id)fontRef forKey:(id)kCTFontAttributeName];
    [dict setValue:(__bridge id)theParagraphRef forKey:(id)kCTParagraphStyleAttributeName];
    
    CFRelease(fontRef);
    CFRelease(theParagraphRef);
    return dict;
}

#pragma mark - 添加设置CTRunDelegate信息的方法
static CGFloat ascentCallback(void *ref){
    
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback(void *ref){
    
    return 0;
}
static CGFloat widthCallback(void *ref){
    
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}
+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict config:(TBZFrameParserConfig *)config{
    
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    //将宽高信息通过delegate返回
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)dict);
    
    //使用0xFFFC作为空白占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    //将CTRunDelegate对象跟CTAttributedString绑定
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

@end

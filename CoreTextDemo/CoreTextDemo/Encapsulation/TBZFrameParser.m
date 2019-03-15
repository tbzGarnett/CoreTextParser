//
//  TBZFrameParser.m
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TBZFrameParser.h"
#import "TBZCoreTextData.h"
#import "TBZFrameParserConfig.h"

@implementation TBZFrameParser

+ (TBZCoreTextData *)parserContent:(NSString *)content config:(TBZFrameParserConfig *)config{
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    
    //创建CTFrameSetterRef实例
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    
    //获得要绘制的区域
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize contentSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetterRef, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = contentSize.height;
    
    //生成CTFrameRef实例
    CTFrameRef frameRef = [self createFrameWithFrameSetter:frameSetterRef config:config height:textHeight];
    
    TBZCoreTextData *data = [[TBZCoreTextData alloc] init];
    data.ctFrame = frameRef;
    data.height = textHeight;
    
    CFRelease(frameSetterRef);
    CFRelease(frameRef);
    return data;
}

+ (TBZCoreTextData *)parserAttributeString:(NSAttributedString *)attString config:(TBZFrameParserConfig *)config{
    //创建CTFrameSetterRef实例
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    
    //获得要绘制的区域
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize contentSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetterRef, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = contentSize.height;
    
    //生成CTFrameRef实例
    CTFrameRef frameRef = [self createFrameWithFrameSetter:frameSetterRef config:config height:textHeight];
    
    TBZCoreTextData *data = [[TBZCoreTextData alloc] init];
    data.ctFrame = frameRef;
    data.height = textHeight;
    
    CFRelease(frameSetterRef);
    CFRelease(frameRef);
    return data;
}

+ (TBZCoreTextData *)parserPath:(NSString *)path config:(TBZFrameParserConfig *)config{
    NSAttributedString *attString = [self loadTempleteWithPath:path config:config];
    return [self parserAttributeString:attString config:config];
}

+ (NSAttributedString *)loadTempleteWithPath:(NSString *)path config:(TBZFrameParserConfig *)config{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    if (data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in array) {
                NSString *type = dic[@"content"];
                if ([dic[@"type"] isEqualToString:@"txt"]) {
                    NSAttributedString *as = [self parseAttributeContentFromNSDictionary:dic config:config];
                    [attString appendAttributedString:as];
                }
            }
        }
    }
    
    return attString;
}

+ (NSAttributedString *)parseAttributeContentFromNSDictionary:(NSDictionary *)dict config:(TBZFrameParserConfig *)config{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesWithConfig:config]];
    
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    
    CGFloat fontsize = [dict[@"size"] floatValue];
    if (fontsize>0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontsize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

+(UIColor *)colorFromTemplate:(NSString *)name{
    
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    }else if ([name isEqualToString:@"red"]){
        return [UIColor redColor];
    }else if ([name isEqualToString:@"black"]){
        return [UIColor blackColor];
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

+ (CTFrameRef)createFrameWithFrameSetter:(CTFramesetterRef)frameSetterRef config:(TBZFrameParserConfig *)config height:(CGFloat)textHeight{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, textHeight));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

@end

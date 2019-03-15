//
//  TBZDisplayView.m
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TBZDisplayView.h"
#import <CoreText/CoreText.h>

@implementation TBZDisplayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    //1.创建上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2.旋转坐坐标系(默认和UIKit坐标是相反的)
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //创建绘制区域
    CGMutablePathRef path1 = CGPathCreateMutable();
    //将绘制区域添加到rect中
//    CGPathAddRect(path, NULL, self.bounds);
    //因为坐标系是反的 所以再上面的段落rect需要注意一下
    CGPathAddRect(path1, NULL, CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2));
    
    //设置绘制内容
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"凯文·加内特（Kevin Garnett），1976年5月19日出生在美国南卡罗来纳，前美国职业篮球运动员，司职大前锋/中锋，绰号狼王（森林狼时期）、KG（名字缩写）、The BIG TICKET、Da Kid。"
                                     "1995年NBA选秀，凯文·加内特首轮第五顺位被明尼苏达森林狼队选中，2003-04赛季获得常规赛MVP。2007年夏季转会至波士顿凯尔特人，和雷·阿伦和保罗·皮尔斯一起形成了“凯尔特人三巨头”，2008年的总决赛中击败湖人队，获得NBA总冠军。2013年，加内特被交易至布鲁克林篮网队。2015年重回明尼苏达森林狼队。"];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    //第一个段落
    CTFrameRef frame1 = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]/2), path1, NULL);
    
    //开始绘制
    CTFrameDraw(frame1, context);
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathAddRect(path2, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2));
    //第二个段落
    CTFrameRef frame2 = CTFramesetterCreateFrame(framesetter, CFRangeMake([attString length]/2, [attString length]/2), path2, NULL);
    
    CTFrameDraw(frame2, context);
    
    //释放资源
    CFRelease(framesetter);
    CFRelease(frame1);
    CFRelease(path1);
    CFRelease(frame2);
    CFRelease(path2);
}


@end

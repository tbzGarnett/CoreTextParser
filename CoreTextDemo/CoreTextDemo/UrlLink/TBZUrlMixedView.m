//
//  TBZUrlMixedView.m
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TBZUrlMixedView.h"
#import "TBZCoreTextData.h"
#import "TBZCoreImageData.h"
#import "TBZCoreUrlData.h"

@implementation TBZUrlMixedView{
    UIImageView *tapImageView;
    UIView *coverView;
    UIWebView *webView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addGesture];
    }
    return self;
}

- (void)addGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self];
    
    for (TBZCoreImageData *data in self.textData.imageArray) {
        //翻转坐标系，因为ImageData中的坐标是CoreText的坐标系
        CGRect imageRect = data.imagePostion;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        
        //检测点击位置Point是否在rect之内
        if (CGRectContainsPoint(rect, point)) {
            //在这里处理点击后的逻辑
            [self showTapImage:data];
            break;
        }
    }
    
    TBZCoreUrlData *urlData = [self touchLinkInView:self atPoint:point data:self.textData];
    if (urlData) {
        [self showUrl:urlData.url];
        return ;
    }
}

- (void)showUrl:(NSString *)url{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    //网页
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    webView.center = keyWindow.center;
    [webView setScalesPageToFit:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
    
    //蒙版
    coverView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    coverView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    coverView.userInteractionEnabled = YES;
    
    [keyWindow addSubview:coverView];
    [keyWindow addSubview:webView];
}

- (void)hide{
    [webView removeFromSuperview];
    [coverView removeFromSuperview];
}

- (void)showTapImage:(TBZCoreImageData *)data{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    //图片
    tapImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:data.name]];
    tapImageView.frame = CGRectMake(0, 0, data.imagePostion.size.width, data.imagePostion.size.height);
    tapImageView.center = keyWindow.center;
    
    
    //蒙版
    coverView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)]];
    coverView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    coverView.userInteractionEnabled = YES;
    
    [keyWindow addSubview:coverView];
    [keyWindow addSubview:tapImageView];
}

- (void)cancel{
    [tapImageView removeFromSuperview];
    [coverView removeFromSuperview];
}

//检测点击位置是否在链接上
- (TBZCoreUrlData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(TBZCoreTextData *)data{
    
    CTFrameRef textFrame = data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines) return nil;
    CFIndex count = CFArrayGetCount(lines);
    TBZCoreUrlData *foundLink = nil;
    
    //获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    //翻转坐标系
    CGAffineTransform tranform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    tranform = CGAffineTransformScale(tranform, 1.f, -1.f);
    for (int i=0; i<count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        //获取每一行的CGRect信息
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, tranform);
        
        if (CGRectContainsPoint(rect, point)) {
            //将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect), point.y-CGRectGetMinY(rect));
            
            //获得当前点击坐标对应的字符串偏移
            CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);
            
            //判断这个偏移是否在我们的链接列表中
            foundLink = [self linkAtIndex:idx linkArray:data.linkArray];
            
            return foundLink;
        }
    }
    return nil;
}

//获取每一行的CGRect信息
- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y, width, height);
}

//判断这个偏移是否在我们的链接列表中
- (TBZCoreUrlData *)linkAtIndex:(CFIndex)i linkArray:(NSArray *)linkArray{
    
    TBZCoreUrlData *link = nil;
    for (TBZCoreUrlData *data in linkArray) {
        if (NSLocationInRange(i, data.range)) {
            link = data;
            break;
        }
    }
    return link;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2.旋转坐坐标系(默认和UIKit坐标是相反的)
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.textData) {
        CTFrameDraw(self.textData.ctFrame, context);
        
        for (TBZCoreImageData *imageData in self.textData.imageArray) {
            
            UIImage *image = [UIImage imageNamed:imageData.name];
            CGContextDrawImage(context, imageData.imagePostion, image.CGImage);
        }
    }
}

@end

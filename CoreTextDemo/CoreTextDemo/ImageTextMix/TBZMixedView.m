//
//  TBZMixedView.m
//  CoreTextDemo
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TBZMixedView.h"
#import "TBZCoreTextData.h"
#import "TBZCoreImageData.h"

@implementation TBZMixedView{
    UIImageView *tapImageView;
    UIView *coverView;
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

//
//  FLImageShowScrollView.m
//  FLImageShowDemo
//
//  Created by fuliang on 16/2/25.
//  Copyright © 2016年 fuliang. All rights reserved.
//

#import "FLImageShowScrollView.h"

@implementation FLImageShowScrollView

#pragma mark--重写
-(void)setChildView:(UIView *)aChildView
{
    
    [_childView removeFromSuperview];
    _childView = aChildView;
    [self addSubview:_childView];
    
    [self setContentOffset:CGPointZero];
    
}

@end

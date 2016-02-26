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

- (void)setContentOffset:(CGPoint)anOffset
{
    if(_childView != nil) {
        CGSize zoomViewSize = _childView.frame.size;
        CGSize scrollViewSize = self.bounds.size;
        
        if(zoomViewSize.width < scrollViewSize.width) {
            anOffset.x = -(scrollViewSize.width - zoomViewSize.width) / 2.0;
        }
        
        if(zoomViewSize.height < scrollViewSize.height) {
            anOffset.y = -(scrollViewSize.height - zoomViewSize.height) / 2.0;
        }
    }
    
    super.contentOffset = anOffset;
}

@end

//
//  FLImageShowCell.h
//  FLImageShowDemo
//
//  Created by fuliang on 16/2/25.
//  Copyright © 2016年 fuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLImageShowScrollView.h"
#define DeviceOrientationKey @"DeviceOrientationKey"

typedef enum : NSUInteger {
    DeviceOrientationVertical,//竖屏
    DeviceOrientationHorizontal,//横屏
} DeviceOrientation;

@interface FLImageShowCell : UICollectionViewCell<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet FLImageShowScrollView *scrollView;
@property (nonatomic,strong)UIImageView *imageView;

/**
 *  本地图片名字
 */
@property (nonatomic,strong)NSString *localImageName;
/**
 *  网络图片url
 */
@property (nonatomic,strong)NSString *netImageUrl;
/**
 *  相册图片url
 */
@property (nonatomic,strong)NSURL *albumImageUrl;
@end

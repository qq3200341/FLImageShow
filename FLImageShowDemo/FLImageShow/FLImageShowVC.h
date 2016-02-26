//
//  FLImageShowVC.h
//  FLImageShowDemo
//
//  Created by fuliang on 16/2/25.
//  Copyright © 2016年 fuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLImageShowVC : UIViewController
/**
 *  本地图片名字数组
 */
@property (nonatomic,strong)NSArray *localImageNamesArray;
/**
 *  网络图片url数组
 */
@property (nonatomic,strong)NSArray *netImageUrlsArray;
/**
 *  相册图片url数组
 */
@property (nonatomic,strong)NSArray *albumImageUrlArray;
/**
 *  当前图片位置，值在0到数组最大值之间
 */
@property (nonatomic,assign)NSInteger currentIndex;
@end

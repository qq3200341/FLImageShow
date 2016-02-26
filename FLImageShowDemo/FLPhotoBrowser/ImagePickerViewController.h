//
//  ImagePickerViewController.h
//  DaGeng
//
//  Created by fu on 15/5/14.
//  Copyright (c) 2015年 fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol ImagePickerViewControllerDelegate;


@interface ImagePickerViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,assign)id<ImagePickerViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic,strong)NSMutableArray *selectAssetArray;
@property (nonatomic,strong)NSMutableArray *thumbnailArray;
@property (nonatomic,strong)NSMutableArray *imageAssetAray;
@property (nonatomic,strong)NSMutableArray *imageUrlArray;
@property (nonatomic,strong)NSMutableArray *selectIndexArray;
@property (nonatomic,assign)BOOL isNotShowSelectBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;

- (IBAction)okBtnClick:(UIButton *)sender;

@end

@protocol ImagePickerViewControllerDelegate <NSObject>
@optional

/**
 *  点击确定的回调
 *
 *  @param assetArray 选中的照片的url数组
 */
- (void)imagePickerViewController: (ImagePickerViewController *)ivc finishClick:(NSArray *)assetArray;

/**
 *  点击任何一张图片的回调
 *
 *  @param asset 点击照片的asset，可通过asset拿到图片(缩略图，高清图，全屏图)和路径
 *  @param index 点击照片所在的位置
 *  @param imageUrlArray 所有照片url
 */
- (void)imagePickerViewController:(ImagePickerViewController *)ivc everyImageClick:(ALAsset *)asset index:(NSInteger)index imageUrlArray:(NSArray *)imageUrlArray;

/**
 *  点击第一张图片（照相机）的回调
 *
 *  @param image 拍照的image
 */
- (void)imagePickerViewController: (ImagePickerViewController *)ivc firstImageClick:(UIImage *)image;


@end

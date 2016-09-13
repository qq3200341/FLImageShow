//
//  ImagePickerViewController.m
//  DaGeng
//
//  Created by fu on 15/5/14.
//  Copyright (c) 2015年 fu. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "MyCollectionViewCell.h"
#import "FLImageShowVC.h"

#define Cellidentifier @"cell"
#define WIDTH(a) [UIScreen mainScreen].bounds.size.width / 320 * a
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ImagePickerViewController ()
{
    ALAssetsLibrary *_assetsLibrary;
    NSMutableArray *_groupArray;
    UILabel *_titleLabel;
    UITableView *_titleTabelView;
    UIView *_titleTableBackgroundView;
    UIImageView *_titleViewImageView;
    UIView *_titleView;
    
}

@end

@implementation ImagePickerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _okBtn.layer.cornerRadius = 15;
    _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    _selectAssetArray = [NSMutableArray array];
    _thumbnailArray = [NSMutableArray array];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:Cellidentifier];
    _imageAssetAray = [NSMutableArray array];
    _imageUrlArray = [NSMutableArray array];
    _selectIndexArray = [NSMutableArray array];
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(WIDTH(92), WIDTH(92));
    layout.minimumLineSpacing = WIDTH(11);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(WIDTH(11), WIDTH(11), WIDTH(11), WIDTH(11));
    _myCollectionView.collectionViewLayout = layout;
    
    [self createTitleTableView];
    [self getAlbumList];
    
    
    //导航栏自定义
    [self leftBarButtonItem:@"返回" image:[UIImage imageNamed:@"ico_arrow_left"] action:@selector(back)];
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_titleLabel];
    _titleViewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.frame.size.width + _titleLabel.frame.origin.x, 17, 10, 10)];
    _titleViewImageView.image = [UIImage imageNamed:@"ico_向下箭头"];
    [_titleView addSubview:_titleViewImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapAction:)];
    [_titleView addGestureRecognizer:tap];
    self.navigationItem.titleView = _titleView;

}


//获取相册列表
- (void)getAlbumList
{
    //获取相册列表
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    _groupArray = [NSMutableArray array];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         
         if (group)
         {
             [_groupArray addObject:group];
             [_titleTabelView reloadData];
             
             NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
             _titleLabel.text = groupName;
             [_titleLabel sizeToFit];
             _titleLabel.center = CGPointMake(_titleView.frame.size.width / 2, 22);
             
             _titleViewImageView.center = CGPointMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width + _titleViewImageView.frame.size.width / 2, _titleViewImageView.center.y);
             
             
         }
         else
         {
             ALAssetsGroup *group = [_groupArray lastObject];
             NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
             [self getImageWithGroup:group name:groupName];
         }
         
     } failureBlock:^(NSError *error)
     {
         NSLog(@"error:%@",error.localizedDescription);
     }];
}

//根据相册获取下面的图片
- (void)getImageWithGroup:(ALAssetsGroup *)group name:(NSString *)name
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //根据相册获取下面的图片
        NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
        if (name && ![name isEqualToString:groupName])
        {
            return;
        }
        
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result) {
                
                [_imageAssetAray addObject:result];
                
                [_thumbnailArray addObject:[UIImage imageWithCGImage:result.thumbnail]];
                
                ALAssetRepresentation *representation = result.defaultRepresentation;
                [_imageUrlArray addObject:representation.url];
                
            }
            if (index == group.numberOfAssets - 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_myCollectionView reloadData];
                });
            }
        }];
    });
    
    
}

#pragma mark--UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageAssetAray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cellidentifier forIndexPath:indexPath];
    cell.imageView.image = nil;
    cell.imageView.backgroundColor = [UIColor clearColor];
    if (_isNotShowSelectBtn)
    {
        cell.selectBtn.hidden = YES;
    }
    else
    {
        cell.selectBtn.hidden = NO;
        cell.selectBtn.selected = NO;
        cell.selectBtn.tag = indexPath.row;
        [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (indexPath.row !=0)
    {
        ALAsset *asset = _imageAssetAray[indexPath.row - 1];
        UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
        cell.imageView.image = image;
        
        for (int i =0; i < _selectIndexArray.count; i++)
        {
            NSString *selectIndex = _selectIndexArray[i];
            if (indexPath.row == [selectIndex integerValue])
            {
                cell.selectBtn.selected = YES;
            }
        }
        
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"ico_相机"];
        cell.selectBtn.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        ALAsset *asset = _imageAssetAray[indexPath.row - 1];
        if ([_delegate respondsToSelector:@selector(imagePickerViewController:everyImageClick:index:imageUrlArray:)])
        {
            [_delegate imagePickerViewController:self everyImageClick:asset index:indexPath.row - 1 imageUrlArray:_imageUrlArray];
        }
    }
    else
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"亲，您的设备不支持照相机功能" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }
}

- (void)titleTapAction:(UITapGestureRecognizer *)tap
{
    CGFloat titleTabelY = _titleTableBackgroundView.frame.origin.y;
    if (titleTabelY <= - SCREENHEIGHT)
    {
        [UIView animateWithDuration:0.5 animations:^{
            _titleTableBackgroundView.frame  =CGRectMake(0, 64, _titleTableBackgroundView.frame.size.width,_titleTableBackgroundView.frame.size.height);
            _titleViewImageView.image = [UIImage imageNamed:@"ico_向上箭头"];
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _titleTableBackgroundView.frame  =CGRectMake(0, - SCREENHEIGHT, _titleTableBackgroundView.frame.size.width,_titleTableBackgroundView.frame.size.height);
            _titleViewImageView.image = [UIImage imageNamed:@"ico_向下箭头"];
        }];
    }
    
}

- (void)createTitleTableView
{
    _titleTableBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT)];
    _titleTableBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _titleTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 300) style:UITableViewStylePlain];
    _titleTabelView.delegate = self;
    _titleTabelView.dataSource  = self;
    _titleTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_titleTableBackgroundView];
    [_titleTableBackgroundView addSubview:_titleTabelView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = Cellidentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    ALAssetsGroup *group = _groupArray[_groupArray.count - indexPath.row - 1];
    cell.textLabel.text = [NSString stringWithFormat:@"%@（%ld）",[group valueForProperty:ALAssetsGroupPropertyName],(long)group.numberOfAssets];
    cell.imageView.image = [UIImage imageWithCGImage:group.posterImage];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_selectAssetArray removeAllObjects];
    [_selectIndexArray removeAllObjects];
    ALAssetsGroup *group = _groupArray[_groupArray.count - indexPath.row - 1];
    _titleLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(_titleView.frame.size.width / 2, 22);
    
    _titleViewImageView.center = CGPointMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width + _titleViewImageView.frame.size.width / 2, _titleViewImageView.center.y);
    
    [_imageAssetAray removeAllObjects];
    [_imageUrlArray removeAllObjects];
    [self getImageWithGroup:group name:_titleLabel.text];
    [UIView animateWithDuration:0.5 animations:^{
        
        _titleTableBackgroundView.frame  =CGRectMake(0, - SCREENHEIGHT, _titleTableBackgroundView.frame.size.width, _titleTableBackgroundView.frame.size.height);
        _titleViewImageView.image = [UIImage imageNamed:@"ico_向下箭头"];
    }];
}


- (void)selectBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [_myCollectionView indexPathForCell:cell];
    ALAsset *asset = _imageAssetAray[indexPath.row - 1];
    
    if (btn.selected)
    {
        [_selectAssetArray addObject:asset];
        [_selectIndexArray addObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }
    else
    {
        [_selectAssetArray removeObject:asset];
        [_selectIndexArray removeObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }
    
    if (_selectAssetArray.count == 0)
    {
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    else
    {
        [_okBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)[_selectAssetArray count]] forState:UIControlStateNormal];
    }
    NSLog(@"%@",_selectIndexArray);
    NSLog(@"%@",_selectAssetArray);
    
}


- (void)leftBarButtonItem:(NSString *)titles image:(UIImage *)image action:(SEL)action
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = image;
    CGSize imgSize = image.size;
    imageView.frame = CGRectMake(0, 0, imgSize.width, imgSize.height);
    imageView.center = CGPointMake(imageView.center.x,22);
    [view addSubview:imageView];
    
    UILabel *lbl = [UILabel new];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:16];
    lbl.text = titles;
    CGSize lblSize = [lbl sizeThatFits:lbl.frame.size];
    lbl.frame = CGRectMake(imgSize.width + 5, 0, lblSize.width, lblSize.height);
    lbl.center = CGPointMake(lbl.center.x, 22);
    [view addSubview:lbl];
    view.frame = CGRectMake(0, 0, 44, 44.0f);
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *handle = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [view addGestureRecognizer:handle];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}


- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (IBAction)okBtnClick:(UIButton *)sender
{
    NSLog(@"确定");
    if ([_delegate respondsToSelector:@selector(imagePickerViewController:finishClick:)])
    {
        [_delegate imagePickerViewController:self finishClick:_selectAssetArray];
    }
    
}

#pragma mark--UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([_delegate respondsToSelector:@selector(imagePickerViewController:firstImageClick:)])
        {
            [_delegate imagePickerViewController:self firstImageClick:image];
        }
    }];
    
}
@end

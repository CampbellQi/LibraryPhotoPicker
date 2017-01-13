//
//  WQCombinationPickerViewController.m
//  testPhotoLib
//
//  Created by fengwanqi on 15/12/9.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import "WQCombinationPickerViewController.h"
#import "WQCollectionViewCell.h"
#import "WQMenuView.h"

@interface WQCombinationPickerViewController ()<WQMenuViewDelegate>
{
    NSMutableArray *_selectedArray;
    NSMutableArray *_selectedNameArray;
    UIImage *_selectedImage;
    NSString *_name;
}
@end

@implementation WQCombinationPickerViewController

- (id)initWithCombinationPickerNib
{
    self = [super initWithNibName:NSStringFromClass([WQCombinationPickerViewController class]) bundle:nil];
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.doneButton.layer.cornerRadius = 4.0f;
    _selectedArray = [NSMutableArray new];
    _selectedNameArray = [NSMutableArray new];
    if (self.cameraImage == nil) {
        self.cameraImage = [UIImage imageNamed:@"camera-icon"];
    }
    
    UINib *cellNib = [UINib nibWithNibName:
                      NSStringFromClass([WQCollectionViewCell class])
                                    bundle:nil];
    
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:CellIdentifier];
    
    if (self.assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    if (self.groups == nil) {
        _groups = [[NSMutableArray alloc] init];
    } else {
        [self.groups removeAllObjects];
    }
    
    if (!self.assets) {
        _assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets insertObject:result atIndex:0];
        }
        
        if ([self.assetsGroup numberOfAssets] - 1 == index) {
            [self addImageFirstRow];
            [self.collectionView reloadData];
            
        }
    };
    
    __block long maxCount = 0;
    __block ALAssetsGroup *maxGroup = nil;
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            
            [self.groups addObject:group];
            
            if ([group numberOfAssets] >= maxCount) {
                maxCount = [group numberOfAssets];
                if (maxGroup) {
                    long index1 = [self.groups indexOfObject:group];
                    long index2 = [self.groups indexOfObject:maxGroup];
                    [self.groups exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
                }
                
                maxGroup = group;
            }
            
            NSString *name = [maxGroup valueForProperty:ALAssetsGroupPropertyName];
            //            if ([name isEqualToString:@"Camera Roll"]) {
            //                name = NSLocalizedString(name, nil);
            //            }
            //NSLog(@"name = %@", name);
            self.assetsGroup = maxGroup;
            _name = name;
            
            
            //if (self.assets.count == 0) {
            
            
            
            
            
            //}
            
            
            
            
            
            
        }else if (group == nil) {
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [self.assetsGroup setAssetsFilter:onlyPhotosFilter];
            [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
            
            [self addImageFirstRow];
            
            if ([WQMenuView getSystemLibGroupName:[maxGroup valueForProperty:ALAssetsGroupPropertyType]]) {
                _name = [WQMenuView getSystemLibGroupName:[maxGroup valueForProperty:ALAssetsGroupPropertyType]];
            }
            [self setNavigationTitle:[NSString stringWithFormat:@"%@(%ld)", _name, [maxGroup numberOfAssets]]];
        }
        
    };
    
    
    
    // enumerate only photos
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos | ALAssetsGroupPhotoStream;
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        NSLog(@"Can not get group");
    }];
    
    
    
    
    
    [self checkDoneButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!previousBarStyle) {
        previousBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    }
    
    isHideNavigationbar = self.navigationController.isNavigationBarHidden;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self fadeStatusBar];
    [self setLightStatusBar];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self reStoreNavigationBar];
    [self fadeStatusBar];
    [self setBackStatusBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WQCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ALAsset *asset;
    CGImageRef thumbnailImageRef;
    UIImage *thumbnail;
    
    if ([self.assets[indexPath.row] isKindOfClass:[UIImage class]]) {
        
        thumbnail = self.assets[indexPath.row];
        
    } else {
        asset = self.assets[indexPath.row];
        thumbnailImageRef = [asset thumbnail];
        thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
        
    }
    
    cell.imageView.image = thumbnail;
    
    NSString *str = [NSString stringWithFormat:@"%@%ld", _name, indexPath.row];
    if ([_selectedNameArray indexOfObject:str] != NSNotFound) {
        [cell showSelectedIV];
    }else{
        [cell hideSelectedIV];
    }
    //如果第一张图，调起相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] && indexPath.row == 0) {
        cell.selBtn.hidden = YES;
    }else {
        cell.selBtn.hidden = NO;
    }
    //单选时候
    if (!_maxSelCount || _maxSelCount == 0) {
        cell.selBtn.hidden = YES;
    }
    //BOOL isSelected = [indexPath isEqual:currentSelectedIndex];
    //BOOL isDeselectedShouldAnimate = currentSelectedIndex == nil && [indexPath isEqual:previousSelectedIndex];
    
    //[cell setHightlightBackground:isSelected withAimate:isDeselectedShouldAnimate];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        
        //previousSelectedIndex = nil;
        //currentSelectedIndex = nil;
        
        if (self.cameraController != nil) {
            
            id delegate;
            if ([self.cameraController valueForKey:@"delegate"]) {
                delegate = [self.cameraController valueForKey:@"delegate"];
            }
            
            NSData *tempArchiveViewController = [NSKeyedArchiver archivedDataWithRootObject:self.cameraController];
            UIViewController *cameraVC = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchiveViewController];
            
            if (delegate && delegate != nil) {
                [cameraVC setValue:delegate forKey:@"delegate"];
            }
            
            [self presentViewController:cameraVC animated:YES completion:NULL];
        } else {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
            
        }
        
    } else {
        WQCollectionViewCell *cell = (WQCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        ALAsset *asset;
        CGImageRef thumbnailImageRef;
        UIImage *thumbnail;
        if ([self.assets[indexPath.row] isKindOfClass:[UIImage class]]) {
            thumbnail = self.assets[indexPath.row];
        } else {
            asset = self.assets[indexPath.row];
            thumbnailImageRef = [asset aspectRatioThumbnail];
            //[asset.defaultRepresentation fullResolutionImage];
            thumbnail = [UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage]];
            
        }
        
        if (!_maxSelCount || _maxSelCount == 0) {
            _selectedImage = thumbnail;
            [self done:nil];
        }else if (_selectedArray.count >= _maxSelCount && cell.selBtn.selected == NO) {
            
        }else {
            NSString *str = [NSString stringWithFormat:@"%@%ld", _name, indexPath.row];
            if (cell.selBtn.selected) {
                [cell hideSelectedIV];
                long index = [_selectedNameArray indexOfObject:str];
                [_selectedNameArray removeObjectAtIndex:index];
                [_selectedArray removeObjectAtIndex:index];
                //[_selectedArray removeObject:thumbnail];
                
            }else {
                [cell showSelectedIV];
                [_selectedArray addObject:thumbnail];
                [_selectedNameArray addObject:str];
            }
            
            [self checkDoneButton];
        }
        
        //        previousSelectedIndex = currentSelectedIndex;
        //
        //        if ([currentSelectedIndex isEqual:indexPath] ) {
        //
        //            currentSelectedIndex = nil;
        //
        //        } else {
        //
        //            currentSelectedIndex = indexPath;
        //
        //        }
        
    }
    
    //[self.collectionView reloadData];
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float width = (CGRectGetWidth(self.view.frame) - 3.0)/4.0;
    NSLog(@"%f", width);
    return CGSizeMake(width,width);
}
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)changeGroup:(ALAssetsGroup *)aGroup
{
    for (ALAssetsGroup *group in self.groups) {
        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:[aGroup valueForProperty:ALAssetsGroupPropertyName]]) {
            self.assetsGroup = group;
            
            ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result) {
                    
                    [self.assets insertObject:result atIndex:0];
                    
                }
            };
            
            if (!self.assets) {
                _assets = [[NSMutableArray alloc] init];
            } else {
                [self.assets removeAllObjects];
            }
            
            [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
            
            [self addImageFirstRow];
            
            [self.collectionView reloadData];
            
            NSString *name = [aGroup valueForProperty:ALAssetsGroupPropertyName];
            //            if ([name isEqualToString:@"Camera Roll"]) {
            //                name = @"相机胶卷";
            //            }
            _name = name;
            if ([WQMenuView getSystemLibGroupName:[aGroup valueForProperty:ALAssetsGroupPropertyType]]) {
                _name = [WQMenuView getSystemLibGroupName:[aGroup valueForProperty:ALAssetsGroupPropertyType]];
            }
            [self setNavigationTitle:[NSString stringWithFormat:@"%@(%ld)", _name, [[self.groups firstObject] numberOfAssets]]];
        }
    }
    
    //currentSelectedIndex = nil;
}


- (void)addImageFirstRow
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        if (![self.assets containsObject:self.cameraImage]) {
            [self.assets insertObject:self.cameraImage atIndex:0];
        }
    }
}


- (void)setNavigationTitle:(NSString *)title
{
    [self.navagationTitleButton setTitle:[NSString stringWithFormat:@"%@ ▾", title] forState:UIControlStateNormal];
    
}

- (void)checkDoneButton
{
    if (!_maxSelCount || _maxSelCount == 0) {
        //单选
        self.doneButton.hidden = YES;
    }else {
        NSString *title = [NSString stringWithFormat:@"%完成(%d/%d)", _selectedNameArray.count, _maxSelCount];
        [self.doneButton setTitle:title forState:UIControlStateNormal];
    }
    //    if (currentSelectedIndex != nil) {
    //
    //        [self.doneButton setEnabled:YES];
    //
    //    } else {
    //
    //        [self.doneButton setEnabled:NO];
    //
    //    }
}

#pragma mark - action

- (IBAction)showMenu:(UIView *)sender
{
    [WQMenuView showMenuInView:self.view FromRect:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 1) LibArray:self.groups Delegate:self];
    //    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    //
    //    for (ALAssetsGroup *group in self.groups) {
    //
    //        [menuItems addObject:[KxMenuItem menuItem:[group valueForProperty:ALAssetsGroupPropertyName]
    //                                            image:nil
    //                                           target:self
    //                                           action:@selector(changeGroup:)]];
    //    }
    //
    //    if (menuItems.count) {
    //        [KxMenu showMenuInView:self.view
    //                      fromRect:sender.frame
    //                     menuItems:menuItems];
    //    }
}


- (IBAction)done:(id)sender
{
    if (!_maxSelCount && _maxSelCount == 0) {
        //单选
        if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImage:)]){
            [self.delegate imagePickerController:self didFinishPickingImage:_selectedImage];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImageArray:)]){
            [self.delegate imagePickerController:self didFinishPickingImageArray:_selectedArray];
        }
    }
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    //    if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImage:)]) {
    //        ALAsset *asset = self.assets[currentSelectedIndex.row];
    //        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    //        CGImageRef imgRef = [assetRep fullResolutionImage];
    //        UIImage *img = [UIImage imageWithCGImage:imgRef
    //                                           scale:assetRep.scale
    //                                     orientation:(UIImageOrientation)assetRep.orientation];
    //        [self.delegate imagePickerController:self didFinishPickingImage:img];
    //    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImage:)]) {
        [self.delegate imagePickerController:self didFinishPickingImage:originImage];
    }
    
    
    //        return;
    //        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    //        [library writeImageToSavedPhotosAlbum:originImage.CGImage
    //                                     metadata:[info objectForKey:UIImagePickerControllerMediaMetadata]
    //                              completionBlock:^(NSURL *assetURL, NSError *error) {
    //
    //                                  [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
    //                                      [picker dismissViewControllerAnimated:NO completion:nil];
    //                                      [self.delegate imagePickerController:self didFinishPickingi];
    //
    //                                  } failureBlock:^(NSError *error) {
    //
    //                                      NSLog(@"error couldn't get photo");
    //
    //                                  }];
    //
    //                              }];
    
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //    if ([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
    //        [self.delegate imagePickerControllerDidCancel:self];
    //    }
}

#pragma mark - Status bar

- (void)fadeStatusBar
{
    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
        
        // need to animate
        //        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)setLightStatusBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setBackStatusBar
{
    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:previousBarStyle];
        [self setNeedsStatusBarAppearanceUpdate];
        
    }
}

- (void)reStoreNavigationBar
{
    [self.navigationController setNavigationBarHidden:isHideNavigationbar animated:NO];
}

@end

//
//  WQCombinationPickerViewController.h
//  testPhotoLib
//
//  Created by fengwanqi on 15/12/9.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//




#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

static NSString *CellIdentifier = @"photoCell";

@protocol WQCombinationPickerViewControllerDelegate;

@interface WQCombinationPickerViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL isHideNavigationbar;
    UIStatusBarStyle previousBarStyle;
    //NSIndexPath *currentSelectedIndex;
    //NSIndexPath *previousSelectedIndex;
}
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) UIImage *cameraImage;
@property (nonatomic, strong) UIViewController *cameraController;

@property (nonatomic, assign)long maxSelCount;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIView *navigationView;
@property (nonatomic, strong) IBOutlet UIButton *navagationTitleButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *doneButton;

@property (nonatomic, weak) id<WQCombinationPickerViewControllerDelegate> delegate;

- (void)fadeStatusBar;
- (id)initWithCombinationPickerNib;

@end

@protocol WQCombinationPickerViewControllerDelegate <NSObject>

@optional

- (void)imagePickerController:(WQCombinationPickerViewController *)picker didFinishPickingImage:(UIImage *)image;
- (void)imagePickerController:(WQCombinationPickerViewController *)picker didFinishPickingImageArray:(NSArray *)images;
- (void)imagePickerControllerDidCancel:(WQCombinationPickerViewController *)picker;

@end

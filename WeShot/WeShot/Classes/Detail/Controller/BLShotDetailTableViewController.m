//
//  BLDetailTableViewController.m
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLShotDetailTableViewController.h"
#import "BLDetailCommentCell.h"
#import "BLDetailNoCommentCell.h"
#import "BLShot.h"
#import "BLShotComment.h"
#import "BLShotsTool.h"
#import "BLShotsParams.h"
#import "BLDribbbleAPI.h"
#import "BLDetailHeaderView.h"

#import "NSString+BLExtension.h"
#import "BLProfileViewController.h"

#import <DALabeledCircularProgressView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <YLGIFImage.h>
#import <YLImageView.h>

@interface BLShotDetailTableViewController ()

@property (weak,nonatomic) BLDetailHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray* comments;
@property (nonatomic, weak) UIScrollView* scrollView;

@end

@implementation BLShotDetailTableViewController{
    BOOL isDrag;
}

static NSString* headerViewID = @"BLDetailHeaderView";
static NSString* commentCellID = @"BLDetailCommentCell";
static NSString* noCommentCellID = @"BLDetailNoCommentCell";

- (NSMutableArray*)comments {
    if (_comments == nil) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self loadAllComments];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"view will Appear");
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    NSLog(@"view will layout");
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"lauout subview");
    if (!isDrag) {
        self.scrollView.contentOffset = CGPointMake(0, -self.headerView.height - 80);
    }
}

#pragma mark Delegate Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = scrollView;
    }
    NSLog(@"offset %f, %f", scrollView.contentOffset.y, self.headerView.height + 80);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"begin drag");
    isDrag = YES;
}

- (void) setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BLGlobalBg;
    self.navigationItem.title = @"SHOT";
    //add Header View
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:headerViewID owner:nil options:nil];
    BLDetailHeaderView *headerView = [nibView firstObject];
    _headerView = headerView;
    [self setupheaderViewContent];
    CGFloat headerHeight = [self headerHeight];
    
    headerView.frame = CGRectMake(0, -headerHeight-36, ScreenSize.width, headerHeight);
    [self.tableView addSubview:headerView];
    //[self.tableView insertSubview:_headerView atIndex:0];
    self.tableView.contentInset = UIEdgeInsetsMake(headerHeight+36, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, 100);
}

- (CGFloat)headerHeight{
    UIFont *titleFont = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
    UIFont *detailFont = [UIFont fontWithName:@"Kailasa" size:14.0f];
    
    CGFloat shotImageHeight = ScreenSize.width*3/4;
    CGFloat titleHeight = [self.shot.title boundingRectWithSize:CGSizeMake(ScreenSize.width-16, MAXFLOAT) font:titleFont lineSpacing:0 maxLines:INT_MAX];
    CGFloat detailHeight = [self.shot.detailContent boundingRectWithSize:CGSizeMake(ScreenSize.width-16, MAXFLOAT) font:detailFont lineSpacing:0 maxLines:INT_MAX];
    
    return 8 + 35 + 8 + shotImageHeight + 16 + titleHeight + 16 + detailHeight + 30 + 36;
}
- (void)setupheaderViewContent {
    _headerView.username.text = self.shot.user.username;
    NSString* shotImageURLStr = self.shot.images.hidpi?self.shot.images.hidpi:self.shot.images.normal;
    NSString* avatorImageUrlStr = self.shot.user.avatar_url;
    NSString* locationTitle = self.shot.user.location ? self.shot.user.location : @"unknow";
    [_headerView.location setTitle:locationTitle forState:UIControlStateNormal];
    
    if (self.shot.animated) {
        _headerView.shotImage.hidden = YES;
        _headerView.GifImageView.hidden = NO;
        _headerView.progressView.hidden = NO;
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:shotImageURLStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //NSLog(@"receive size %zd",receivedSize);
            [_headerView.progressView setProgress:1.0*receivedSize/expectedSize animated:YES];
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _headerView.progressView.hidden = YES;
                _headerView.GifImageView.image = [YLGIFImage imageWithData:data];
            });
        }];
        
    } else {
        _headerView.shotImage.hidden = NO;
        _headerView.GifImageView.hidden = YES;
        [_headerView.shotImage sd_setImageWithURL:[NSURL URLWithString:shotImageURLStr] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            _headerView.progressView.hidden = NO;
            [_headerView.progressView setProgress:1.0*receivedSize/expectedSize animated:YES];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _headerView.progressView.hidden = YES;
            
        }];
    }
    
    [_headerView.headImgView sd_setImageWithURL:[NSURL URLWithString:avatorImageUrlStr]
                        placeholderImage:nil];
    _headerView.shotTitle.text = self.shot.title;
    _headerView.shotdetail.text = self.shot.detailContent;
    
    
    
    
    _headerView.shotInfo.text = [NSString stringWithFormat:@"%zd comments    %zd views    %zd likes",self.shot.comments_count, self.shot.views_count, self.shot.likes_count];
    [_headerView.headBtn addTarget:self action:@selector(headerBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void) loadAllComments{
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    NSString* pageStr = @"page=1&per_page=99";
    
    [BLShotsTool commentWithURLStr:self.shot.comments_url Params:params pageStr:pageStr Success:^(NSArray *shotsArray) {
        [self.comments addObjectsFromArray:shotsArray];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"comment:%@",error.localizedDescription);
    }];
}





#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count ?: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Comment cell
    if (self.comments.count == 0) {
        BLDetailNoCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:noCommentCellID];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:noCommentCellID owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    }
    
    BLDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:commentCellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    BLShotComment* comment = self.comments[indexPath.row];
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:comment.user.avatar_url] placeholderImage:nil];
    cell.username.text = comment.user.username;
    cell.comment.text = comment.body;
    return cell;
}

- (void)headerBtn{
    BLProfileViewController* vc = [[BLProfileViewController alloc]init];
    vc.user = self.shot.user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //if (indexPath.row == 0) {
      //  return self.shot.detailCellHeight;
    //}
    if (self.comments.count == 0) {
        return 30;
    }
    BLShotComment* shotComent = self.comments[indexPath.row];
    return shotComent.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    // Dispose of any resources that can be recreated.
}

@end

//
//  BLDetailTableViewController.m
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLShotDetailTableViewController.h"
#import "BLDetailContentCell.h"
#import "BLDetailCommentCell.h"
#import "BLShot.h"
#import "BLShotComment.h"
#import "BLShotsTool.h"
#import "BLShotsParams.h"
#import "BLDribbbleAPI.h"

#import "NSString+BLExtension.h"

#import "BLProfileViewController.h"

#import <DALabeledCircularProgressView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <YLGIFImage.h>
#import <YLImageView.h>

@interface BLShotDetailTableViewController ()

@property (nonatomic, strong) NSMutableArray* comments;

@end

@implementation BLShotDetailTableViewController

static NSString* headercellID = @"BLDetailContentCell";
static NSString* commentCellID = @"BLDetailCommentCell";

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

- (void) setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BLGlobalBg;
    self.navigationItem.title = @"SHOT";
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
    return self.comments.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BLDetailContentCell* cell = [tableView dequeueReusableCellWithIdentifier:headercellID];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:headercellID owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.username.text = self.shot.user.username;
        NSString* shotImageURLStr = self.shot.images.hidpi?self.shot.images.hidpi:self.shot.images.normal;
        NSString* avatorImageUrlStr = self.shot.user.avatar_url;
        NSString* locationTitle = self.shot.user.location ? self.shot.user.location : @"unknow";
        [cell.location setTitle:locationTitle forState:UIControlStateNormal];
        
        if (self.shot.animated) {
            cell.shotImage.hidden = YES;
            cell.GifImageView.hidden = NO;
            cell.progressView.hidden = NO;
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:shotImageURLStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                NSLog(@"receive size %zd",receivedSize);
                [cell.progressView setProgress:1.0*receivedSize/expectedSize animated:YES];
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                cell.progressView.hidden = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.GifImageView.image = [YLGIFImage imageWithData:data];
                });
            }];
            
        } else {
            cell.shotImage.hidden = NO;
            cell.GifImageView.hidden = YES;
            [cell.shotImage sd_setImageWithURL:[NSURL URLWithString:shotImageURLStr] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                cell.progressView.hidden = NO;
                [cell.progressView setProgress:1.0*receivedSize/expectedSize animated:YES];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                cell.progressView.hidden = YES;
                
            }];
        }
        
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:avatorImageUrlStr]
                            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.shotTitle.text = self.shot.title;
        cell.shotdetail.text = self.shot.detailContent;
        
        
        
        
        cell.shotInfo.text = [NSString stringWithFormat:@"%zd comments    %zd views    %zd likes",self.shot.comments_count, self.shot.views_count, self.shot.likes_count];
        [cell.headBtn addTarget:self action:@selector(headerBtn) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    //Comment cell
    
    BLDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:commentCellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    BLShotComment* comment = self.comments[indexPath.row-1];
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
    if (indexPath.row == 0) {
        return self.shot.detailCellHeight;
    }
    BLShotComment* shotComent = self.comments[indexPath.row-1];
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

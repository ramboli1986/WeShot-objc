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

#import <SDWebImage/UIImageView+WebCache.h>

@interface BLShotDetailTableViewController ()

@end

@implementation BLShotDetailTableViewController

static NSString* headercellID = @"BLDetailContentCell";
static NSString* commentCellID = @"BLDetailCommentCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    
    
}

- (void) setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BLGlobalBg;
    self.navigationItem.title = @"SHOT";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + 6;
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
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:avatorImageUrlStr]
                            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [cell.shotImage sd_setImageWithURL:[NSURL URLWithString:shotImageURLStr]
                          placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [cell.location setTitle:self.shot.user.location forState:UIControlStateNormal];
        
        cell.shotTitle.text = self.shot.title;
        cell.shotdetail.text = self.shot.detailContent;
        cell.shotInfo.text = [NSString stringWithFormat:@"%zd comments    %zd views    %zd likes",self.shot.comments_count, self.shot.views_count, self.shot.likes_count];
        return cell;
    }
    BLDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:commentCellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.shot.detailCellHeight;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

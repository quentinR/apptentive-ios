//
//  ATTextMessageCellV7.m
//  ApptentiveConnect
//
//  Created by Andrew Wooster on 12/4/13.
//  Copyright (c) 2013 Apptentive, Inc. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "ATTextMessageCellV7.h"
#import "ATBackend.h"
#import "ATMessageSender.h"

@implementation ATTextMessageCellV7
- (void)setup {
	NSMutableAttributedString *s = [[NSMutableAttributedString alloc] init];
	if (self.message.body) {
		NSDictionary *attrs = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
		NSAttributedString *body = [[[NSAttributedString alloc] initWithString:self.message.body attributes:attrs] autorelease];
		[s appendAttributedString:body];
	}
	self.messageLabel.attributedText = s;
	[s release], s = nil;
	
	self.textContainerView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
	self.textContainerView.layer.cornerRadius = 10;
	
	self.userIconView.image = [ATBackend imageNamed:@"at_mc_user_icon"];
	self.userIconView.imageURL = [NSURL URLWithString:self.message.sender.profilePhotoURL];
	self.userIconView.layer.cornerRadius = self.userIconView.bounds.size.width*0.5;
	self.userIconView.layer.masksToBounds = YES;
	
	self.messageLabel.delegate = self;
	UIDataDetectorTypes types = UIDataDetectorTypeLink;
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
		types |= UIDataDetectorTypePhoneNumber;
	}
	self.messageLabel.dataDetectorTypes = types;
	self.arrowView.direction = self.arrowDirection;
	self.arrowView.color = self.textContainerView.backgroundColor;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		//        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	//	[self setup];
}

- (void)prepareForReuse {
	[super prepareForReuse];
	self.userIconOffsetConstraint.constant = 4;
	self.message = nil;
}

- (void)dealloc {
	[_textContainerView release];
	[_messageLabel release];
	[_userIconView release];
	if (_userIconOffsetConstraint) {
		[_userIconOffsetView removeConstraint:_userIconOffsetConstraint];
	}
	[_userIconOffsetView release];
	[_userIconOffsetConstraint release];
	[_arrowView release];
	[super dealloc];
}

- (void)setMessage:(ATTextMessage *)message {
	if (_message != message) {
		[_message release], _message = nil;
		_message = [message retain];
		
		[self setup];
	}
}

- (void)collection:(UICollectionView *)collectionView didScroll:(CGFloat)topOffset {
	CGRect iconInset = [collectionView convertRect:self.frame fromView:self.superview];
	iconInset.origin.y += topOffset - 1;
	iconInset.origin.y += CGRectGetMaxY(self.dateLabel.bounds);
	
	CGFloat minOffset = 4;
	CGFloat minBottomOffset = 16;
	CGFloat maxOffset = CGRectGetHeight(self.bounds) - CGRectGetHeight(self.userIconView.bounds) - minBottomOffset - CGRectGetMinY(self.userIconOffsetView.frame);
	CGFloat iconInsetY = -CGRectGetMinY(iconInset);
	CGFloat newValue = MAX(minOffset, MIN(maxOffset, iconInsetY));
	self.userIconOffsetConstraint.constant = newValue;
}

#pragma mark TTTAttributedLabelDelegate
- (void)attributedLabel:(ATTTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
	if ([[UIApplication sharedApplication] canOpenURL:url]) {
		[[UIApplication sharedApplication] openURL:url];
	}
}

- (void)attributedLabel:(TTTATTRIBUTEDLABEL_PREPEND(TTTAttributedLabel) *)label
didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
	NSString *phoneString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
	NSURL *url = [NSURL URLWithString:phoneString];
	if ([[UIApplication sharedApplication] canOpenURL:url]) {
		[[UIApplication sharedApplication] openURL:url];
	}
}
@end

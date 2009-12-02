//
//  AMOptionPopUpButtonCell.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski  on 7/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AMOptionPopUpButtonCell.h"

#import "AMOptionMenuController.h"


@interface AMOptionPopUpButtonCell ()
- (void) updateMenu;
@end


@implementation AMOptionPopUpButtonCell

@synthesize optionMenuController = _optionMenuController;


- (void) configure
{
	[self setPullsDown:YES];
	[self setAutoenablesItems:NO];
	[self setAlignment:NSCenterTextAlignment];
	[self setArrowPosition:NSPopUpArrowAtBottom];
	[self setAltersStateOfSelectedItem:NO];
	[self setUsesItemFromMenu:NO];
		
	NSMenuItem* titleItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
	[self setMenuItem:titleItem];
	[titleItem release];
}


- (id) init
{
	self = [super initTextCell:@"" pullsDown:YES];
	if( self )
	{
		[self configure];
	}
	return self;
}


- (id) initTextCell:(NSString*)stringValue pullsDown:(BOOL)pullDown
{
	return [self init];
}


- (void) awakeFromNib
{
	[self configure];
}


- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_optionMenuController release];
	[super dealloc];
}


- (BOOL) pullsDown
{
	return YES;
}


- (void)setPullsDown:(BOOL)flag
{
	NSAssert( flag, @"must put pull down to operate correctly" );
	[super setPullsDown:flag];
}


- (void) setOptionMenuController:(AMOptionMenuController*)controller
{
	if( controller == _optionMenuController )
		return;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kAMOptionMenuContentDidChange object:_optionMenuController];
	
	[controller retain];
	[_optionMenuController release];
	_optionMenuController = controller;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(optionsChanged:) name:kAMOptionMenuContentDidChange object:_optionMenuController];
	
	[self updateMenu];
}


- (void) optionsChanged:(NSNotification*) note
{
	[self updateMenu];
}


- (void) updateMenu
{
	NSMenu* newMenu = [[NSMenu alloc] initWithTitle:@""];
	[newMenu setAutoenablesItems:NO];
	[[self optionMenuController] insertItemsInMenu:newMenu atIndex:0];
	[newMenu insertItemWithTitle:@"dummy" action:nil keyEquivalent:@"" atIndex:0];
	[self setMenu:newMenu];
	[newMenu release];
}

@end

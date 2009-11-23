//
//  AMOptionPopUpButtonCell.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski  on 7/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AMOptionPopUpButtonCell.h"

#import "AMOptionMenuDataSource.h"


@interface AMOptionPopUpButtonCell ()
- (void) updateMenu;
@end


@implementation AMOptionPopUpButtonCell

@synthesize optionMenuDataSource = _optionMenuDataSource;


- (void) configure
{
	[self setPullsDown:YES];
	[self setAutoenablesItems:NO];
	[self setAlignment:NSCenterTextAlignment];
	[self setArrowPosition:NSPopUpArrowAtBottom];
	[self setAltersStateOfSelectedItem:NO];
	[self setUsesItemFromMenu:NO];
		
	NSMenuItem* titleItem = [[NSMenuItem alloc] initWithTitle:@"(No Data Source)" action:nil keyEquivalent:@""];
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
	[_optionMenuDataSource release];
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


- (void) setOptionMenuDataSource:(AMOptionMenuDataSource*)dataSource
{
	if( dataSource == _optionMenuDataSource )
		return;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kAMOptionMenuDataDidChange object:_optionMenuDataSource];
	
	[dataSource retain];
	[_optionMenuDataSource release];
	_optionMenuDataSource = dataSource;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(optionsChanged:) name:kAMOptionMenuDataDidChange object:_optionMenuDataSource];
	
	[self updateMenu];
	
}


- (void) optionsChanged:(NSNotification*) note
{
	[self updateMenu];
}


- (void) updateMenu
{
	NSMenu* newMenu = [[self optionMenuDataSource] createMenuWithTitle:@""];
	[newMenu insertItemWithTitle:@"dummy" action:nil keyEquivalent:@"" atIndex:0];
	[self setMenu:newMenu];
}

@end

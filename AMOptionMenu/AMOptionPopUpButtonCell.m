//
//  AMOptionPopUpButtonCell.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski  on 7/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AMOptionPopUpButtonCell.h"

#import "AMOptionMenuDataSource.h"

@implementation AMOptionPopUpButtonCell

@synthesize dataSource = _dataSource;


- (void) configure
{
	[self setPullsDown:YES];
	[self setAutoenablesItems:NO];
	[self setAlignment:NSCenterTextAlignment];
	[self setArrowPosition:NSPopUpArrowAtBottom];
	[self setAltersStateOfSelectedItem:NO];
	[self setUsesItemFromMenu:NO];
	
	[[self menu] setTitle:kAMOptionPopUpButtonTitle];  // TODO: a little hacky...
	
	[self removeAllItems];
	
	NSMenuItem* titleItem = [[NSMenuItem alloc] initWithTitle:@"(No Data Source)" action:nil keyEquivalent:@""];
	[self setMenuItem:titleItem];
	[titleItem release];
	
	NSDictionary* titleBindingOptions = [NSDictionary dictionaryWithObjectsAndKeys:
										 @"(no data)", NSNullPlaceholderBindingOption,
										 nil];
	[self bind:@"title" toObject:self withKeyPath:@"dataSource.summaryString" options:titleBindingOptions];
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
	[_dataSource release];
	[super dealloc];
}


- (BOOL) pullsDown
{
	return YES;
}


- (void)setPullsDown:(BOOL)flag
{
//	NSAssert( flag, @"must put pull down to operate correctly" );
//	[super setPullsDown:flag];
}


- (void) setDataSource:(AMOptionMenuDataSource*)dataSource
{
	[dataSource retain];
	[_dataSource release];
	_dataSource = dataSource;
	
	[[self menu] setDelegate:_dataSource];
	
}


- (void)synchronizeTitleAndSelectedItem
{
	// TODO: NOTE: why this is needed
}


@end

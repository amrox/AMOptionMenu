//
//  AMOptionPopUpButtonCell.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski  on 7/10/09.
//  Copyright 2009 The Neat Company. All rights reserved.
//

#import "AMOptionPopUpButtonCell.h"

#import "AMOptionMenu.h"

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
	
	[[self menu] setTitle:kAMOptionPopUpButtonTitle];
	
	NSMenuItem *summaryItem = [[NSMenuItem alloc] initWithTitle:@"(No Data Source)" action:nil keyEquivalent:@""];
	//[summaryItem setEnabled:NO];		
	[self setMenuItem:summaryItem];
	[summaryItem release];
	
	[self removeAllItems];
	
//	while( [[[self menu] itemArray] count] )
//	{
//		[[self menu] removeItemAtIndex:0];
//	}
	
//	if( ![self dataSource] )
//	{
//		NSMenuItem *summaryItem = [[NSMenuItem alloc] initWithTitle:@"(No Data Source)" action:nil keyEquivalent:@""];
//		[summaryItem setEnabled:NO];		
//		[[self menu] insertItem:summaryItem atIndex:0];
//		[summaryItem release];
//	}	
}


- (id) init
{
	self = [super initTextCell:@"(No Data Source)" pullsDown:YES];
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
	
	//	NSMenuItem* summaryItem = [[[self menu] itemArray] objectAtIndex:0];
	//	[summaryItem bind:@"title" toObject:_dataSource withKeyPath:@"summaryString" options:nil];
	
	[[self menu] setDelegate:_dataSource];
	
	// TODO: make sure this actually works...
	//[[self menuItem] bind:@"title" toObject:_dataSource withKeyPath:@"summaryString" options:nil];
	//[self bind:@"title" toObject:_dataSource withKeyPath:@"summaryString" options:nil];
	//[self setNeedsDisplay:YES];
	
	
	//[self synchronizeTitleAndSelectedItem];

	// TODO: fix context
	//[_dataSource addObserver:self forKeyPath:@"summaryString" options:NSKeyValueObservingOptionNew context:NULL];
	
	//[self bind:@"title" toObject:_dataSource withKeyPath:@"summaryString" options:nil];
	
	
	//[_dataSource performSelector:@selector(menuNeedsUpdate:) withObject:[self menu]];

	//[[self cell] setUsesItemFromMenu:NO];


	//[self setTitle:@"Hi"];
	
	//NSMenu* menu = [_dataSource createMenuWithTitle:@""];

	
//	NSMenuItem *summaryItem = [[NSMenuItem alloc] initWithTitle:@"dummy" action:nil keyEquivalent:@""];
//	//[summaryItem bind:@"title" toObject:_dataSource withKeyPath:@"summaryString" options:nil];
//	//[summaryItem setEnabled:NO];		
//	
//	
////	[menu insertItemWithTitle:@"dummy" action:nil keyEquivalent:@"" atIndex:0];
//
//	
//	[menu insertItem:summaryItem atIndex:0];
//	[summaryItem release];


//	[menu insertItemWithTitle:@"dummy" action:nil keyEquivalent:@"" atIndex:0];
	
	
	
//	[self bind:@"title" toObject:_dataSource withKeyPath:@"summaryString" options:nil];
//	[self setTitle:[_dataSource summaryString]];

	[[self menuItem] bind:@"title" toObject:_dataSource withKeyPath:@"summaryString" options:nil];
	[self bind:@"title" toObject:_dataSource withKeyPath:@"summaryString" options:nil];
	
//	[self setMenu:menu];
//	[self setNeedsDisplay:YES];
}


//- (void)setAltersStateOfSelectedItem:(BOOL)flag
//{
//	[super setAltersStateOfSelectedItem:flag];
//}


- (void) setTitle:(NSString*) title
{
	[super setTitle:title];
}

//- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if (context == NULL) {
//		//[self synchronizeTitleAndSelectedItem];
//	}
//	else {
//		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//	}
//}

- (void)synchronizeTitleAndSelectedItem
{
	
}

@end

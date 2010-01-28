//
//  AMOptionPopUpButtonCell.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski  on 7/10/09.
//
//  Copyright (c) 2009 Andy Mroczkowski
//  
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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

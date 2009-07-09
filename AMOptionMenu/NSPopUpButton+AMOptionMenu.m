//
//  NSPopUpButton+AMOptionMenu.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSPopUpButton+AMOptionMenu.h"

#import "AMOptionMenu.h"

@implementation NSPopUpButton (AMOptionMenu)

- (id)initWithFrame:(NSRect)frameRect optionMenu:(AMOptionMenuDataSource*)optionMenu
{
	self = [self initWithFrame:frameRect pullsDown:YES];
	if( self )
	{
		NSMenu* newMenu = [optionMenu newMenu];		
		NSMenuItem *summaryItem = [[NSMenuItem alloc] initWithTitle:@"TODO" action:nil keyEquivalent:@""];
		[newMenu insertItem:summaryItem atIndex:0];
		[self setMenu:newMenu];
		[self setAutoenablesItems:NO];
		[self setAlignment:NSCenterTextAlignment];
	}
	return self;
}


@end

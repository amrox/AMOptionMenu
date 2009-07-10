//
//  AMOptionPopUpButton.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AMOptionPopUpButton.h"
#import "AMOptionPopUpButtonCell.h"


#import "AMOptionMenu.h"

@implementation AMOptionPopUpButton


+ (Class) cellClass
{
    return [AMOptionPopUpButtonCell class];
}

- (AMOptionMenuDataSource*) dataSource
{
	return [[self cell] dataSource];
}


- (void) setDataSource:(AMOptionMenuDataSource*) dataSource
{
	[[self cell] setDataSource:dataSource];
}


//- (void) awakeFromNib
//{
//	AMOptionPopUpButtonCell* cell = [[AMOptionPopUpButtonCell alloc] init];
//	[self setCell:cell];
//	[cell release];
//}



//- (id) initWithFrame:(NSRect)frameRect
//{
//	self = [super initWithFrame:frameRect pullsDown:YES];
//	if( self )
//	{
//		[[self cell] setAutoenablesItems:NO];
//		[self setAlignment:NSCenterTextAlignment];
//		[[self cell] setArrowPosition:NSPopUpArrowAtBottom];
//		[[self cell] setAltersStateOfSelectedItem:YES];
//
//		[[self menu] setTitle:kAMOptionPopUpButtonTitle];
//		
//		
//		
////		[[self menu] insertItemWithTitle:@"" action:nil keyEquivalent:@"" atIndex:0];
//	}
//	return self;
//}
//
//
//- (id) initWithFrame:(NSRect)frameRect pullsDown:(BOOL)flag
//{
//	return [self initWithFrame:frameRect];
//}


//- (void) dealloc
//{
//	[_dataSource release];
//	[super dealloc];
//}





@end

//
//  AMOptionPopUpButton.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AMOptionPopUpButton.h"
#import "AMOptionPopUpButtonCell.h"


#import "AMOptionMenuDataSource.h"

@implementation AMOptionPopUpButton


+ (Class) cellClass
{
    return [AMOptionPopUpButtonCell class];
}


- (void) configure
{
	NSDictionary* titleBindingOptions = [NSDictionary dictionaryWithObjectsAndKeys:
										 @"(No Data Source)", NSNullPlaceholderBindingOption,
										 nil];
	[self bind:@"title" toObject:self withKeyPath:@"cell.optionMenuDataSource.summaryString" options:titleBindingOptions];	
}


- (id) initWithFrame:(NSRect)buttonFrame pullsDown:(BOOL)flag
{
	self = [super initWithFrame:buttonFrame pullsDown:flag];
	if( self )
	{
		[self configure];
	}
	return self;
}


- (void) awakeFromNib
{
	[self configure];	
}


- (AMOptionMenuDataSource*) optionMenuDataSource
{
	return [[self cell] optionMenuDataSource];
}


- (void) setOptionMenuDataSource:(AMOptionMenuDataSource*) dataSource
{
	[[self cell] setOptionMenuDataSource:dataSource];
}


- (void) setTitle:(NSString*)title
{
	NSRect titleRect = [[self cell] titleRectForBounds:[self bounds]];
	NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								[self font], NSFontAttributeName,
								nil];
	
	NSAttributedString* tmpString = [[[NSAttributedString alloc] initWithString:title attributes:attributes] autorelease];
	
	//NSLog( @"title string size: %@", NSStringFromSize( [tmpString size] ) );
	//NSLog( @"control text size: %@", NSStringFromSize( titleRect.size) );

	if( [tmpString size].width > titleRect.size.width )
	{
		// -- try to trim it down
		
		NSRange range = [title rangeOfString:@"|" options:NSBackwardsSearch];
		if( range.location != NSNotFound )
		{
			NSString* newTitle = [[title substringToIndex:range.location]
								  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			
			[self setTitle:newTitle];
			return;
		}
	}
	
	[super setTitle:title];
}


@end

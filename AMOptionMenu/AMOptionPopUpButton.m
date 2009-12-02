//
//  AMOptionPopUpButton.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AMOptionPopUpButton.h"
#import "AMOptionPopUpButtonCell.h"


#import "AMOptionMenuController.h"

@implementation AMOptionPopUpButton

@synthesize smartTitleTruncation = _smartTitleTruncation;

+ (Class) cellClass
{
    return [AMOptionPopUpButtonCell class];
}


- (void) configure
{
	NSDictionary* titleBindingOptions = [NSDictionary dictionaryWithObjectsAndKeys:
										 @"(No Data Source)", NSNullPlaceholderBindingOption,
										 nil];
	[self bind:@"title" toObject:self withKeyPath:@"cell.optionMenuController.summaryString" options:titleBindingOptions];	
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


- (AMOptionMenuController*) optionMenuController
{
	return [[self cell] optionMenuController];
}


- (void) setOptionMenuController:(AMOptionMenuController*) controller
{
	[[self cell] setOptionMenuController:controller];
}


- (void)setFrameSize:(NSSize)newSize
{
	[super setFrameSize:newSize];
	if( self.smartTitleTruncation )
	{
		[self setTitle:[[self optionMenuController] summaryString]];
	}
}


- (void) setTitle:(NSString*)title
{
	if( self.smartTitleTruncation )
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
	}
	
	[super setTitle:title];
}


@end

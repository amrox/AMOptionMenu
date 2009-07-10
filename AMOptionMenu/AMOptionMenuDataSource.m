//
//  AMOptionMenu.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AMOptionMenuDataSource.h"


NSString* const kAMOptionPopUpButtonTitle = @"kAMOptionPopUpButtonTitle";


@implementation AMOptionMenuItem

@synthesize identifier = _identifier;
@synthesize title = _title;
@synthesize shortTitle = _shortTitle;


+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title shortTitle:(NSString*)shortTitle
{
	AMOptionMenuItem* optionMenuSection = [[[AMOptionMenuItem alloc] init] autorelease];
	[optionMenuSection setIdentifier:identifier];
	[optionMenuSection setTitle:title];
	[optionMenuSection setShortTitle:shortTitle];
	return optionMenuSection;
}


+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title
{
	return [self itemWithIdentifier:identifier title:title shortTitle:nil];
}


- (void) dealloc
{
	[_identifier release];
	[_title release];
	[_shortTitle release];
	[super dealloc];
}


- (NSString*) titleForSummary
{
	if( [self shortTitle] )
		return [self shortTitle];
	return [self title];
}


@end

#pragma mark -

@interface AMOptionMenuDataSource ()
- (NSMenuItem*) menuItemForSection:(AMOptionMenuItem*)section;
- (NSMenuItem*) menuItemForOption:(AMOptionMenuItem*)option inSection:(AMOptionMenuItem*)section;
@end

@implementation AMOptionMenuDataSource


- (id) init
{
	self = [super init];
	if (self != nil)
	{
		_sectionsDict = [[NSMutableDictionary alloc] init];
		_optionsDict = [[NSMutableDictionary alloc] init];
		_stateDict = [[NSMutableDictionary alloc] init];
	}
	return self;
}


- (NSArray*) sections
{
	return [_sectionsDict allValues];
}


- (void) setSections:(NSArray*)sections
{
	for( AMOptionMenuItem* item in sections )
	{
		[_sectionsDict setObject:item forKey:[item identifier]];
	}
}


- (NSArray*) optionsForSectionWithIdentifier:(NSString*)identifier
{
	return [_optionsDict objectForKey:identifier];
}


- (void) setOptions:(NSArray*)options forSectionWithIdentifier:(NSString*)identifier
{
	[_optionsDict setObject:options forKey:identifier];
	if( ![_stateDict objectForKey:identifier] && [options count] )
		[_stateDict setObject:[[options objectAtIndex:0] identifier] forKey:identifier];
}


- (NSMenu*) createMenuWithTitle:(NSString*)title
{
	NSMenu* menu = [[NSMenu alloc] initWithTitle:title];
	[menu setAutoenablesItems:NO];
	[menu setDelegate:self];	
	return [menu autorelease];
}


- (NSMenuItem*) menuItemForSection:(AMOptionMenuItem*)section
{
	NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[section title] action:nil keyEquivalent:@""];
	[menuItem setEnabled:NO];
	return [menuItem autorelease];
}


- (NSMenuItem*) menuItemForOption:(AMOptionMenuItem*)option inSection:(AMOptionMenuItem*)section
{
	NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[option title] action:nil keyEquivalent:@""];

	[menuItem setIndentationLevel:1];
	[menuItem setTarget:self];
	[menuItem setEnabled:YES];
	
	NSString* keypath = [NSString stringWithFormat:@"%@.%@", [section identifier], [option identifier]];
	[menuItem setRepresentedObject:keypath];

	NSDictionary* bindingOptions = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithBool:YES], NSAllowsEditingMultipleValuesSelectionBindingOption,
									nil];
	
	[menuItem bind:@"value"
		  toObject:self
	   withKeyPath:keypath
		   options:bindingOptions];

	return [menuItem autorelease];
}


- (id) valueForUndefinedKey:(NSString*)key
{
	if( [_sectionsDict objectForKey:key] )
		return [_stateDict objectForKey:key];
	
	return [super valueForUndefinedKey:key];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	if( [_sectionsDict objectForKey:key] )
	{
		//NSLog( @"settingValue:%@ forKey:%@", value, key );
		[self willChangeValueForKey:@"summaryString"];
		[_stateDict setObject:value forKey:key];
		[self didChangeValueForKey:@"summaryString"];
		return;
	}
	[super setValue:value forUndefinedKey:key];
}


- (id) valueForKeyPath:(NSString*)keyPath
{
	NSArray* keyPathComponents = [keyPath componentsSeparatedByString:@"."];
	
	if( [keyPathComponents count] == 2 )
	{
		NSString* sectionKey = [keyPathComponents objectAtIndex:0];
		NSString* optionKey = [keyPathComponents objectAtIndex:1];

		if( [_sectionsDict objectForKey:sectionKey] )
		{
			if( [[_stateDict objectForKey:sectionKey] isEqual:optionKey] )
			{
				//NSLog( @"valueForKeyPath:%@ is YES", keyPath );
				return [NSNumber numberWithBool:YES];
			}
			else
			{
				//NSLog( @"valueForKeyPath:%@ is NO", keyPath );
				return [NSNumber numberWithBool:NO];				
			}
		}
	}
	return [super valueForKeyPath:keyPath];
}


- (void)setValue:(id)value forKeyPath:(NSString*)keyPath
{
	NSArray* keyPathComponents = [keyPath componentsSeparatedByString:@"."];
	if( [keyPathComponents count] == 2 )
	{
		NSString* sectionKey = [keyPathComponents objectAtIndex:0];
		NSString* optionKey = [keyPathComponents objectAtIndex:1];		
		
		if( [_sectionsDict objectForKey:sectionKey] )
		{
			if( [value boolValue] )
			{
				[self setValue:optionKey forKey:sectionKey];
			}
			return;
		}
	}
	[super setValue:value forKeyPath:keyPath];
}


- (NSString*) summaryString
{
	NSMutableString* string = [NSMutableString string];
	for( NSString* sectionId in [_sectionsDict allKeys] )
	{
		if( [string length] )
			[string appendString:@" | "];
		
		// TODO: make nicer
		NSString* optionId = [self valueForKey:sectionId];
		
		NSString* title = nil;
		for( AMOptionMenuItem* menuItem in [_optionsDict objectForKey:sectionId] )
		{
			if( [[menuItem identifier] isEqualToString:optionId] )
			{
				title = [menuItem titleForSummary];
				break;
			}
		}		
		[string appendFormat:@"%@", title];
	}
	return [NSString stringWithString:string];
}


#pragma mark NSMenu Delegate Methods


- (void)menuNeedsUpdate:(NSMenu *)menu
{
	while( [[menu itemArray] count] )
	{
		[menu removeItemAtIndex:0];
	}
	
	if( [[menu title] isEqualToString:kAMOptionPopUpButtonTitle] )
	{
		[menu insertItemWithTitle:@"dummy" action:nil keyEquivalent:@"" atIndex:0];
	}
		
	for( AMOptionMenuItem* section in [self sections] )
	{
		[menu addItem:[self menuItemForSection:section]];
		
		for( AMOptionMenuItem* option in [self optionsForSectionWithIdentifier:[section identifier]] )
		{
			[menu addItem:[self menuItemForOption:option inSection:section]];
		}
	}
}




// THOUGHT: bind to Dinosaurs.Awesome.isSelected ????

@end


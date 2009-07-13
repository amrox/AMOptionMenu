//
//  AMOptionMenu.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AMOptionMenuDataSource.h"


NSString* const kAMOptionPopUpButtonTitle = @"kAMOptionPopUpButtonTitle";
s

@implementation AMOptionMenuItem

@synthesize identifier = _identifier;
@synthesize title = _title;
@synthesize shortTitle = _shortTitle;


+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title shortTitle:(NSString*)shortTitle
{
	AMOptionMenuItem* item = [[[AMOptionMenuItem alloc] init] autorelease];
	[item setIdentifier:identifier];
	[item setTitle:title];
	[item setShortTitle:shortTitle];
	return item;
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

NSString* const kAMOptionMenuDataWillChange = @"kAMOptionMenuDataWillChange";
NSString* const kAMOptionMenuDataDidChange = @"kAMOptionMenuDataDidChange";


@interface AMOptionMenuDataSource ()

@property (nonatomic, retain) NSArray* groups;
@property (nonatomic, retain) NSDictionary* valuesDict;

- (NSArray*) optionValuesForGroupWithIdentifier:(NSString*)identifier;
- (NSMenuItem*) menuItemForGroup:(AMOptionMenuItem*)group;
- (NSMenuItem*) menuItemForOption:(AMOptionMenuItem*)option inGroup:(AMOptionMenuItem*)group;
@end

@implementation AMOptionMenuDataSource

@synthesize groups = _groups;
@synthesize valuesDict = _valuesDict;

- (id) init
{
	self = [super init];
	if (self != nil)
	{
		_groups = [[NSMutableDictionary alloc] init];
		_valuesDict = [[NSMutableDictionary alloc] init];
		_stateDict = [[NSMutableDictionary alloc] init];
	}
	return self;
}


- (void) dealloc
{
	[_groups release];
	[_valuesDict release];
	[super dealloc];
}


- (NSArray*) optionGroups
{
	return [NSArray arrayWithArray:_groups];
}


- (NSArray*) optionValuesForGroupWithIdentifier:(NSString*)identifier
{
	return [_valuesDict objectForKey:identifier];
}


- (NSMenu*) createMenuWithTitle:(NSString*)title
{
	NSMenu* menu = [[NSMenu alloc] initWithTitle:title];
	[menu setAutoenablesItems:NO];
//	[menu setDelegate:self];	

	for( AMOptionMenuItem* group in [self optionGroups] )
	{
		[menu addItem:[self menuItemForGroup:group]];
		
		for( AMOptionMenuItem* value in [self optionValuesForGroupWithIdentifier:[group identifier]] )
		{
			[menu addItem:[self menuItemForOption:value inGroup:group]];
		}
	}
	
	return [menu autorelease];
}


- (NSMenuItem*) menuItemForGroup:(AMOptionMenuItem*)group
{
	NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[group title] action:nil keyEquivalent:@""];
	[menuItem setEnabled:NO];
	return [menuItem autorelease];
}


- (NSMenuItem*) menuItemForOption:(AMOptionMenuItem*)option inGroup:(AMOptionMenuItem*)group
{
	NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[option title] action:nil keyEquivalent:@""];

	[menuItem setIndentationLevel:1];
	[menuItem setTarget:self];
	[menuItem setEnabled:YES];
	
	NSString* keypath = [NSString stringWithFormat:@"%@.%@", [group identifier], [option identifier]];
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
	if( [_valuesDict objectForKey:key] )
		return [_stateDict objectForKey:key];
	
	return [super valueForUndefinedKey:key];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	if( [_valuesDict objectForKey:key] )
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
		NSString* groupKey = [keyPathComponents objectAtIndex:0];
		NSString* optionKey = [keyPathComponents objectAtIndex:1];

		if( [_valuesDict objectForKey:groupKey] )
		{
			if( [[_stateDict objectForKey:groupKey] isEqual:optionKey] )
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
		
		if( [_valuesDict objectForKey:sectionKey] )
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
	for( AMOptionMenuItem* group in _groups )
	{
		if( [string length] )
			[string appendString:@" | "];
		
		// TODO: make nicer
		NSString* optionId = [self valueForKey:[group identifier]];
		
		NSString* title = nil;
		for( AMOptionMenuItem* menuItem in [_valuesDict objectForKey:[group identifier]] )
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

- (void) setOptionGroups:(NSArray*)groups andValues:(NSDictionary*)values
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kAMOptionMenuDataWillChange object:self];
	
	[self setGroups:groups];
	[self setValuesDict:values];
	
	for( NSString* groupId in [[self valuesDict] allKeys] )
	{
		if( ![_stateDict objectForKey:groupId] )
		{
			NSString* valueId = [[[[self valuesDict] objectForKey:groupId] objectAtIndex:0] identifier];
			[_stateDict setObject:valueId forKey:groupId];
		}
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kAMOptionMenuDataDidChange object:self];
}


// THOUGHT: bind to Dinosaurs.Awesome.isSelected ????

@end


//
//  XMLToDict.m
//  FHIR
//
//  Created by Adam Sippel on 2013-03-04.
//  Copyright (c) 2013 Mohawk College. All rights reserved.
//

#import "XMLToDict.h"

@implementation XMLToDict

@synthesize incomingResourceType = _incomingResourceType;

#warning - Fix this code!!!
- (void)convertXmlToDictionary:(NSString *)urlString resourceType:(NSString *)resourceType
{
    //NSString *filePath = @"/Users/adamsippel/Desktop/patient.xml";
    //BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *xmlString = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    
    if (xmlString)
    {
        NSLog(@"Exists");
        //NSString *xmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSError *error;
        xmlString = [self stringByStrippingXMLHeader:xmlString];
        //NSLog(@"%@",xmlString);
        
        NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:xmlString error:error];
        _incomingResourceType = resourceType;
        //NSLog(@"%@", xmlDictionary);
        [self createLocalizedObject:xmlDictionary];
    }
    else
    {
        NSLog(@"File does not exist at: %@", urlString);
    }
    
}

- (void)createLocalizedObject:(NSDictionary *)xmlDict
{
    if ([_incomingResourceType isEqual: @"Patient"])
    {
        Patient *patient = [[Patient alloc] init];
        [patient patientParser:xmlDict];
        //NSLog(@"%@", patient);
    }
}

- (NSString *)stringByStrippingXMLHeader:(NSString *)xmlString
{
    NSRange r;
    if ((r = [xmlString rangeOfString:@"(.*)<\?xml.*\?>" options:NSRegularExpressionSearch]).location != NSNotFound)
        xmlString = [xmlString stringByReplacingCharactersInRange:r withString:@""];
    return xmlString;
}

@end
//
//  PackageSettings_Tests.m
//  SpriteBuilder
//
//  Created by Nicky Weber on 21.07.14.
//
//

#import <XCTest/XCTest.h>
#import "PackagePublishSettings.h"
#import "RMPackage.h"
#import "PublishOSSettings.h"
#import "FileSystemTestCase.h"
#import "SBAssserts.h"

@interface PackagePublishSettings_Tests : FileSystemTestCase

@property (nonatomic, strong) RMPackage *package;
@property (nonatomic, strong) PackagePublishSettings *packagePublishSettings;

@end


@implementation PackagePublishSettings_Tests

- (void)setUp
{
    [super setUp];

    self.package = [[RMPackage alloc] init];
    _package.dirPath = [self fullPathForFile:@"/foo/project.spritebuilder/Packages/mypackage.sbpack"];

    self.packagePublishSettings = [[PackagePublishSettings alloc] initWithPackage:_package];

    [self createFolders:@[@"/foo/project.spritebuilder/Packages/mypackage.sbpack"]];
}

- (void)testInitialValuesKVCPaths
{
    PublishOSSettings *osSettingsIOS = [_packagePublishSettings settingsForOsType:kCCBPublisherOSTypeIOS];
    XCTAssertNotNil(osSettingsIOS);

    PublishOSSettings *osSettingsIOSKVC = [_packagePublishSettings valueForKeyPath:@"osSettings.ios"];
    XCTAssertNotNil(osSettingsIOSKVC);

    PublishOSSettings *osSettingsAndroid = [_packagePublishSettings settingsForOsType:kCCBPublisherOSTypeAndroid];
    XCTAssertNotNil(osSettingsAndroid);

    PublishOSSettings *osSettingsAndroidKVC = [_packagePublishSettings valueForKeyPath:@"osSettings.android"];
    XCTAssertNotNil(osSettingsAndroidKVC);
}

- (void)testPersistency
{
    _packagePublishSettings.outputDirectory = @"foo";
    _packagePublishSettings.publishToMainProject = NO;
    _packagePublishSettings.publishToZip = NO;
    _packagePublishSettings.publishEnvironment = kCCBPublishEnvironmentRelease;

    PublishOSSettings *osSettingsIOS = [_packagePublishSettings settingsForOsType:kCCBPublisherOSTypeIOS];
    osSettingsIOS.audio_quality = 8;
    osSettingsIOS.resolutions = @[@"phone"];
    [_packagePublishSettings setOSSettings:osSettingsIOS forOsType:kCCBPublisherOSTypeIOS];

    PublishOSSettings *osSettingsAndroid = [_packagePublishSettings settingsForOsType:kCCBPublisherOSTypeAndroid];
    osSettingsAndroid.audio_quality = 2;
    osSettingsAndroid.resolutions = @[@"tablethd"];
    [_packagePublishSettings setOSSettings:osSettingsAndroid forOsType:kCCBPublisherOSTypeAndroid];

    [_packagePublishSettings store];

    [self assertFileExists:@"/foo/project.spritebuilder/Packages/mypackage.sbpack/Package.plist"];


    PackagePublishSettings *settingsLoaded = [[PackagePublishSettings alloc] initWithPackage:_package];
    [settingsLoaded load];

    XCTAssertEqual(_packagePublishSettings.publishToMainProject, settingsLoaded.publishToMainProject);
    SBAssertStringsEqual(_packagePublishSettings.outputDirectory, settingsLoaded.outputDirectory);
    XCTAssertEqual(_packagePublishSettings.publishEnvironment, settingsLoaded.publishEnvironment);
    XCTAssertEqual(_packagePublishSettings.publishToZip, settingsLoaded.publishToZip);

    PublishOSSettings *osSettingsAndroidLoaded = [settingsLoaded settingsForOsType:kCCBPublisherOSTypeAndroid];
    XCTAssertEqual(osSettingsAndroidLoaded.audio_quality, osSettingsAndroid.audio_quality);
    XCTAssertTrue([osSettingsAndroidLoaded.resolutions containsObject:@"tablethd"]);
    XCTAssertFalse([osSettingsAndroidLoaded.resolutions containsObject:@"tablet"]);

    PublishOSSettings *osSettingsIOSLoaded = [settingsLoaded settingsForOsType:kCCBPublisherOSTypeIOS];
    XCTAssertEqual(osSettingsIOSLoaded.audio_quality, osSettingsIOS.audio_quality);
    XCTAssertTrue([osSettingsIOSLoaded.resolutions containsObject:@"phone"]);
    XCTAssertFalse([osSettingsIOSLoaded.resolutions containsObject:@"tablethd"]);
}


@end

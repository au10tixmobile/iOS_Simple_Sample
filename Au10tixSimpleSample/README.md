
    To use the AU10TIX SDK, you need to get the JWT from your server. Which, in turn, will request it from the AU10TIX server.


This guide explains the core functionality of the SDK, and details the steps required for a successful implementation.

The AU10TIX SDK gathers user identification data for further authentication performed by the AU10TIX backend service. 

The AU10TIX SDK is comprised of the AU10TIX Core Module, used in conjunction with one or more Feature modules.
Both the Core Module and each of the Feature modules are .framework. 
All modules are dependent on the Core AU10TIX Core Module.

The AU10TIX Core Module, and most Feature Modules support applications that are targeting iOS 11 or higher. 

The AU10TIX SDK gathers the following types of data:

    *  Smart Document Capture: Automatic capture of an authenticated document.
    *  Passive Face Liveness: Allows you to get an assessment of the liveness probability of a user by taking a still image from the front camera.  
    *  Proof Of Address: Capture of an authenticated document.


INTEGRATING THE SDK TO YOUR IOS PROJECT .

    *  The following procedure allows you to integrate the SDK into your iOS project. 
    

CORE MODULE INSTALLATION.

    * To use the AU10TIX SDK, installation of the Core Module is mandatory.
    * import Au10tixCore.
    

FEATURE MODULES INSTALLATION.

    * The AU10TIX SDK is comprised of various Feature Modules. Integration of some or all of the Feature Modules is optional, in accordance to your project needs. In order to integrate AU10TIX Feature Modules into your project, specify one or more of them.


PERMISSIONS.

The AU10TIX SDK uses the device location and camera to produce photos containing metadata relevant to the authentication process. 
Both Camera and Location permissions must be declared, requested, and granted for the SDK to behave as expected.
You declare privacy permission usage descriptions in the info.plist of your application.
If you are viewing your application’s info.plist file as a property list, you need to add usage description strings for the following property list keys:

    * Privacy - Camera Usage Description
    * Privacy - Location When in Use Usage Description

FEATURE MANAGER.

The Feature Manager represents the only interface the implementor has with the Feature Manager’s respective Feature Module. 
Feature Manager types: 

    * ProofOfAddressFeatureManager: Provides capturing capabilities.  
    * Au10PassiveFaceLivenessFeatureManager: Provides selfie capturing capabilities in an automatic/manual mode.  
    * SmartDocumentFeatureManager: Provides capturing capabilities for documents.  

SESSION DELEGATE PROTOCOL.

The Au10CoreToApp is a delegation protocol. The implementor should pass an object that conforms to the Au10CoreToApp protocol to the Au10tixCore’s delegate property. The Au10CoreToApp provides the following callback methods: 

    * didGetUpdate(_ update: FeatureSessionUpdate) – Gets called whenever the session has an update. Passes an update object which then needs to be subclassed to the specific feature update.
    * didGetError(_ error: Au10tixSessionError) - Gets called whenever the session has an error.
    * didGetResult(_ result: Au10tixSessionResult) -  Gets called when the feature session has a conclusive result. 

STANDARD IMPLEMENTATION PROCEDURE OVERVIEW.

The following implementation steps are consistent for all detection types: 

1. Gather the bearer JWT from your server which in turn request it from the AU10TIX server using the client assertion’s JWT and the relevant scopes.  
2. Prepare the AU10TIX SDK by calling Au10tixCore’s static function prepare() with the retrieved JWT object.  
3. Verify privacy permissions are granted, respective to the desired feature (camera, location).  
4. Pass the Au10tixCore shared instance a delegate object conforming to the Au10tixSessionDelegate protocol.  
5. Instantiate a Feature Manager respective to the desired feature.  
6. Start a session by calling the startSession(with:previewView:) on the Au10tixCore shared instance, passing it the instantiated Feature Manager and a preview view to display the camera video feed in.  
7. Handle the session’s callbacks using the delegate’s implementation of the Au10tixSessionDelegate delegation protocol methods.  

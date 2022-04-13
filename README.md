# Au10tix SDK Implementation Example - iOS

## Table of Contents
- [Overview](#overview)
- [Usage](#usage)
    - [JWT token](#jwt-token)
    - [Permissions](#permissions)
- [Change log](#change-log)

## Overview
Verified, compliant and fraud-free onboarding results in 8 seconds (or less). By the time you read this sentence, AU10TIX would have converted countless human smiles, identity documents and data points into authenticated, all-access passes to your products, services and experiences.

This example application presents an implementation suggestion for the Au10tix Mobile SDK.

The following integration examples are included:
- Passive Face Liveness
- Smart Document Capture
- Proof of Address
- UI components integration
- Sending results to the backend

## Usage

To use this sample you have to edit the sample files according to the following steps

### JWT token
The SDK is prepared using the JWT token produced by the client's server.
Acquire the JWT token and modify MainViewController.swift 'prepare' method to correctly include the values attained from your server.
```swift
func prepare()
    let jwtToken = ""
```

### Permissions
The AU10TIX SDK uses the device location and camera to produce photos containing metadata relevant to the authentication process. 
Both Camera and Location permissions must be declared, requested, and granted for the SDK to behave as expected.
You declare privacy permission usage descriptions in the info.plist of your application.
If you are viewing your application’s info.plist file as a property list, you need to add usage description strings for the following property list keys:

    * Privacy - Camera Usage Description
    * Privacy - Location When in Use Usage Description

## Change log
See [Change log](changelog.md) page for more details


# iOS - Frameworks 
## Introduction

This repository is simply a collection of knowledge I have gathered around Frameworks and Libraries.

## What is a Framework?

So taken from the [Apple Framework Developer Guide](https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/WhatAreFrameworks.html#//apple_ref/doc/uid/20002303-BBCEIJFI) 
> A framework is a hierarchical directory that encapsulates shared resources, such as a dynamic shared library, nib files, image files, localized strings, header files, and reference documentation in a single package.

In the most common scenario (AFAIK), a framework is a package containing symbolic links to a library, the headers, and any potential required resources (e.g. assets). Taking a dive into a framework might look like so: 
```
AFramework.framework/
├── AFramework
├── Headers/
│   ├── BHeader.h
│   └── CHeader.h
├── Info.plist
└── Modules/
    └── module.modulemap
```
Here we note the following:
- AFramework is a mach-o universal binary (potentially with multiple architectures) 
- BHeader and CHeader are header files within the headers directory of the framework
- module.modulemap is the module map 

A framework can be **"static"** or **"dynamic"**. It is important to note that a **"static framework"** is really just a package with symbolic links to the compiled intermediate lib object and the associated headers. Thus a dynamic framework is a package containing various resources and a dynamic library.

*There is no template to create a static framework in xCode (There is a static Library creation path) but there are several popular methods to make a static framework. ([This method](https://github.com/jverkoey/iOS-Framework) is pretty popular).*

Should note that the definitions given above are really just a rough guide. 

### Dynamic Vs Static 

When linked, Static libraries get combined with our target binary. (This results in an increased binary size, since basically anything in the library would now be in our binary.) The opposite occurs when linking a Dynamic library; None of the dynamic library's code is actually combined into our target binary. Because the library code is not included in our target binary, it has to be loaded into memory at run time. 

The following example demonstrates the difference mentioned above:
- StLib is a static library 
  - StLib contains class StLib with method sMethod 
- DyFramework is a dynamic framework 
  - DyFramework contains class DClass with method dMethod

After compiling the target binary foo, we will use [class-dump](http://stevenygard.com/projects/class-dump/) on each of the relevant products. 
![CDump-Demo](https://github.com/Li720/FrameworksExplanation/blob/writeup/WriteUp/Images/CDumpDemo-Speedx2.gif)

Notice how our target binary contains StLib and sMethod but not DClass or dMethod.  
![CDump-Demo](https://github.com/Li720/FrameworksExplanation/blob/writeup/WriteUp/Images/StLibVsDClass-speedx2.gif)

Because of the way dynamic frameworks work, dynamic frameworks need to be copied/embedded into the Frameworks portion of an iOS app. Linking to a dynamic framework but not copying it may result in an error that looks somewhat like so: 
> dyld: Library not loaded: <Library>  
  Referenced from: Foo  
  Reason: image not found  

### Inspecting a framework

There are several tools we can use to tell if a framework is static/dynamic and what architectures it contains. Here are some:

```shell
otool -l AFramework
```
```shell
file AFramework
```

### Adding a Framework to a project (iOS)

The process of using a framework is pretty straight forward though occassionally one may encounter some hiccups. The most common process for using a framework is to add it under the "Linked Frameworks and Libraries" and "Embedded Binaries" section of the target. 

Or manually adding it to the Link Binary With Libraries Section of the Build Phases + Copy Files Phase + Updaing some build settings including Other Linker Flags, Framework Search Paths, Library Search Paths.

### Pre-compiled Framewokrs / Binaries vs Frameworks in development

If the application we are currently working on depends on a precompiled Framework (e.g. a Carthage dependency which Carthage has already built, or simply a framework we've manually built) then replacing the framework at its location with an updated/modified framework is all that is required. 
This is reasonable for cases like Carthage where updates are handled through Carthage update, or for frameworks where updates are less frequent. (E.g if we had an analytics library we update once every couple months when they release a new build)

However, if we are simultaneously working on our dependency and our application, we might not want the hassle of replacing the compiled framework over and over. There are several varying set-ups which we might find useful: (There are probably many more but these are the ones I know of) 
1. Target application and Framework are both targets of a common project
2. Framework project is a sub-project of application project (Potentially submodules)
3. Framework and Application are seperate projects and work is done in a xcworkspace

## Build Settings

If the framework we are in scenario 1 or 2 above, we can add our framework target as a target dependency of the application target. This will ensure that the framework is built when building the application. 
![Target Dependency](https://github.com/Li720/FrameworksExplanation/blob/writeup/WriteUp/Images/TargetDepend.png)

However if we find ourselves in scenario 3, we note that adding the framework to the target dependencies phase isn't actually possible. Rather we will take advantage of xcworkspace magic. If in our active scheme, we have the "Find implicit dependencies" checked of, and we have both the framework project, and the application project in the same workspace, xcode should compile the framework automatically. 
![FindImplicitCheckBox](https://github.com/Li720/FrameworksExplanation/blob/writeup/WriteUp/Images/FindImplicitCheckBox.png)

The current example of frameworks101.xcworkspace illustrates the above scenario quite well. 
![ImplicitFind](https://github.com/Li720/FrameworksExplanation/blob/writeup/WriteUp/Images/ImplicitFind.png)

In scenario 3 we could also not have find implicit dependencies on and rather just add the framework target to our build scheme. This would also ensure that the framework is built. (Note that the order matters) 
![EditingScheme](https://github.com/Li720/FrameworksExplanation/blob/writeup/WriteUp/Images/EditingScheme.png)

We should note that in Scenario 3, development is now dependent on the xcworkspace; Trying to build the application from the project file alone would most likely result in an error. (The xcworkspace carries knowledge of the exsistence of the framework project)
![BrokenScheme](https://github.com/Li720/FrameworksExplanation/blob/writeup/WriteUp/Images/BrokenScheme.png)
![ProjectError](https://github.com/Li720/FrameworksExplanation/blob/writeup/WriteUp/Images/ProjectError.png)

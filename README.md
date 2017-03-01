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

Should note that the definitions given above are really just a rough guide. 

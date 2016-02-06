Object subclass: #SCIAbstractLoadSpec
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkCI-Core'!

!SCIAbstractLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/11/2016 02:41'!
platforms
	^ self subclassResponsibility! !

!SCIAbstractLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/11/2016 02:55'!
platforms: aPlatform
	^ self subclassResponsibility! !


!SCIAbstractLoadSpec methodsFor: 'executing' stamp: 'EatebanLorenzano 1/27/2016 14:24'!
basicLoadProjectOn: aSmalltalkCI
	self subclassResponsibility! !

!SCIAbstractLoadSpec methodsFor: 'executing' stamp: 'fn 1/31/2016 19:18'!
loadProjectOn: aSmalltalkCI
	self isComplete
		ifFalse: [ self error: 'This spec cannot be loaded or is incomplete.' ].
	self isPlatformCompatible
		ifFalse: [ self error: 'This spec cannot be loaded on this platform' ].
	self basicLoadProjectOn: aSmalltalkCI! !


!SCIAbstractLoadSpec methodsFor: 'compatibility' stamp: 'fn 1/31/2016 19:57'!
isPlatformCompatible
	"If no platform is specified, we assume is valid for current execution platform"
	^ self platforms isEmptyOrNil 
		or: [ self platforms includes: (Smalltalk at: #SmalltalkCI) platformSymbol ]! !


!SCIAbstractLoadSpec methodsFor: 'testing' stamp: 'fn 1/31/2016 18:51'!
finishUpAfterCI
	"Nothing to clean up"! !

!SCIAbstractLoadSpec methodsFor: 'testing' stamp: 'fniep 1/10/2016 23:47'!
isComplete
	^ false! !

!SCIAbstractLoadSpec methodsFor: 'testing' stamp: 'fn 1/31/2016 18:51'!
prepareForCI
	"Nothing to prepare"! !

!SCIAbstractLoadSpec methodsFor: 'testing' stamp: 'fn 1/16/2016 16:03'!
testClasses
	^ #()! !


SCIAbstractLoadSpec subclass: #SCIMetacelloLoadSpec
	instanceVariableNames: 'baseline configuration directory load platforms repository originalAuthor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkCI-Core'!

!SCIMetacelloLoadSpec methodsFor: 'testing' stamp: 'fn 1/31/2016 20:11'!
finishUpAfterCI
	self class setAuthor: self originalAuthor! !

!SCIMetacelloLoadSpec methodsFor: 'testing' stamp: 'EatebanLorenzano 1/27/2016 13:55'!
isComplete
	(self baseline isNil and: [ self configuration isNil ])
		ifTrue: [ ^ false ].
	^ true! !

!SCIMetacelloLoadSpec methodsFor: 'testing' stamp: 'fn 1/31/2016 22:14'!
prepareForCI
	self originalAuthor: (Smalltalk at: #SmalltalkCI) getAuthor.
	self class setAuthor: self class testAuthor! !


!SCIMetacelloLoadSpec methodsFor: 'private' stamp: 'fn 1/16/2016 16:27'!
getTestClassesForMetacelloProjectRegistration: aClassName
	Smalltalk at: #'MetacelloProjectRegistration' ifPresent: [ :mpr |
		^ (mpr registrationForClassNamed: aClassName
				ifAbsent: [ self error: aClassName printString , ' not registered (loaded)' ])
			currentlyLoadedClassesInProject select: [ :cl | cl inheritsFrom: TestCase ] ].
	^ #()! !


!SCIMetacelloLoadSpec methodsFor: 'executing' stamp: 'fn 1/31/2016 19:57'!
basicLoadProjectOn: aSmalltalkCI
	aSmalltalkCI class requireMetacello.
	(Smalltalk at: #Metacello) new
		repository: (self loadRepositoryFor: aSmalltalkCI);
		baseline: self baseline;
		configuration: self configuration;
		load: self load! !

!SCIMetacelloLoadSpec methodsFor: 'executing' stamp: 'fn 1/31/2016 19:23'!
loadRepositoryFor: aSmalltalkCI
	^ self repository
		ifNil: [ 'filetree://', aSmalltalkCI projectDirectory, '/', self directory ]! !


!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:44'!
baseline
	^ baseline! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:44'!
baseline: aBaseline
	baseline := aBaseline! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:45'!
configuration
	^ configuration! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:44'!
configuration: aConfiguration
	configuration := aConfiguration! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/10/2016 17:54'!
directory
	^ directory! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/10/2016 17:54'!
directory: aDirectory
	directory := aDirectory! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/10/2016 18:27'!
load
	^ load ifNil: [ load := #() ]! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:46'!
load: required
	load := required! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/31/2016 18:50'!
originalAuthor
	^ originalAuthor! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/31/2016 18:50'!
originalAuthor: anAuthor
	originalAuthor := anAuthor! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/11/2016 02:39'!
platforms
	^ platforms ifNil: [ platforms := OrderedCollection new ]! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/11/2016 02:39'!
platforms: platformCollection
	platforms := platformCollection! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:44'!
repository
	^ repository! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:44'!
repository: aRepository
	repository := aRepository! !

!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/16/2016 16:07'!
testClasses
	self baseline ifNotNil: [ :b |
		^ self getTestClassesForMetacelloProjectRegistration: b ].
	self category ifNotNil: [ :c |
		^ self getTestClassesForMetacelloProjectRegistration: c ].
	^ #()! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SCIMetacelloLoadSpec class
	instanceVariableNames: ''!

!SCIMetacelloLoadSpec class methodsFor: 'helpers' stamp: 'fn 1/31/2016 20:11'!
setAuthor: anAuthor
	(Smalltalk at: #MetacelloPlatform) current authorName: anAuthor! !


!SCIMetacelloLoadSpec class methodsFor: 'constants' stamp: 'fn 1/31/2016 18:53'!
testAuthor
	^ 'TravisCI'! !


Object subclass: #SmalltalkCI
	instanceVariableNames: 'spec projectDirectory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkCI-Core'!

!SmalltalkCI methodsFor: 'executing' stamp: 'fn 1/31/2016 19:03'!
finishUpAfterCI
	self compatibleSpecs do: [ :each | each finishUpAfterCI ]! !

!SmalltalkCI methodsFor: 'executing' stamp: 'EatebanLorenzano 1/27/2016 14:31'!
loadProjects
	"Install all specs for the current platform"
	self compatibleSpecs 
		do: [ :each | each loadProjectOn: self ]! !

!SmalltalkCI methodsFor: 'executing' stamp: 'EstebanLorenzano 1/26/2016 17:07'!
prepareForCI
	self compatibleSpecs do: [ :each | each prepareForCI ]
	! !

!SmalltalkCI methodsFor: 'executing' stamp: 'fn 1/31/2016 19:02'!
runCI
	self prepareForCI.
	self loadProjects.
	self runTests.
	self finishUpAfterCI.! !

!SmalltalkCI methodsFor: 'executing' stamp: 'fn 1/31/2016 18:58'!
runCIFor: aFilename
	self readSTONSpec: aFilename.
	self runCI.! !

!SmalltalkCI methodsFor: 'executing' stamp: 'EatebanLorenzano 1/27/2016 14:02'!
runTests
	self subclassResponsibility! !


!SmalltalkCI methodsFor: 'accessing' stamp: 'travisCI 1/27/2016 16:27'!
classesToTest
	| classes  |
	
	((spec testing includesKey: #categories) 
		or: [ spec testing includesKey: #classes ])
		ifTrue: [ ^ self classesToTestFrom: spec testing ].

	classes := Set new.
	self compatibleSpecs 
		do: [ :each | classes addAll: each testClasses ].
	
	spec testing 
		at: #include 
		ifPresent: [ :includeDict |
			classes addAll: (self classesToTestFrom: includeDict) ].
	
	spec testing 
		at: #exclude 
		ifPresent: [ :excludeDict |
			classes removeAllFoundIn: (self classesToTestFrom: excludeDict) ].
	
	^ classes! !

!SmalltalkCI methodsFor: 'accessing' stamp: 'travisCI 1/27/2016 16:27'!
classesToTestFrom: aDictionary
	| classes |

	classes := Set new.
	
	aDictionary 
		at: #classes 
		ifPresent: [ :classList |
			classList do: [ :eachClass |
				Smalltalk at: eachClass ifPresent: [ :class | classes add: class ] ] ].
	
	aDictionary 
		at: #categories 
		ifPresent: [ :categoryList |
			categoryList do: [ :eachCategory |
				(eachCategory last = $*)
					ifTrue: [ classes addAll: (self classesInCategoryPrefix: eachCategory allButLast) ]
					ifFalse: [ classes addAll: (self classesInCategory: eachCategory) ] ] ].

	^ classes	
	! !

!SmalltalkCI methodsFor: 'accessing' stamp: 'EatebanLorenzano 1/27/2016 13:53'!
compatibleSpecs 
	^ spec loading select: [ :each | each isPlatformCompatible ]! !

!SmalltalkCI methodsFor: 'accessing' stamp: 'EstebanLorenzano 1/26/2016 16:20'!
projectDirectory
	^ projectDirectory! !

!SmalltalkCI methodsFor: 'accessing' stamp: 'EstebanLorenzano 1/26/2016 16:20'!
spec
	^ spec! !

!SmalltalkCI methodsFor: 'accessing' stamp: 'fn 1/31/2016 18:59'!
spec: aSmalltalkCISpec
	spec := aSmalltalkCISpec! !


!SmalltalkCI methodsFor: 'accessing' stamp: 'dkh 2/4/2016 16:01'!
projectDirectory: aDirectoryPathString
  projectDirectory := aDirectoryPathString! !


!SmalltalkCI methodsFor: 'initialization' stamp: 'fn 1/31/2016 22:08'!
initialize
	SmalltalkCI platformClass requireSTON! !


!SmalltalkCI methodsFor: 'private helpers' stamp: 'EatebanLorenzano 1/27/2016 13:06'!
classesInCategory: aCategory
	^ (Smalltalk organization listAtCategoryNamed: aCategory) collect: [ :className | Smalltalk at: className ]! !

!SmalltalkCI methodsFor: 'private helpers' stamp: 'EatebanLorenzano 1/27/2016 13:06'!
classesInCategoryPrefix: aCategoryPrefix
	| classes |
	classes := Set new.
	(Smalltalk organization categories
		select: [ :category | category beginsWith: aCategoryPrefix ])
			do: [ :category |
				classes addAll: (self classesInCategory: category) ].
	^ classes! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SmalltalkCI class
	instanceVariableNames: 'platformClass'!

!SmalltalkCI class methodsFor: 'instance creation' stamp: 'travisCI 1/27/2016 17:10'!
new
	self error: 'Use #runCIFor:'! !


!SmalltalkCI class methodsFor: 'executing' stamp: 'dkh 2/4/2016 16:01'!
runCIForSpec: aSmalltalkCISpec projectDirectory: aDirectoryPathString
  ^ self platformClass basicNew
    initialize;
    spec: aSmalltalkCISpec;
    projectDirectory: aDirectoryPathString;
    runCI! !


!SmalltalkCI class methodsFor: 'executing' stamp: 'EstebanLorenzano 1/26/2016 17:36'!
runCIFor: aFilenameString
	^ self platformClass basicNew 
		initialize;
		runCIFor: aFilenameString! !


!SmalltalkCI class methodsFor: 'accessing' stamp: 'fn 1/31/2016 18:01'!
platformClass
	"There will be just one subclass installed (for each platform)"
	^ platformClass ifNil: [
		self allSubclasses detect: [ :cl | cl isPlatformCompatible ] ]! !


!SmalltalkCI class methodsFor: 'private' stamp: 'travisCI 1/27/2016 17:10'!
platformClass: aClass
	"This is used for testing."
	platformClass := aClass! !


!SmalltalkCI class methodsFor: 'bootstrapping' stamp: 'fn 1/31/2016 19:21'!
installMetacello
	^ self subclassResponsibility! !

!SmalltalkCI class methodsFor: 'bootstrapping' stamp: 'fn 1/31/2016 19:49'!
installSTON
	#(Installer Gofer Metacello) do: [ :each |
		self isSTONInstalled ifFalse: [
			(Smalltalk includesKey: each) ifTrue: [
    			[ self perform: (#installSTONWith, each) asSymbol ] 
				on: Warning do: [ :x | x resume ] ] ] ]! !

!SmalltalkCI class methodsFor: 'bootstrapping' stamp: 'fn 1/31/2016 22:22'!
installSTONWithGofer
	(Smalltalk at: #gofer) new
		url: 'http://ss3.gemstone.com/ss/STON';
  		package: 'STON-Core';
		load! !

!SmalltalkCI class methodsFor: 'bootstrapping' stamp: 'fn 1/31/2016 22:22'!
installSTONWithInstaller
	(Smalltalk at: #Installer) squeaksource3
      	project: 'STON';
      	addPackage: 'STON-Core';
      	install! !

!SmalltalkCI class methodsFor: 'bootstrapping' stamp: 'fn 1/31/2016 22:13'!
installSTONWithMetacello
	(Smalltalk at: #Metacello) new
      	configuration: 'Ston';
      	version: #stable;
      	repository: 'http://ss3.gemstone.com/ss/STON';
      	load! !

!SmalltalkCI class methodsFor: 'bootstrapping' stamp: 'fn 1/31/2016 19:20'!
isMetacelloInstalled 
	^ Smalltalk includesKey: #Metacello! !

!SmalltalkCI class methodsFor: 'bootstrapping' stamp: 'fn 1/31/2016 18:57'!
isSTONInstalled 
	^ Smalltalk includesKey: #STON! !

!SmalltalkCI class methodsFor: 'bootstrapping' stamp: 'fn 1/31/2016 19:19'!
requireMetacello
	self isMetacelloInstalled ifTrue: [ ^ self ].
    	
	self installMetacello.
	self isMetacelloInstalled
		ifFalse: [ self error: 'Metacelo could not be loaded.' ]! !

!SmalltalkCI class methodsFor: 'bootstrapping' stamp: 'fn 1/31/2016 18:17'!
requireSTON
	self isSTONInstalled ifTrue: [ ^ self ].
    	
	self installSTON.
	self isSTONInstalled 
		ifFalse: [ self error: 'STON could not be loaded.' ]! !


!SmalltalkCI class methodsFor: 'helpers' stamp: 'fn 1/31/2016 21:35'!
getAuthor
	^ self platformClass getAuthor! !

!SmalltalkCI class methodsFor: 'helpers' stamp: 'travisCI 1/27/2016 17:03'!
isHeadless
	^ self subclassResponsibility ! !


!SmalltalkCI class methodsFor: 'compatibility' stamp: 'fn 1/31/2016 17:53'!
isPlatformCompatible
	self subclassResponsibility! !

!SmalltalkCI class methodsFor: 'compatibility' stamp: 'fn 1/31/2016 18:22'!
platformSymbol
	^ self platformClass platformSymbol! !


Object subclass: #SmalltalkCISpec
	instanceVariableNames: 'loading testing'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkCI-Core'!

!SmalltalkCISpec methodsFor: 'accessing' stamp: 'EstebanLorenzano 1/26/2016 17:41'!
addLoadSpec: aLoadSpec
	aLoadSpec isComplete ifTrue: [ self loading add: aLoadSpec ]! !

!SmalltalkCISpec methodsFor: 'accessing' stamp: 'fn 1/19/2016 18:24'!
loading
	^ loading ifNil: [ loading := OrderedCollection new ]! !

!SmalltalkCISpec methodsFor: 'accessing' stamp: 'fn 1/19/2016 18:19'!
loading: loadSpecifications
	loading := loadSpecifications! !

!SmalltalkCISpec methodsFor: 'accessing' stamp: 'fniep 1/12/2016 22:15'!
testing
	^ testing ifNil: [ testing := Dictionary new ]! !

!SmalltalkCISpec methodsFor: 'accessing' stamp: 'fniep 1/12/2016 22:15'!
testing: aDictionary
	testing := aDictionary! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SmalltalkCISpec class
	instanceVariableNames: ''!

!SmalltalkCISpec class methodsFor: 'instance creation' stamp: 'fn 1/31/2016 22:15'!
fromStream: aStream
	^ (Smalltalk at: #STON) fromStream: aStream  	! !
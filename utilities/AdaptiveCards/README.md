# Adaptive Cards

## Overview
Adaptive Cards are a new standard for sending "adaptive" content over the internet, primarily aimed at webooks, bots and messaging platforms.

The standard has been implemented in Powershell through the module in this directory, which has all the functionality available in the current LTS version (1.4).

This allows an adaptive card to be generated through a series of functions, which builds the required object in parts and then merges and JSON-encodes this for sending via webhook.

## Adaptive Card Structure
The structure of an AdaptiveCard is as follows:

* A top-level "AdaptiveCard" or "Message" element wraps the content
* Within this, content can be wrapped in "Container" elements for layout
* These containers can hold any number of "Card Elements" with data
* The elements can be hooked into "Card Actions" for two-way interactivity (not implemented at present)

These are implemented through a series of Powershell functions:

* TOP-LEVEL WRAPPERS
	* AdaptiveCard
	* Message

* CONTAINER ELEMENTS
	* ActionSet (TO DO)
	* Container
	* ColumnSet (TO DO)
	* Column
	* FactSet
	* Fact
	* ImageSet (TO DO)
	* Table
	* TableCell
	* TableRow

* CARD ELEMENTS
	* TextBlock
	* Image
	* Media (TO DO)
	* MediaSource (TO DO)
	* CaptionSource (TO DO)
	* RichTextBlock (TO DO)
	* TextRun (TO DO)

* ACTIONS
	* Action.OpenUrl
	* Action.Submit (TO DO)
	* Action.ShowCard (TO DO)
	* Action.ToggleVisibility (TO DO)
	* TargetElement (TO DO)
	* Action.Execute (TO DO)

* INPUTS
	* Input.Text (TO DO)
	* Input.Number (TO DO)
	* Input.Date (TO DO)
	* Input.Time (TO DO)
	* Input.Toggle (TO DO)
	* Input.ChoiceSet (TO DO)
	* Input.Choice (TO DO)

* TYPES
	* BackgroundImage (TO DO)
	* Refresh (TO DO)
	* Authentication (TO DO)
	* TokenExchangeResource (TO DO)
	* AuthCardButton (TO DO)
	* Metadata (TO DO)

# Links to more resources
* https://adaptivecards.io/
* https://adaptivecards.io/explorer/AdaptiveCard.html
* https://messagecardplayground.azurewebsites.net/
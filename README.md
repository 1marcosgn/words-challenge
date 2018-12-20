# DUOProject

This project is a modified word search game, Instead of finding a list of words in the grid, the user needs to find all possible translations of a given word.

Everything starts with a word (the ​source​) and a list of translations for that word (the ​targets​). 

The App display the source word and a grid of letters that contains all the target words. Then the user can try to find all the translations in the grid.

# How does this App works? 

- The user selects a word by pressing down on a letter in the grid, dragging to another letter in the grid, and then releasing their finger. 

- If the selected word is a valid translation of the source word, it should stay highlighted. 

- Otherwise, the selection should disappear. After all the targets have been found, the app should display a new grid and a new source word.

# Source

The source data is a file contains a set of JSON Objects that look like this:

```
{
	"source_language": "en",
	"word": "man",
	"character_grid": [
		["i", "q", "\u00ed", "l", "n", "n", "m", "\u00f3"],
		["f", "t", "v", "\u00f1", "b", "m", "h", "a"],
		["h", "j", "\u00e9", "t", "e", "t", "o", "z"],
		["x", "\u00e1", "o", "i", "e", "\u00f1", "m", "\u00e9"],
		["q", "\u00e9", "i", "\u00f3", "q", "s", "b", "s"],
		["c", "u", "m", "y", "v", "l", "r", "x"],
		["\u00fc", "\u00ed", "\u00f3", "m", "o", "t", "e", "k"],
		["a", "g", "r", "n", "n", "\u00f3", "s", "m"]
	],
	"word_locations": {
		"6,1,6,2,6,3,6,4,6,5,6,6": "hombre"
	},
	"target_language": "es"
}
```

* "word": the source word
* "character_grid": the character grid to be shown
* "word_locations": a dictionary where each key is a list of coordinates in the format [x1,
y1, x2, y2, ..., xn, yn] and the value is the target word in that location.


# Technical Implementation

### Data Models and Protocols

Given the complexity of the JSON Object and the requirement of having a functional and adaptive behavior depending on the Challenges received I created a main protocol called 'DUOChallengeProtocol' to handle all the properties of a Challenge.

<img width="318" alt="screen shot 2018-12-14 at 5 14 23 pm" src="https://user-images.githubusercontent.com/6865674/50037256-41f44300-ffc4-11e8-957d-4ac2254c4867.png">

This protocol contains not only native data types but also a specific kind of object: 'DUOLocation', this object take cares of the format for a given location.

<img width="685" alt="screen shot 2018-12-14 at 3 00 51 pm" src="https://user-images.githubusercontent.com/6865674/50034326-2469ae00-ffb1-11e8-96aa-2764a4b0d8cb.png">

I created also a Model: 'DUOChallengeModel' this object conforms the DUOChallengeProtocol to initialize a challenge making sure all the properties are provided and the Model is created in the right way

<img width="752" alt="screen shot 2018-12-15 at 11 39 03 am" src="https://user-images.githubusercontent.com/6865674/50046797-90562000-005e-11e9-97b5-3859588e11b9.png">


Regarding the Services side, the app has a class: 'DUOServicesImplementer', this class was created to handle the communication with the remote API, fetch the challenges at start and also ask for more challenges if required.

<img width="447" alt="screen shot 2018-12-15 at 6 55 53 pm" src="https://user-images.githubusercontent.com/6865674/50049490-e301fd00-009b-11e9-9e13-e289221c187a.png">

To manage the interaction between the UI and the Data Models, Structures and Services, I created the class DUOChallengeInteractor, this class executes most of the heavy operations making sure that the minimal logic or procees are done in the Controller.

<img width="374" alt="screen shot 2018-12-15 at 9 53 17 pm" src="https://user-images.githubusercontent.com/6865674/50050611-2cab1180-00b5-11e9-92f2-c248199060c5.png">


### Design Patterns Implemented in this Project

A class denominated 'DUOChallengeManager' is a Singleton that controls everything related to the Challenge logic, manages the number of Challenges available to be displayed and also has a method to compare the User selection from the Grid against the "word_locations" so we can determine if the selection matches with the Challenge

<img width="614" alt="screen shot 2018-12-14 at 6 39 36 pm" src="https://user-images.githubusercontent.com/6865674/50038329-cb127680-ffd2-11e8-944c-f9be88835859.png">


I have a 'DUOChallengeFactory' this class is in charge of the creation of DUOChallenges based on the response from the API, it takes the dictionary with the information and basically returns an array of DUOChallnges ready to be displayed.

<img width="440" alt="screen shot 2018-12-15 at 2 37 38 pm" src="https://user-images.githubusercontent.com/6865674/50048081-25194780-0078-11e9-8e32-f8dabc1b9825.png">


### Metodologys 

- TDD: Test driven development to ensure the low rates of issues and fullfillment of the requirements
- Protocol Oriented: Adding protocols to protect the Data Models creation
- OOP: Multiple Objects are being used in this app to transform the Remote Information into Challenges
- MVP: Not really, just an Interactor to try to ease the Charge in the controlllers

### Test Process

Unit tests were implemented since the begining, this was a complete Test Driven Development project, to be sure everything was working as expected, at the end thanks to this Unit Test the Development time went down and also the number of last time issues, this is a screen shot of the almost full coverage of the code, it covers from the data models, structs, patterns and all the way to the Service Implementation. 

<img width="730" alt="screen shot 2018-12-15 at 9 55 41 pm" src="https://user-images.githubusercontent.com/6865674/50050609-11400680-00b5-11e9-82fd-e812f212b6ab.png">

### User Interface (Testing in Multiple Devices)

I have been testing in multiple devices and so far looks good, here you can find some ScreenShots of the app in multiple devices:


### Videos taken at early stage of development when no UI Design was implemented.
| Single Match | Multiple Match | Diagonal Match |
| --- | --- | --- |
| ![single-match](https://user-images.githubusercontent.com/6865674/50089981-323f4f00-01bc-11e9-9e44-3aeb3785dedd.gif) | ![multiple-match](https://user-images.githubusercontent.com/6865674/50090001-3ff4d480-01bc-11e9-9e87-0dba8f51f9bf.gif) | ![diagonal](https://user-images.githubusercontent.com/6865674/50090030-4daa5a00-01bc-11e9-9dbc-56f7f7ce9bb7.gif) |


### Final User Interface Design in multiple devices:
| iPhone X | iPhone 6 | 
| --- | --- | 
| <img width="402" alt="screen shot 2018-12-17 at 12 44 34 pm" src="https://user-images.githubusercontent.com/6865674/50115136-5e2df500-01fb-11e9-945f-545a2c92c215.png"> | <img width="540" alt="screen shot 2018-12-17 at 12 48 20 pm" src="https://user-images.githubusercontent.com/6865674/50115147-671ec680-01fb-11e9-8d8f-de75680dff4a.png"> | 

| iPad | 
| --- |
| <img width="741" alt="screen shot 2018-12-17 at 12 47 07 pm" src="https://user-images.githubusercontent.com/6865674/50115154-6dad3e00-01fb-11e9-9e8d-fdc91e0679c8.png"> | 


Videos:

App Running in iPhone X:
https://drive.google.com/file/d/1Z1Jka7q_p-nM4UEwrQ7bcFFsa6pw9tZa/view?usp=sharing

App Running in iPad Air:
https://drive.google.com/file/d/19Cjqc7vIajWAssoaux7vk8rHRVmOQdwV/view?usp=sharing

App Running in iPhone 6:
https://drive.google.com/file/d/1FUbB9tApKsGfUzN8yAEmhRARxL5QhUXx/view?usp=sharing



### Class Diagram

In the next link you will find a copy of the diagram used to create the base of this project, I try to keep it up to date during these days:
https://drive.google.com/file/d/1H65Sub7yhMY37z4rjjWAUTXYyBtdaZw4/view?usp=sharing

### Where to go from here?

- Portrait mode is the onlye Supported Orientation for this project so far, will be good idea to spend sometime updating this
- UI Test is an excellent option for this kind of project since we have multiple variations of the elements in the grid
- CICD got broken at somepoint during the development process I should be able to fix it soon

### External resources
- I found the icon in this web site (is not my creation):
https://www.iconfinder.com/icons/38924/luigi_mario_icon



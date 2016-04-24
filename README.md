# Mazu - Species recognition for fish

## Inspiration
Currently, there is a lack of data in the fishing industry that supports research for sustainable fishing. Statistics that account for at least half of the global catch are not being documented.

Current methods of gathering information, that involve researchers voyaging with commercial fishing vessels can be intrusive for fishermen. Data collection of the fish is often being collected manually which is both costly and time consuming.

Furthermore, fisherman have a hard time spotting the difference between similar looking fish such as small mouth bass vs. largemouth bass or red eye being misidentified as red snapper.

## What it does
Our app has the ability for users to identify and log fish species that have been caught using IBM's Bluemix visual recognition technology.

Fishermen first take a picture of a fish and it will identify the species automatically. You also have the capability to log the weight, length, breadth, where, and how the fish was caught. A simple graph shows you the total amount of fish logged for each day's catch.

Once the fishermen are back on shore, they will connect to wifi and the data will be uploaded to the cloud and put into a database that scientists and researchers can access in order to forecast estimates of overfishing and give quotas to fisheries to support sustainable fishing.

On a local level, we know that smallmouth bass and largemouth bass are heavily fished in the Ontario Great Lakes. They have very similar features which leads to misidentification, so Mazu could also be applied in order to differentiate the two species.

##How we built it
We use Swift and Xcode to build an iOS app. We used IBM Bluemix's visual recognition api to create custom classifiers to identify the species of fish.

##Challenges we ran into
Integrating Bluemix API with our iOS app.

##What we learned
We learned a lot about the lack of information available to scientists and fisheries about the amount of fish that are caught on a daily basis and how difficult it is to secure working relationships between different organizations/parties who have the information needed by researchers and fisheries across the world.

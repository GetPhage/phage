#Phage - An Immune System for the Internet

This is very much a work in progress and is not really ready yet for anyone else to use or even contribute to. The code is very much in flux.

I've just submitted my first proposal for funding so that I can focus full time on the project.

Phage is a next generation firewall which observes the behavior of devices on a local area network, categorizes them, learns how they normally behave and can automatically block them if they start behaving differently.

Phage consists of several components:

- network (client-side) active scanner and observer
- server side machine learner and categorizer
- (potentially, future) smart phone app for network management

Much of the code that's currently committed is dedicated to actively scanning the network and inspecting devices on it. The really interesting part is the behavioral firewall, which isn't written yet.

##Phage Scanner and Observer

This component sits in your network's router and actively scans your network in order to identify devices on it.

It also observes their behavior - how often do they connect to the Internet, what servers do they connect to, how much data or bandwidth do they use, what services do they connect to.

Currently this is in the proof-of-concept phase - in order to speed development, thse components are currently written in Ruby. For production use they'll need to be rewritten in C with an eye toward minimizing resource use.

##Phage Server and Learner

Phage Server is being gradually built using Rails. Currently the
scanner is tightly coupled to the server; they need to be split and
start using the JSON REST API.

As of yet no work has been done on the learner.

##Installation

This is really not ready for anyone else to use at this point. It
almost certainly won't work out of the box today.

To install,

`git clone git@github.com:GetPhage/phage.git`

Then

`cd phage`

and

`bundle install`

You'll need to set up Postgres manually for now. Then

`bin/rake db:create db:migrate`

##Operation

###Import OUIs

To import MAC address prefixes from IEEE:

`bin/rake oui:import`

###Import CVEs

To import Common Vulnerability and Exposures:

`bin/rake cve:import`

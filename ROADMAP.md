# Phage Project Roadmap

First cut at this.

I'm currently running Phage exclusively on my own network.

I need to collect more data.

## Scanners

Get `passive`, `port`, `upnp` and `mdns` scanners working reliably.

Implement and test `behavior` scanner which records traffic matrix, services and throughput.

## Devops

Try `sneakers` for the job runner instead of `backburner`.

Proper deploy mechanism, probably through Capistrano.

Get working correctly under Vagrant.

## Hardware

Choose and test a small, relatively cheap hardware build that can be used for scanning.

This will need two ethernet ports and will bridge or route while building a traffic and bandwidth matrix.

Consider a Raspberry Pi 3 with a USB ethernet port. Get one, set it up as a simple bridge and see if it's reliable.

## Machine Learners

Consider the data set used to train machine learners.

Evaluate different algorithms and choose one or two to try out.

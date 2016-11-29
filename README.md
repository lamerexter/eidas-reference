# eidas-reference [![Build Status](https://travis-ci.org/alphagov/eidas-reference.svg?branch=master)](https://travis-ci.org/alphagov/eidas-reference)

This repository contains a fork of the eIDAS reference implementation provided by CEF digital.
The original code can be obtained [here](https://ec.europa.eu/cefdigital/wiki/display/CEFDIGITAL/eIDAS-Node).

*NOTE: It's highly recommended that you use the official reference implementation and not this fork.*

## Licence

This code maintains its original copyright (2016 European Commission) and is licenced under the
[European Union Public Licence](https://ec.europa.eu/cefdigital/wiki/download/attachments/30771884/eupl1.1.-licence-en_0.pdf).

## Getting Started

There are [thorough instructions for getting set up on a range of application servers (pdf)](https://ec.europa.eu/cefdigital/wiki/download/attachments/30771884/eIDAS%20Node%20Installation%20Manual%20v1.1.pdf)
provided by CEF digital.

If you just want to get up and running quickly we recommend you use [tomcat](https://tomcat.apache.org/), for which we've provided some scripts to help get you started.

Regardless, you'll need to install [a version of the JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) (1.7 or higher, we recommend 1.8)
with the [Unlimited Strength Jurisdiction Policy Extension](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html) installed
(see [this blog post](http://suhothayan.blogspot.co.uk/2012/05/how-to-install-java-cryptography.html) for instructions).

### Running the tests

From the `EIDAS-Parent` folder run `mvn test`.

### Running the applications locally with Tomcat

Setting up tomcat (you should only need to do this once):

```
# Download a tomcat .zip file from https://tomcat.apache.org/download-80.cgi

# This will create a folder with 4 tomcat instances (one for each of the stub-idp, connector-node, proxy-node and stub-sp) in ~/eidas-tomcat:
./scripts/create-tomcat.sh ~/Downloads/apache-tomcat-8.5.8.zip
```

Deploying and running the applications:

```
# This will build and deploy the applications to their tomcat folders:
./scripts/deploy-tomcat.sh

# This will start the tomcat instances:
./scripts/start-tomcat.sh

# And when you're done, stop the instances with:
./scripts/shutdown-tomcat.sh
```

#### Where to find the applications

Tomcat will run on ports 50400, 50401, 50402 and 50403, so if all is well the applications will be reachable at:

* Stub Service Provider - [http://localhost:50400](http://localhost:50400)
* Connector Node - [http://localhost:50401](http://localhost:50401)
* Proxy Node - [http://localhost:50402](http://localhost:50402)
* Stub Identity Provider - [http://localhost:50403](http://localhost:50403)


### Editing the code

You can import the code into your IDE of choice by pointing it at the pom.xml in EIDAS-Parent.


# Autodesk Forge Samples (Ruby on Rails)

[![Ruby](https://img.shields.io/badge/ruby-2.3.0-blue.svg)](https://www.ruby-lang.org/en/)
[![Rails](https://img.shields.io/badge/rails-5.1.1-blue.svg)](http://rubyonrails.org/)
[![jQuery](https://img.shields.io/badge/jquery-1.12.4-blue.svg)](https://jquery.com/)
[![Bootstrap](https://img.shields.io/badge/bootstrap-3.3.7-blue.svg)](http://getbootstrap.com/)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://opensource.org/licenses/MIT)

[![oAuth2](https://img.shields.io/badge/oAuth2-v1-green.svg)](http://developer.autodesk.com/)
[![Data-Management](https://img.shields.io/badge/Data%20Management-v2-green.svg)](http://developer.autodesk.com/)
[![OSS](https://img.shields.io/badge/OSS-v2-green.svg)](http://developer.autodesk.com/)
[![Model-Derivative](https://img.shields.io/badge/Model%20Derivative-v2-green.svg)](http://developer.autodesk.com/)

## Overview
This app provides multiple samples on using the Autodesk Forge Web Services APIs:

### Sample 1
The first sample demonstrates how to use the [OAuth](https://developer.autodesk.com/en/docs/oauth/v2/overview/), [Data Management](https://developer.autodesk.com/en/docs/data/v2/overview/) and [Model Derivative](https://developer.autodesk.com/en/docs/model-derivative/v2/overview/) Forge APIs, as well as the Forge [Viewer](https://developer.autodesk.com/en/docs/viewer/v2/overview/) JavaScript library. It shows the following typical workflow:

* Create a 2-legged authentication token
* Create a bucket (an arbitrary space to store objects)
* Upload a file to the bucket
* Prepare the file for displaying in the Viewer (translate the file into SVF format)
* Show the translated file in the Viewer

It is based on the [forge-ruby-sample-app](https://github.com/Autodesk-Forge/forge-ruby-sample-app) but runs as a Rails App

### Sample 2
The second sample focuses on 3-legged [OAuth](https://developer.autodesk.com/en/docs/oauth/v2/overview/) authentication and [Data Management](https://developer.autodesk.com/en/docs/data/v2/overview/). It:

* Generate 3-legged authentication token from user authorization
* Explore user hubs from different Autodesk services
  (BIM360 Team hub, a Fusion Team hub, an A360 Personal hub or a BIM360 Docs account)
* Display all projects in a selected hub
* Display all elements (folders/files) inside a project with their properties and links
* Download files
* Upload a file to project folder
* Prepare the file for displaying in the Viewer (translate the file into SVF format)
* Show files in the Viewer

### Requirements
The app is based on Rails 5.1.1, Ruby 2.3.0, jQuery 1.12.4 and Bootstrap 3.3.7 
no compatability checks have been made on earlier releases.

### Installation
```$ bundle install ```

### Create an App

[Create an app](https://developer.autodesk.com/en/docs/oauth/v2/tutorials/create-app/) on the Forge Developer portal, and ensure that you select the Data Management and Model Derivative APIs. Note the client ID and client secret.

### Configure the Parameters

Open the *config/secrets.yml* file, and replace `FORGE_CLIENT_ID` and `FORGE_CLIENT_SECRET` with the client ID and client secret generated when creating the app, or create 2 environment variables with the same name.

```export FORGE_CLIENT_ID=abcd... ```

```export FORGE_CLIENT_SECRET=efgh... ```

### Run the App
```$ rails server ```

### Deploy on Heroku
To deploy this application to Heroku, the Callback URL & redirect_uri must use your .herokuapp.com address. After clicking on the button below, at the Heroku Create New App page, set FORGE_CLIENT_ID and FORGE_CLIENT_SECRET config vars.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/ahmad-hisham/forge-tutorial)


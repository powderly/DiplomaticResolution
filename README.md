# The Purpose of this Repo

This repo contains Research in progress: Scripts and sets collected to enable the analysis and visualization of data associated with photos and videos uploaded directly to Instagram from within The Democratic People's Republic of Korea (aka North Korea). It is a part of an artwork, called ["A Diplomatic Resolution"](http://wikipowdia.org/diplomaticresolution), which is currently (June 5th, 2014) installed in the Golden Lion-winning Korean Pavilion, "Crow's Eye View", at the 14th International Architecture Exhibition la Biennale di Venezia. The artwork aggregates photos that have been directly uploaded to Instagram from within the DPRK. The photo metadata is also aggregated in the form of multiple JSON data sets and is cleaned and tidy'd for analysis and visualization. You are free to download the data and scripts and use them for whatever purposes you choose. If you would like to contribute to the "A Diplomatic Resolution", please email me at [powderly at fffff dot at](mailto:powderly@fffff.at).


![diplomatic resolution cover photo](http://wikipowdia.org/images/logo/diplomaticresolution.jpg)
## Diplomatic Resolution, 2014 Artist Statement

[Jump to "A Diplomatic Resolution"](http://wikipowdia.org/diplomaticresolution)

## THE DATA AND CODE

This Repo contains the following datasets:
* Multiple aggregated JSON datasets from Instagram
* A master data set that has been cleaned, reformated and merged
* A directory of directories of photos downloaded from Instagram
* Several R scripts for data collection, analysis

### Why and how I restructured the Instagram JSON response data

The Instagram V1 API is a RESTful API that allows the user to access Instagram's repository of user-generated content via http requests to a fixed set of "endpoints" or data targets. The Instagram API is documented [here](http://instagram.com/developer/#). The instagram response data is complete and well-formatted. It does not allow every possible type of media request via their "endpoint" offerings, but it cover's most of the bases. In the case of Diplomatic Resolution, the goal is to try to find a many photos as possible *of* North Korean that we can also confirm were uploaded from *within* the borders of North Korea. Instagram allows users to request media by location_id, location_name, longitude & latitude within a radius upto 5km, by tag and by user. It also allows the API user to subscribe to new uploads from a specific location or from within a given geographical range. Location id, name, and long/lat offer the most reliable data we can get. But location ids/names (which themself are provided to Instagram via Foursquare and Facebook's API) have relatively little coverage within North Korea, the 5km long/lat range does not offer full coverage of even Pyonyyang and the subscriptions do not backfill older uploads. Each location ID, name of geography range requires a seperate request to receive a maximum of 20 photos/videos at a time. Older requests must be made using a "pagination" URL that allows you to step back through the dataset until the dataset is exhausted or the API user stops makeing requests. Additionally, we may want to look at photos that are tagged #pyongyang, #northkorea, #dprk, #nkorea, etc and then also check their upload location longitude and latitude to discover additional direct uploads. So, we needed to combine multiple endpoint requests, collect and store all the data (from now until November 2012, which is the first time photos were allowed to be uploaded directly from within Korea by foreign visitors), merge it and order it. And the ultimate goal is to create a very tidy dataset that users can download and play with in order to create data studies and data visualizations using this unique data. This is why we chose to convert the JSON request data into a wide-format data.frame in R and expand, as much as possible, the nested value pairs, and arrays of data pairs, provided by Instagram (it is not possible, I think, to get rid of all the nested value pairs and required in a few cases to next data.frames within the master data.frame -- as described in the CodeBook). This is the rationale for the following conversion. 

## CODEBOOK
### Conversion Guide

The following table illustrates the basic structure of the Instagram API response and how the data was unpacked from the nested JSON value pairs and massaged into a data.frame in R

| OLD Instagram JSON Envelope | OLD Labels | OLD Nested Pairs | OLD Nested Pairs | (becomes) |OLD Nested Pairs | NEW Master Data Frame Labels | NEW Nested Values | 
| --- | --------- |                    ---|              --- |       --- |---|                               ---| ---            | 
| meta|           |                       |                  |           |    |  "discared"                             | |
|    | code      |                       |                  |           |    |  "discared"                              | |
|    |           |                       |                  |           |   |  "discared"                               |  |   
| pagination | next_url |                 |                  |           | |   "discared"                               | |
|    | next_max_id |                     |                  |           | |   "discared"                                | |
|    |           |                       |                  |           ||    "discared"                                | |
|data|	tags 	|						|	               |           | -->   |tags								| |
|	| location	| latitude				|                  |	       | -->   |location_lattitude					||
|    |           | name					|    		       |           | -->   |location_name						||
|	|		    | longitude				|		           |	       | -->   |location_longitude					||	
|	|     	    | id					|				   |		   | -->   |location_id						||
|	| comments	| count					|				   | 	 	   | -->   |comments_count						||
|	|	data	| created_time			|				   |	 	   | -->   |comments_data						| created_time |
|    |           | text					|				   |		   |-->   |						 			| text |
|    |           | from	                | username		   |		   |-->   |									| from_username |
|	|			|                       | profile_picture  |		   |-->   |									| from_profile_picture |
|	|			|	                    | id			   |		   |-->   |									| rom_id |
|	|			|	                    | full_name		   |		   |-->   |									| from_full_name |
|	|		    | id					|				   | 		   |-->   |									| comment_id |
|	| filter	|						|				   |		   | -->   |filter	                            |
|	| created_time |                    |				   |		   | -->   |created_time	|
|	| link		|						|			       |		   | -->   |link	|
|	| likes	    | count					|				   |		   | -->   |likes_count	 |
|   |           | data                  | username		   |		   | -->   |likes_data							| username |
|	|			|	                    | profile_picture  |		   |-->   |									| profile_picture |
|	|			|	                    | id			   |		   |-->   |								    | id |
|	|  			|                 	    | full_name		   |		   | -->   |								    | full_name |
|	| images	| low_resolution 	    | url			   |		   | -->   |image_low_resolution_url	|
|	|		    |					    | width			   |		   | -->   |image_low_resolution_width	|			   		   			    
|	|		   	|	   			        | height	       |		   | -->   |image_low_resolution_height |	
|	|		    | Thumbnail		        | url			   |		   | -->   |image_thumnbail_resolution_url |	
|	|			|				        | width			   |		   | -->   |image_thumnbail_resolution_width  |	
|	|			|				        | height		   |		   | -->   |image_thumnbail_resolution_height	|
|	|		  	| standard_resolution	| url			   |		   | -->   |image_standard_resolution_url	|
|	|			|				        | width			   |		   | -->   |image_standard_resolution_width   |	
|	|			|					    | height		   |		   | -->   |image_standard_resolution_height	|
|	| users_in_photo | users		    | username	       |		   | -->   |users_in_photo						| users_in_photo_username |
|	|			|					    | full_name		   |		   |-->   |				 					| users_in_photo_full_name |
|	|		    |                       | id			   | 		   | -->   |									| users_in_photo_id |
|	|			|				        | profile_picture  |		   | -->   |									| users_in_photo_profile_picture |
|	|			| 						| position	       | x		   |-->   |									| users_in_photo_x_position |
|	|			|					    |                  | y		   |-->   |									| users_in_photo_y_position |
|	| caption   | created_time		    |	               |       	   | -->   |caption_created_time	|
|	|	        | text					|				   |		   | -->   |caption_created_text	|
|	|	        | from	                | username		   |		   | -->   |caption_from_username	|
|	|			|		                | profile_photo	   |		   | -->   |caption_from_profile_photo	  |
|	|			|	                    | id			   |		   | -->   |caption_from_id	|
|	|			|	             	    | full_name		   |		   | -->   |caption_from_full_name  |	
|	|		 	|		                | id			   |		   | -->   |caption_id	  |
|	| type		|					    |                  | 		   | -->   |||
|	| id		|				        |                  |           | -->   |||
|	| user      | username				|				   |		   | -->   |user_username	||
|	|	        | website				|				   |		   | -->   |user_website	||
|	|	        | profile_pictures		|				   |		   | -->   |user_profile_picture ||	
|	|	        | full_names			|				   |		   | -->   |user_full_names	||
|	|	        | bio					|				   |		   | -->   |user_bio	||
|	|	        | id					|				   |		   | -->   |user_id	||
|	| attribution|						|					|		   |-->   |	"discared" ||						


### Master Data Frame label -> Variable Codebook

The master data frame has 34 character class variables and 3 data frames
|master tidy data frame labels |  class					| variables|
|---						   |---				|---					|
|tags							|				|	photo hashtags										|
|location_lattitude|											| lat
|location_name|											| location name using facebook/foursquare API |
|location_longitude|											| long|
|location_id        |        											| location ID on facebook/foursquare API|
|comments_count		|											| number of comments|
|comments_data|								data.frame			| comments data.frame (see below)| 
|filter		|											| the type of instagram photo filter effect|
|created_time|													| when the photo was uploaded|
|link		|											| link to the instagram page|
|likes_count|													| number of likes|
|likes_data ## like data here|								data.frame			| like data.frame|
|image_low_resolution_url	|												|  306 x 306 image url|
|image_low_resolution_width	|												| 306 pixels|
|image_low_resolution_height|													| 306 pixels|
|image_thumnbail_resolution_url|												|	150 x 150 pixel image url| 
|image_thumnbail_resolution_width|													| 150 pixels|
|image_thumnbail_resolution_height|													| 150 pixels|
|image_standard_resolution_url		|											| 640 x 640 image url| 
|image_standard_resolution_width	|												| 640 pixels|
|image_standard_resolution_height	|												| 640 pixels|
|users_in_photo	## users in photo data here|				data. frame							| users in the photo data.frame|
|caption_created_time		|											| caption created time |
|caption_created_text		|											| the caption text| 
|caption_from_username		|											| caption contributor username |
|caption_from_profile_photo	|												| caption contributor profile photo |
|caption_from_id		|											| caption contributor by full name |
|caption_from_full_name	|												| caption contributor by id |
|caption_id		|											| event id of the caption |
|type		|											| type of media vid or photo |
|id		|											| id of the uploaded |
|user_username|													|  username of the uploader |
|user_website	|												|  website of the uploader|
|user_profile_picture		|											| profile pic of the uploader|
|user_full_names		|											| full name of thge uploader|
|user_bio		|											| bio of the uploader|
|user_id	|											| id of the uploader|

|comments data frame 				|		variables					|
|---								|------						|		
|created_time        | 			comment creation time								|
|text	|						the text of the comment					|
|from_username|					comment contributor username							|
|from_profile_picture|		    comment contributor pic url									|
|from_id	|					comment contributor id				 		|
|from_full_name|				comment contributor full name							|	
|comment_id|					comment event id						|

|likes data frame|								 variables|
|--- |--- |
|username	|		the like contributor								|
|profile_picture	|				the like contributor pic url							|
|id |								the like contributor ID		|
|full_name |						full name of the like contributor						|
	
|users in photo data frame		|	variables							|
|--- 								|---							|
|users_in_photo_username|			a user tagged in the photo								|
|users_in_photo_full_name|			the full name of a user tagged in photo								|	
|users_in_photo_id|					the id of a user tagged in photo						|
|users_in_photo_profile_picture|	a pic of the user  tagged in photo url										|
|users_in_photo_x_position|			the x position of the user tagged in photo						|
|users_in_photo_y_position|			the y position of the user tagged in photo									|


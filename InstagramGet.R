#-------------------------------------------------------------------
# create JSON file and download Instagram photos sets by #hashtag or location
# (read Instagram API V1.1 terms of use for bandwith restrictions and quota,
# requests must be < 5000/hour)
# For the Korean Pavilion (A Bird's Eye View), 2014 Venice Architecture Bienale
# A Diplomatic Resolution
# aggregated photos uploaded from North Korea plus analysis and data viz
# http://wikipowdia.org/diplomaticresolution
# @jamespowderly
# github.com/powderly/instagram
#-------------------------------------------------------------------

#----------------------------------------------------------------------
# INPUT: InstagramGet(type = "location", msg="16677943", id="20b4ce6d65b143d596f3a3ffc75dfae6", dl="FALSE")
# type: location
#       hashtag
#
# msg:  location_ID
#       hashtag
#
# id: instagram client ID
# register here: http://instagram.com/developer/#
# dl =  FALSE 
#       low_resolution
#       standard_resolution
#       thumbnail
# 
# OUTPUT:
#       JSON file (name: "location" or "hashtag" + "_" + unique_number + ".txt")
#       a directory of images (name: "location" or "hashtag" + "_" + "_" + date + "_" + time)
#-------------------------------------------------------------------

InstagramGet <- function(type = "location", msg="16677943", id="20b4ce6d65b143d596f3a3ffc75dfae6", dl="false"){
        
        ##---- software requires 3 package source installs jsonlite, lubridate and memoise
        ##install.packages("jsonlite")
        ##install.packages("lubridate") and its dependency memoise
        ##install.packages("gsub") and its dependency ptoto
        ##install.packages("RCurl") and its dependency bitops
        
        library(jsonlite)
        library(lubridate)
        library(memoise)
        library(gsubfn)
        library(proto)
        library(RCurl)
        library(bitops)
        
        ##----- start by creating a file and opening a connection to it
        ##----- check if it exists if not make it. and connect
        filename <- paste(type, "_", msg, ".json", sep="")
        
        if(file.exists(filename)){
                print("file already exists. opening...")
        }else{
                file.create(filename)
        }
        
        
        ##--- create an empty array for our URLs and IDs in order to download instagram images
        urls <- vector(mode="character", length=0)     
        ids <- vector(mode="character", length=0)   
        ##--- a list of usernames in order to navigate the JSON file more easily
        instaNames <- c("type", "users_in_photo", "filter", 
                        "tags", "comments", "captions", "likes", 
                        "link", "user", "created_time", "images", 
                        "user_has_liked", "id", "location")
        
        ##--- unique id based on time and gsub to be appropriate for a file or directory name
        now <- now(tzone = "GMT")
        now<-gsub(":", "-", now)
        now<-gsub(" ", "-", now)
        
        ##--- create download directory and name
        if(dl!="FALSE"){
                imgdir <- paste(getwd(), "/", now, "_", type, msg, sep="")
                dir.create(imgdir)
        }
        
        ##determine desired endpoint type: either hashtag, facebook or foursquare location id or location lat and long
        if (type == "location") {
                api <- paste("https://api.instagram.com/v1/locations/", msg, "/media/recent?client_id=", id, sep="")
        } else if (type == "hashtag"){
                api <- paste("https://api.instagram.com/v1/tags/", msg, "/media/recent?client_id=", id, sep="")
        }
        
        ##----- make n number JSON requests to an instagram endpoint
        ##----- while there is an existing data$pagination$next_url
        
        ##----- Write selected JSON responses to a file, concatenate for each pagination
        ##----- Eventually we will merge this data with other json responses
        
        ##----- Based on user input grab the right photo resolution URL and create a list for download

        
        while(length(api) >0){
                data <- fromJSON(getURL(api))
                ##----- download images to the premade folder and title them with the user ID + time
                if (dl != "FALSE"){
                        url <- data$data$images$standard_resolution$url
                        id <- data$data$user$id
                        urls <- append(urls, url)
                        ids <- append(ids, id)
                }
                ##----- write the json data to an open text file connection
                
                nextid <- data$pagination$next_max_id
                api <- data$pagination$next_url  
        }
        ##----- close the connection
        ##----- download the images to an imagedir in your working diretory        
        if(dl!="FALSE"){
                for (u in 1:nrow(downloads)) {
                        output <-paste("dip_res_", u)
                        temp <- paste(imgdir, "/", ids[u], now, "_", output, ".jpg", sep="")
                        print(output)
                        download.file(urls[u], temp, mode="wb")
                }
        }
        
}


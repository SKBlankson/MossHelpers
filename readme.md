## Using De-Zip and F_Collect
### Description: 
**De-zip:** De-Zip unzips files and places them in a new folder which has the same name as the 
original zip file
**F_Collect:** F_Collect collects files of a specific type and palces them in a new folder containing the same file name

***
## Instructions ##
### Adding `dezip` and `f_collect` to your project
1. Download the assignment files from canvas. Unzip it so that all the students zipped submissions are placed in a common 
folder
2. Place `dezip.sh` and `f_colelct.sh` within the folder that contains the individual zipped submissions
3. Open up a terminal window and change your current working directory to the folder that contains the students zipped assignments
4. Once there run the following command to change the permissions for dezip and f_collect:

    `chmod 777 dezip.sh f_collect.sh`

### Using `dezip` to extract and rename submissions
1. Run the command `./dezip.sh`

    This will extract all the zip files and place them in separate folders.
   **However, take note that it also deletes the original zip folders as they are no longer needed** 
2. At this point, you should have all the submissions extracted with their original zip files deleted

### Using `f_collect.sh` to collect files of a given file type
Usually, you want to collect files of a given file type. In this example, I will be collecting only java files
1. Run the command `./f_collect.sh -f java`
    
    The `-f` flag specifies the file extension that should be collected. So if you wanted to collect java and txt files you would simply use the command `./f_collect -f java txt`
2. At this point, the script will create a new folder called `collected_files` which contains the specified file types for each submission

### Finally, Run Moss ###
1. Now, you can cd to the `collected_files` folder
2. Place your moss.pl file within the collect_files folder and change the permissions like you did earlier for dzip
2. A typical moss commnand when you used dezip and f_collect looks like: 

` ./moss.pl -l java -b ./basefiles/Car.java -b ./basefiles/ProcessCarData.java -d ./*/*`

**The various flags mean**:<br>
**-l** The target language is java<br>
**-b** The base files for the comparison are located in these directories<br>
**-d**  The submissions are to be taken folder by folder <br>


***
There are still a couple of bugs that need to be worked out but this works for the most part if used correctly 
#!/bin/bash

TEMPLATE="$HOME/jupyter_notebooks/template.ipynb"
if [ ! -f "$TEMPLATE" ]; then
	echo "Cannot find template at path: $TEMPLATE"
	echo "Exiting..."
	exit 1
fi

##### Functions
convertpdf(){
	local imgs_folder_name="$1_imgs"
	local lecture_slides_pdf_name=$2
	echo "Converting lecture slides to images..."
	
	# Create subfolder for images:i
	mkdir lecture_slides/$imgs_folder_name

	# Convert each page in the lecture_slides_pdf_name into an image:
	convert -density 150 lecture_slides/$lecture_slides_pdf_name -quality 90 lecture_slides/$imgs_folder_name/$1_%03d.jpg
}

copynotebook(){
	# Variables:
	local notebook_name=$1

	echo "If $1.ipynb does not exist"
	echo "-> Create new notebook $1.ipynb from template..."
	cp -n $TEMPLATE "$1.ipynb"
	
	# Format notebook:
	local lec_number=${notebook_name%_*}	# remove suffix starting with "_"
	local lec_title=${notebook_name#*_}	# remove prefix ending with "_"
	local lec_title=${lec_title^}		# Make lec_title uppercase
	
	# Write lecture number and title on the notebook's first line
	# (The first line in the Jupyter Notebook (.ipynb) is line 7 
	# in the text file version of a Jupyter Notebook)
	# local NEWLINE='\\n'
	sed -i "7 s/N/$lec_number: $lec_title/" $notebook_name.ipynb 
}

insertimages(){
	local notebook_name=$1
	local imgs_folder="$1_imgs"
	local line_count=7
		
	local img_html_str='	"<img src=\\"./X\\" width=\\"1000\\"/>\\n",'
	local newline_str='	"\\n",'

	echo "Inserting images into $notebook_name..."
	
	for img in lecture_slides/$imgs_folder/*.jpg
	do
		# echo "Processing image $img..."

		# Insert the file path into the string for showing an image 
		# in a Jupyter notebook with html:
		mod_img_html_str=${img_html_str//[X]/$img}
		sed -i "$line_count a\ $mod_img_html_str" $notebook_name.ipynb
		let "line_count += 1"

		# Insert an empty line after the image:
		sed -i "$line_count a\ $newline_str" $notebook_name.ipynb
		let "line_count += 1"
		
		done
}

copynotebook $1
convertpdf $1 $2
insertimages $1

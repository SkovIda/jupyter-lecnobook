# Description
This bash script is designed to automatically setup a jupyter notebook for taking study notes at a lecture where a pdf presentation is provided.

It automatically creates a new jupyter notebook from a template (template.ipynb) and adds the lecture number and tiltle to the document heading. It converts all pages of a pdf document into images (.jpg) and place them in a new subfolder. The images are then automatically inserted into the first markdown cell (right after the document heading) in the new jupyter notebook with html.

**The script contains 3 functions, which are called in the following order:**
1. `copynotebook()`: Creates a new jupyter notebook from a template.ipynb and writes the lecture number and lecture title as the heading of the first markdown cell in the notebook.
1. `convertpdf()`: Converts all pages of a pdf document into images and place them in a new subfolder. It converts the .pdf document to .jpg images.
1. `insertimages()`: The images of each page in the presentation (.pdf) are inserted into the first markdown cell (right after the document heading) in the new jupyter notebook with html - HTML enables easy scaling of the width of the images. I have set it to `width=1000`, but this can easily be changed in script.
    - **NOTE:** If the notebook file already exists, this function *DOES NOT* overwrite the content of it, it just inserts the images after the heading of the notebook.
    - **OBS:** When calling this function, the first cell in the notebook must be a markdown cell and it must contain at least two lines of text, otherwise it might not be possible to open the file as a jupyter notebook without editing the file in a text editor so it complies with the jupyter notebook formatting first.


# Requirements
1. `imagemagick` (Works for version 6)
    - **OBS:** You need to manually enable parsing pdf in imagemagick by editing the `/etc/ImageMagick-7/policy.xml` file and removing PDF from `<policy domain="coder" rights="none" pattern="{PS,PS2,PS3,EPS,PDF,XPS}" />`
1. Jupyter notebook environment named and located as: `$HOME/jupyter_notebooks/`
1. File structure as desribed in [Usage](#usage) section.

# Usage
1. `template.ipynb` must be located in the root of the jupyter_notebooks environment
<!-- 1. Create a folder for the course within the jupyter notebooks environment and place the -->
1. `init_new_notebook.sh` must be in a subfolder to `$HOME/jupyter_notebooks/`
1. Each course folder must contain a subfolder named `lecture_slides/`
1. Lecture slides must be in PDF format and placed in the `lecture_slides` folder.
1. **Example of file structure after adding a new course and the presentation for the first lecture of that course:**

        jupyter_notebooks
        ├── course_folder
        │   ├── lecture_slides
        │   │   ├── 01_introduction.pdf
        │   ├── init_new_notebook.sh
        └── template.ipynb


**Running the script from a terminal in the root of the course folder:**

    $ ./init_new_notebook.sh 01_introduction 01_introduction.pdf

**Input arguments:**
1. The number and name of the lecture on the form: `<number>_<title>`
    - For example: `01_introduction`, where the lecture number is `01` and the lecture title is `introduction`.
1. The name of the pdf presentation: e.g., `01.introduction.pdf`


**After running the script:**

    jupyter_notebooks
    ├── course_folder
    │   ├── lecture_slides
    │   │   ├── 01_introduction_imgs
    │   │   │   ├── *-000.jpg
    │   │   │   ├── *-001.jpg
    │   │   │   ├── ...
    │   │   │   ├── *-xxx.jpg
    │   │   ├── 01_introduction.pdf
    │   ├── 01_introduction.ipynb
    │   ├── init_new_notebook.sh
    └── template.ipynb

# Main Workflow - xaringan-template
# Contributors: @lachlandeer

import glob, os

# --- Importing Configuration Files --- #

configfile: "config.yaml"

# --- Subworkflows --- #
subworkflow slides:
   workdir: config["src_slides"]
   snakefile: config["src_slides"] + "Snakefile"

# --- Main Build Rules --- #

rule all:
    input:
        slide_bld = slides("../../" + "slides.html")
    output:
        slides = config["PROJ_NAME"] + ".html"
    shell:
        "mv {input.slide_bld} {output.slides}; \
        rm -rf slides_files/"

# --- Packrat Rules --- #

## packrat_install: installs packrat onto machine
rule packrat_install:
    shell:
        "R -e 'install.packages(\"packrat\", \
            repos=\"http://cran.us.r-project.org\")'"

## packrat_install: initialize a packrat environment for this project
rule packrat_init:
    shell:
        "R -e 'packrat::init()'"

## packrat_snap   : Look for new R packages in files & archives them
rule packrat_snap:
    shell:
        "R -e 'packrat::snapshot()'"

## packrat_restore: Installs archived packages onto a new machine
rule packrat_restore:
    shell:
        "R -e 'packrat::restore()'"

# --- Cleaning Rules --- #

## clean_all      : delete all output and log files for this project
rule clean_all:
    shell:
        "rm -rf out/ log/ *.pdf *.html"

## clean_logs     : delete all log files for this project
rule clean_log:
    shell:
        "rm -rf log/"

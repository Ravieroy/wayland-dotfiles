#!/bin/bash

file_pdf=$(zenity --file-selection --title="Select your PDF file")
/usr/bin/pdfpc "$file_pdf"

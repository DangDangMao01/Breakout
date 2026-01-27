yourDir = "D:\\test\\1"
makedir yourDir
absPath = getDirectories yourDir 

dosCommand ("rmdir " + absPath[1] + "/S /Q")
deletefile yourDir
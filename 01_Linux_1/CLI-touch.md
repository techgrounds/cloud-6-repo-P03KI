	
The touch command is the easiest way to create new, empty files. It is also used to change the timestamps (i.e., dates and times of the most recent access and modification) on existing files and directories.

touch's syntax is

  touch [option] file_name(s)

When used without any options, touch creates new files for any file names that are provided as arguments (i.e., input data) if files with such names do not already exist. Touch can create any number of files simultaneously.

Thus, for example, the following command would create three new, empty files named file1, file2 and file3:

  touch file1 file2 file3

A nice feature of touch is that, in contrast to some commands such as cp (which is used to copy files and directories) and mv (which is used to move or rename files and directories), it does not automatically overwrite (i.e., erase the contents of) existing files with the same name. Rather, it merely changes the last access times for such files to the current time.

Several of touch's options are specifically designed to allow the user to change the timestamps for files. For example, the -a option changes only the access time, while the -m option changes only the modification time. The use of both of these options together changes both the access and modification times to the current time, for example:

  touch -am file3

The -r (i.e., reference) option followed directly by a space and then by a file name tells touch to use that file's time stamps instead of current time. For example, the following would tell it to use the times of file4 for file5:

  touch -r file4 file5

The -B option modifies the timestamps by going back the specified number of seconds, and the -F option modifies the time by going forward the specified number of seconds. For example, the following command would make file7 30 seconds older than file6.

  touch -r file6 -B 30 file7

The -d and -t options allow the user to add a specific last access time. The former is followed by a string (i.e., sequence of characters) in the date, month, year, minute:second format, and the latter uses a [[CC]YY]MMDDhhmm[.ss] format. For example, to change the last access time of file8 to 10:22 a.m. May 1, 2005, 1 May 2005 10:22 would be enclosed in single quotes and used as follows, i.e.,:

  touch -d '1 May 2005 10:22' file8

Partial date-time strings can be used. For example, only the date need be provided, as shown for file9 below (in which case the time is automatically set to 0:00):

  touch -d '14 May' file9

Just providing the time, as shown below, automatically changes the date to the current date:

  touch -d '14:24' file9

The most commonly used way to view the last modification date for files is to use the ls command with its -l option. For example, in the case of a file named file10 this would be

  ls -l file10

The complete timestamps for any file or directory can be viewed by using the stat command. For example, the following would show the timestamps for a file named file11:

  stat file11

The --help option displays a basic list of options, and the --version option returns the version of the currently installed touch program.

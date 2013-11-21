ruby-filesplitter
=================

Split a file into multiple pieces, and combines them again.

I roll around with 2 GB USB Flash sticks like a peasant. If I have a file larger than that, I end up needing to split it up into multiple pieces so I can fit it into my many USB sticks. That's my personal use case.

Maybe you want to build a tool that'll split a big file up into smaller chunks for easier emailing? Whatever the case may be, I hope this is as useful for others as it is for me.

### Usage
-----
First:
`require 'splitter'`

#### Splitting a file
```
file = Splitter::Split.new("file.zip", 280000) # Default size is 1000000 bytes, 1 MB
```

The file will be split into multiple pieces of whatever size (in bytes) you provide. If the file is 10 MB and you split into 1,000,000, you'll end up with 10 files each at 1 MB.

```
file.process # Splits the file into parts

file.total_parts # Returns the total number of parts
file.filesize # Returns the size of the file
file.present? # Checks the existence of the provided file/filename
file.filename # Returns the filename
```

#### Join a file from split parts
```
file = Splitter::Join.new("file.zip")
```

It will find the part files in the same directory (denoted by the ".splitter#" extension) and recombine them.

```
file.process # Combines the parts into one file
file.process_and_destroy # Combines the parts and destroys the individual parts in the process
```

Pretty simple.

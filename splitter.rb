module Splitter
  class Split
    def initialize(filename, size = 1000000) # Default, 1 MB chunks
      @filename = filename
      @size = size.to_i
    end
    
    def process
      return false unless present?
      
      file = File.open(@filename, "r")
          
      # Start breaking the file down
      split_size["parts"].times do |n|
        f = File.open("#{@filename}.splitter#{n}", "w")
        f.puts file.read(@size)
      end
         
      # Write out one last peice
      e = File.open("#{@filename}.splitter#{split_size['parts']}", "w")
      e.puts file.read(split_size["extra_part"])
    end
    
    # Based on the size per file provided, calculate how many files
    # need to be created
    def split_size
      tmp = File.size(@filename).divmod(@size)
      parts = tmp[0]
      extra_part = tmp[1]
      
      return {"parts" => parts, "extra_part" => extra_part}
    end
    
    def total_parts
      split_size["parts"] + (split_size["extra_part"] > 1 ? 1 : 0)
    end
    
    def filesize
      File.size(@filename)
    end
    
    def present?
      File.exists?(@filename) ? true : false
    end
    
    def filename
      @filename
    end
  end
  
  class Join
    def initialize(filename)
      @filename = filename
      @part = 0
    end
    
    def process(destroy_originals = false)
      return false unless present?
      # If the parts exist, grab them and start putting them together
      file = File.open(@filename, "w")
      while present?             
        file << File.open("#{@filename}.splitter#{@part}","r").read.chomp
        File.delete("#{@filename}.splitter#{@part}") if destroy_originals
        @part += 1
      end
      file.close
    end
    
    def process_and_destroy
      process(true)
    end
    
    def present?
      File.exists?("#{@filename}.splitter#{@part}") ? true : false
    end
    
    def total_parts
      return false unless present?
      i = 0
      while present?
        i += 1
        @part += 1
      end
      # Reset the part counter to 0 for the process method
      @part = 0
      return i
    end
    
    def filename
      @filename
    end
  end
end

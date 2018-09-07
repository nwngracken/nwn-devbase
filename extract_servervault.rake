require 'nwn/all'
require 'fileutils'
require 'set'
require 'pathname'

def to_forward_slash(path=Pathname.getwd)
  return path.to_s.gsub(File::ALT_SEPARATOR || File::SEPARATOR, File::SEPARATOR)
end

#FLAT_LAYOUT = ENV['flat'] == "true"
SERVERVAULT_DIR = Pathname.new ENV['SERVERVAULT_DIR']
SRC_DIR = Pathname.new ENV['SRC_DIR']
SCRIPTS_DIR = Pathname.new ENV['SCRIPTS_DIR']

directory SRC_DIR

#BIC_DIRS = FileList[
#  to_forward_slash SERVERVAULT_DIR.join("*")
#].select { |d| File.directory?(d) }

Dir.foreach(SERVERVAULT_DIR).select { |dentry|
  File.directory?(SERVERVAULT_DIR.join(dentry)) and
  not ['..', '.'].include?(dentry)
}.each { |bic_dir|

  directory SERVERVAULT_DIR.join(bic_dir)
  src_files = []
  #FileList[to_forward_slash Pathname.new(bic_dir).join("*.bic")].each { |bic_file|
  #  puts "bic_file is #{bic_file}"
  #  src_file = bic_file.pathmap("#{SRC_DIR}%s%-1d%s%f.yml")
  #  puts "src_file is #{src_file}"
  #  src_files.push(src_file)
  #  file src_file => [bic_file] do |src_file|
  #    #system "nwn-gff", "-i", "#{bic_file}", "-lg", "-o", "#{src_file}", "-ky", "-r", to_forward_slash(SCRIPTS_DIR.join("truncate_floats.rb").to_s)
  #    puts "nwn-gff -i #{bic_file} -lg -o #{src_file} -ky -r #{to_forward_slash(SCRIPTS_DIR.join("truncate_floats.rb").to_s)}"
  #  end
  #}

  # Use Dir.glob instead of FileList because FileList will
  # choke on invalid UTF-8 filenames, which are possible with
  # bic files
  Dir.foreach(
    SERVERVAULT_DIR.join(bic_dir)
  ).select { |dentry|
    File.file?(SERVERVAULT_DIR.to_s.pathmap("%X%s#{bic_dir}%s#{dentry}"))
  }.each { |bic_file|
    #bic_file = to_forward_slash Pathname.new(bic_dir).join(
    #  bic_file_basename.encode(
    #    'UTF-8', 'binary', invalid: :replace, undef: :replace, replace: ''
    #  )
    #)
    puts "bic_file is #{bic_file}"
    # Again, the path is built this way because the
    # Pathname.join method throws an exception when it's given
    # strings (filenames) with invalide UTF-8 characters
    src_file = SRC_DIR.to_s.pathmap("%X%s#{bic_dir}%s#{bic_file}.yml")
    puts "src_file is #{src_file}"
    #src_files.push(src_file)
    #file src_file => [bic_file] do |src_file|
    #  #system "nwn-gff", "-i", "#{bic_file}", "-lg", "-o", "#{src_file}", "-ky", "-r", to_forward_slash(SCRIPTS_DIR.join("truncate_floats.rb").to_s)
    #  puts "nwn-gff -i #{bic_file} -lg -o #{src_file} -ky -r #{to_forward_slash(SCRIPTS_DIR.join("truncate_floats.rb").to_s)}"
    #end
  }
}

#GFF_SOURCES = FileList[to_forward_slash GFF_CACHE_DIR.join("*.*")].exclude(/\.n[cs]s$/)
#YML_TARGETS = FLAT_LAYOUT ? GFF_SOURCES.pathmap("#{SRC_DIR}/%f.yml") : GFF_SOURCES.pathmap("#{SRC_DIR}/%{.*,*}x/%f.yml") { |ext| ext.delete('.') }
#DIRS = Set.new.merge GFF_SOURCES.pathmap("%{.*,*}x") { |ext| ext.delete('.') }

#task :default => :yml
#task :default => [SRC_DIR] do
#	puts "In :default"
#	BIC_DIRS.each { |bic_dir| puts "DIR: #{bic_dir}" }
#end
#task :default => [src_files]

#desc 'Create dir tree and convert to yml'
#task :yml => [:create_folders, :gff2yml]

#directory SRC_DIR.to_s
#
#desc 'Create dir tree'
#task :create_folders => [SRC_DIR.to_s] do
#	Dir.chdir(to_forward_slash SRC_DIR) do
#		DIRS.each do |dir|
#			FileUtils.mkdir(dir) unless File.exists?(dir)
#		end
#	end unless FLAT_LAYOUT
#end
#
#desc 'Convert gff to yml'
#multitask :gff2yml => YML_TARGETS
#
#rule '.yml' => ->(f){ source_for_yml(f) } do |t|
#	system "nwn-gff", "-i", "#{t.source}", "-lg", "-o", "#{t.name}", "-r", to_forward_slash(SCRIPTS_DIR.join("truncate_floats.rb").to_s)
#	FileUtils.touch "#{t.name}", :mtime => File.mtime("#{t.source}")
#end
#
#def source_for_yml(yml)
#	GFF_SOURCES.detect{|gff| File.basename(gff) == File.basename(yml, ".*")}
#end

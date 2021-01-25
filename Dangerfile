# vim: set filetype=ruby:

# Take a list of filenames, filters to include only changes to modules and
# groups them by the module name.
#
# === Attributes
# +file_list+ - A Danger::FileList of files to group together
#
# === Example
#
#   group_list([
#     "modules/foo/somefile.ext",
#     "modules/foo/anotherfile.ext",
#     "modules/bar/otherfile.ext",
#     "baz.ext"
#   ])
#   # This will return the following hash
#   # {
#   #   "foo" => ["somefile.ext", "anotherfile.ext"],
#   #   "bar" => ["otherfile.ext"],
#   # }
def group_list(file_list)
  groups = Hash.new { |h, k| h[k] = [] }

  file_list.each do |file|
    parts = file.split('/')

    next unless parts.length >= 2
    next unless parts[0] == 'modules'

    key = parts[1]
    value = parts[2..-1].join("/")

    groups[key].push(value)
  end

  return groups
end

# -- Danger Checks ------------------------------------------------------------
changed = git.added_files + git.deleted_files + git.modified_files
grouped = group_list(changed)

grouped.each do |name, files|
  # Check for changes to modules that don't include a change to the version
  if ! files.include?('version.txt')
    failure "The module `#{name}` has been updated but it doesn't include a "\
            "change to the `version.txt`\n You need to bump the version in "\
            "`modules/#{name}/version.txt`"
  end

  # If the modules doesn't have a README.md, ask for one to be added
  if ! File.exists?("modules/#{name}/README.md")
    warn "Module `#{name}` doesn't have a 'README.md' please add one."
  end
end

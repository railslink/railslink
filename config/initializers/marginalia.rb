# see https://github.com/basecamp/marginalia#customization
Marginalia::Comment.components = [:controller_with_namespace, :action, :line]

# See https://github.com/basecamp/marginalia/blob/master/lib/marginalia/comment.rb#L109
# Our addition excludes:  "/usr/local/lib/ruby/.../monitor.rb:...:in `mon_synchronize'"
Marginalia::Comment.lines_to_ignore = /\.rvm|gem|vendor\/|marginalia|rbenv|\/monitor.rb.*mon_synchronize/

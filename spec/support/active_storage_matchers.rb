# ActiveStorage has no equivalent matcher to paperclip's
# `have_attached_file` but this comes pretty close.
RSpec::Matchers.define :have_attached_file do |name|
  match do |record|
    file = record.send(name)
    file.respond_to?(:variant) && file.respond_to?(:attach)
  end
end

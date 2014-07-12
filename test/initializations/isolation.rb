# This is required in order to test railties. This is based on isolation
# in rails that is available here
# https://github.com/rails/rails/blob/master/railties/test/isolation/abstract_unit.rb
require 'fileutils'

require 'active_support/testing/autorun'
require 'active_support/test_case'

# These files do not require any others and are needed
# to run the tests
require "active_support/testing/isolation"
require "active_support/core_ext/kernel/reporting"
require 'tmpdir'

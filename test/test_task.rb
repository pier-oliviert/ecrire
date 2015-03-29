require 'rake/testtask'

class Ecrire::TestTask < Rake::TestTask
  attr_accessor :theme

  def define
    desc @description
    task @name do
      Rake::FileUtilsExt.verbose(@verbose) do
        args =
          "#{ruby_opts_string} #{run_code} " +
          "#{file_list_string} #{option_list}" +
          "#{theme}"

        ruby args do |ok, status|
          if !ok && status.respond_to?(:signaled?) && status.signaled?
            raise SignalException.new(status.termsig)
          elsif !ok
            fail "Command failed with status (#{status.exitstatus}): " +
              "[ruby #{args}]"
          end
        end
      end
    end
    self
  end

end

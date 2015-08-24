require 'rake/testtask'

class Ecrire::Test::Task < Rake::TestTask

  def before(&block)
    @callback = block
  end

  def define
    desc @description
    task @name do

      unless @callback.nil?
        @callback.call
      end

      Rake::FileUtilsExt.verbose(@verbose) do
        args = [
          "#{ruby_opts_string} #{run_code} ",
          "#{file_list_string} #{option_list}"
        ]

        args << @name

        ruby args.join do |ok, status|
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

require 'rake/testtask'

module Ecrire
  module Test
    class Task < Rake::TestTask

      def before(&block)
        @before = block
      end

      def after(&block)
        @after = block
      end

      def define
        desc @description
        task @name do

          unless @before.nil?
            @before.call
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
  end
end

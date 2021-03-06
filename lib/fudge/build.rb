module Fudge
  # Represents a build defined in the FudgeFile
  #
  class Build < Tasks::CompositeTask
    # @!attribute about
    #   @return [String] a brief description of the build; this is
    #                    output by the 'list' command
    attr_accessor :about
    attr_accessor :callbacks
    attr_reader :success_hooks, :failure_hooks
    attr_reader :description

    def initialize(*args)
      @success_hooks = []
      @failure_hooks = []

      super
    end

    # Run task
    def run(options={})
      formatter = options[:formatter] || Fudge::Formatters::Simple.new
      success = super
      if callbacks
        message "Running #{success ? 'success' : 'failure'} callbacks...", formatter
        hooks = success ? @success_hooks : @failure_hooks

        hooks.each do |hook|
          return false unless hook.run :formatter => formatter
        end
      else
        message "Skipping callbacks...", formatter
      end

      success
    end

    private

    def message(message, formatter)
      formatter.write { |w| w.info(message) }
    end
  end
end

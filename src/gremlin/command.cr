require "option_parser"

module Gremlin
    module Command
        class Options
            property files

            def initialize
                @files = [] of String
            end
        end

        def self.run
            options = Options.new

            OptionParser.new do |opts|
                opts.banner = "Usage: gremlin DIR"

                opts.on("-h", "--help", "Show this menu") do
                    puts opts

                    exit
                end

                opts.unknown_args do |args, after_dash|
                    options.files = args
                end
            end.parse!

            run(options)
        end

        private def self.run(options)
            files = options.files

            files.each do |file|
                directory = File.dirname(file)

                content = File.read(file)

                invalid_comment_pattern = /^\s*'[a-z0-9][^\n]*$/im

                matches = content.scan(invalid_comment_pattern)

                matches.each do |match|
                    line = match[0]

                    content = content.gsub(line, correct(line))
                end

                File.write(file, content)
            end
        end

        private def self.correct(line)
            parts = line.split("'")

            before_comment = parts.shift

            invalid_comment = parts.join("'")

            valid_comment = make_valid(invalid_comment)

            before_comment + valid_comment
        end

        private def self.make_valid(comment)
            "' " + comment[0, 1].capitalize + comment[1..-1]
        end
    end
end

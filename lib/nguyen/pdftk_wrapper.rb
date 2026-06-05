require 'tempfile'
require 'open3'
require 'shellwords'
module Nguyen
  class PdftkError < StandardError
  end

  # Wraps calls to PdfTk
  class PdftkWrapper

    attr_reader :pdftk, :options

    # PdftkWrapper.new('/usr/bin/pdftk', :flatten => true, :encrypt => true, :encrypt_options => 'allow Printing')
    def initialize(pdftk_path, options = {})
      @pdftk = pdftk_path
      @options = options
    end

    # pdftk.fill_form '/path/to/form.pdf', '/path/to/destination.pdf', xfdf_or_fdf_object or xfdf_or_fdf_string
    def fill_form(template, destination, form_data)
      tmp = Tempfile.new('pdf_forms-fdf')
      tmp.close
      form_data.respond_to?(:save_to) ? form_data.save_to(tmp.path) : File.write(tmp.path, form_data)
      args = [template, 'fill_form', tmp.path, 'output', destination, add_options(tmp.path)]
      output = call_pdftk(*args)
      unless File.readable?(destination) && File.size(destination) > 0
        raise PdftkError.new("failed to fill form with command\n#{describe_command(args)}\ncommand output was:\n#{output}")
      end
    ensure
      tmp.unlink if tmp
    end

    # pdftk.stamp '/path/to/source.pdf', '/path/to/stamp.pdf', '/path/to/destination.pdf'
    # overlays the stamp PDF on top of every page of the source PDF
    def stamp(template, stamp_file, destination)
      stamp_operation 'stamp', template, stamp_file, destination
    end

    # pdftk.multistamp '/path/to/source.pdf', '/path/to/stamp.pdf', '/path/to/destination.pdf'
    # overlays the stamp PDF onto the source PDF page by page
    def multistamp(template, stamp_file, destination)
      stamp_operation 'multistamp', template, stamp_file, destination
    end

    # pdftk.read '/path/to/form.pdf'
    # returns an instance of Nguyen::Pdf representing the given template
    def read(path)
      Pdf.new path, self
    end

    def get_field_names(template)
      read(template).fields
    end

    # invokes pdftk with the given arguments and returns its output (stdout
    # and stderr combined); arguments are passed to the process verbatim,
    # without any shell involved, so paths need no quoting or escaping
    def call_pdftk(*args)
      output, _status = Open3.capture2e(pdftk, *normalize_args(args))
      output
    end

    def cat(*files, output)
      files = files.flatten
      input = files.flat_map { |f| f.to_s.include?('*') ? Dir.glob(f) : [f] }
      call_pdftk(*input, 'output', output)
    end

    protected

      def stamp_operation(operation, template, stamp_file, destination)
        args = [template, operation, stamp_file, 'output', destination]
        output = call_pdftk(*args)
        unless File.readable?(destination) && File.size(destination) > 0
          raise PdftkError.new("failed to #{operation} with command\n#{describe_command(args)}\ncommand output was:\n#{output}")
        end
      end

      def normalize_args(args)
        args.flatten.compact.map(&:to_s)
      end

      # human readable rendition of a pdftk invocation, for error messages
      def describe_command(args)
        Shellwords.join([pdftk, *normalize_args(args)])
      end

      def add_options(pwd)
        return if options.empty?
        opt_args = []
        if options[:flatten]
          opt_args << 'flatten'
        end
        if options[:encrypt]
          opt_args.concat ['encrypt_128bit', 'owner_pw', pwd]
          opt_args.concat Shellwords.split(options[:encrypt_options]) if options[:encrypt_options]
        end
        opt_args
      end

  end
end

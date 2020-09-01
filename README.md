# Nguyên the PDF Field Merger

A very lightweight library that fill PDF forms using XFDF/FDF with pdftk

You could download pdftk at http://www.accesspdf.com/pdftk/

Nguyên is a fork of Jens Krämer's pdf-forms with addition of filling forms with XFDF feature.

[![Build Status](https://secure.travis-ci.org/ruby-journal/nguyen.png)](http://travis-ci.org/ruby-journal/nguyen)
[![Code Climate](https://codeclimate.com/github/ruby-journal/nguyen/badges/gpa.svg)](https://codeclimate.com/github/ruby-journal/nguyen)
[![From Vietnam with <3](https://raw.githubusercontent.com/webuild-community/badge/master/svg/love.svg)](https://webuild.community)
[![Made in Vietnam](https://raw.githubusercontent.com/webuild-community/badge/master/svg/made.svg)](https://webuild.community)
[![Built with WeBuild](https://raw.githubusercontent.com/webuild-community/badge/master/svg/WeBuild.svg)](https://webuild.community)

## EXAMPLE:

### FDF creation

```ruby
fdf = Nguyen::Fdf.new(key: 'value', other_key: 'other value')
# use to_fdf if you just want the FDF data, without writing it to a file
puts fdf.to_fdf
# write fdf file
fdf.save_to('path/to/file.fdf')
```

### XFDF creation

```ruby
xfdf = Nguyen::Xfdf.new(key: 'value', other_key: 'other value')
# use to_xfdf if you just want the XFDF data, without writing it to a file
puts xfdf.to_xfdf
# write xfdf file
xfdf.save_to('path/to/file.xfdf')
```

### Query form fields and fill out PDF forms with pdftk

```ruby
# adjust the pdftk path to suit your pdftk installation
pdftk = Nguyen::PdftkWrapper.new('/usr/local/bin/pdftk')

# find out the field names that are present in form.pdf
pdftk.get_field_names('path/to/form.pdf')

# take form.pdf, set the 'foo' field to 'bar' and save the document to myform.pdf

# with fdf
fdf = Nguyen::Fdf.new(foo: 'bar')
pdftk.fill_form('/path/to/form.pdf', 'myform.pdf', fdf)

# with xfdf
xfdf = Nguyen::Xfdf.new(foo: 'bar')
pdftk.fill_form('/path/to/form.pdf', 'myform.pdf', xfdf)

# will work with xfdf or fdf xml string directly as well
xfdf_string = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<xfdf xmlns="http://ns.adobe.com/xfdf/" xml:space="preserve"><fields><field name="foo"><value>bar</value></field></fields></xfdf>
XML
# or xfdf_string = Nguyen::Xfdf.new(foo: 'bar').to_xfdf
pdftk.fill_form('/path/to/form', 'myform.pdf', xfdf_string)
```

## INSTALL:

    gem install nguyen

## Source Code:

    git clone http://github.com/ruby-journal/nguyen.git

## Contribution:

I greatly welcome contributions, please feel free to fork and submit pull request.

## LICENSE

see [LICENSE](LICENSE)

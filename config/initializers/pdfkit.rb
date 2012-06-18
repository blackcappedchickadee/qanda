PDFKit.configure do |config|
  config.wkhtmltopdf = '/Users/hkinney/.rvm/gems/ruby-1.9.2-p290/bin/wkhtmltopdf'
  # config.default_options = {
  #   :page_size => 'Legal',
  #   :print_media_type => true
  # }
  config.default_options = {
      :page_size     => 'Letter',
      :margin_top    => '0.5in',
      :margin_right  => '0.5in',
      :margin_bottom => '0.7in',
      :margin_left   => '0.5in'
  }
  config.root_url = "http://localhost" # Use only if your external hostname is unavailable on the server.
end
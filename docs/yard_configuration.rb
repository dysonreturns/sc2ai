YARD::DocstringParser.after_parse do |docstring|
  docstring.text = docstring.text.gsub(/^noinspection.*?$\n*/m, "")
end

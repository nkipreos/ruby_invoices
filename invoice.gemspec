Gem::Specification.new do |s|
  s.name        = 'invoice'
  s.version     = '0.0.1'
  s.date        = '2014-07-21'
  s.summary     = "Invoicing Gem Ideal for Commercial Rails Applications"
  s.description = "Ruby Invoice is a gem special for generating invoices in a simple and fast way."
  s.authors     = ["Nicolas Kipreos"]
  s.email       = 'nkipreos@gmail.com'
  s.files       = ["lib/invoice.rb"]
  s.add_dependency "prawn", "= 1.0.0"
  s.homepage    =
    'http://github.com/nkipreos/ruby_invoices'
  s.license       = 'Beerware'
end

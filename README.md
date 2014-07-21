[![Gem Version](https://badge.fury.io/rb/ruby-invoice.svg)](http://badge.fury.io/rb/ruby-invoice)
#Ruby Invoices

Ruby Invoices is a simple library that generate invoices for your business.

To add your company logo you must add a folder img with a logo.png file inside of it (non interlaced image). The log must be 129x75 pixels. This is important.

##Installation

To install do

```shell
$ gem install 'invoice'
```

##Usage

First you must instance the method. The invoice number is an int.

```ruby
invoice = Invoice.new(invoice_number)
```

Then you must add your client information (optional):

```ruby
invoice.set_client_info(client_name, client_address, client_dni, client_phone, economic_activity)
```

After that you add your company information (mandatory):

```ruby
invoice.add_company_info(your_company_name, your_address, your_phone, your_dni)
```

Now you can set the options:

```ruby
invoice.set_language(language) # Options are "en" and "es"(default)
invoice.set_tax(vat_percentage*100) # Integer. Default is 0
invoice.set_currency(currency) # Default is $
```

To add items to the invoice you must use the add_item method:

```ruby
invoice.add_item(item_description, item_quantity, item_price)
```

Finally to generate you must use the generate method and the output file will be generated in the invoices folder.

```ruby
invoice.generate
```

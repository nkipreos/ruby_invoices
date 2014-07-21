require 'prawn'

class Invoice < Prawn::Document
    FONT_NAME = "Helvetica"
    
    def initialize(invoice_number)
        super()
        @name = nil
        @language = :es
        @address = nil
        @dni = nil
        @phone = nil
        @activity = nil
        @vat = 0
        @detail_page_items = nil
        @items = []
        @currency = "$"
        @invoice_number = invoice_number
        @company_name = nil
        @company_address = nil
        @company_phone = nil
        @companany_dni = nil
    end

    def generate
        
        draw_proforma_box # Invoice box in the upper right corner
        insert_logo
        render_company_info # Company information Right to the logo
        render_reception_box # Reception box in the lower left corner
        render_client_information
        render_items_table
        add_items_to_table

        unless @detail_page_items.empty?
            render_detail_page
        end

        self
        save
    end

    #########################
    ###  RENDERING TABLE  ###
    #########################

    def render_client_information
        normal_font
        move_down 40
        text languages(:receptor)
        text_box languages(:table_date), :at => [305, 605]
        move_down 10
        text languages(:table_address)
        move_down 10
        text languages(:table_dni)
        text_box languages(:table_phone), :at => [160, 556]
        text_box languages(:table_activity), :at => [340, 556]
        render_lines
    end

    def render_items_table
        text_box languages(:item_title), :at => [0, 510], :width => 50, :align => :center
        text_box languages(:description_title), :at => [50, 510], :width => 250, :align => :center
        text_box languages(:quantity_title), :at => [300, 510], :width => 70, :align => :center
        text_box languages(:price_title), :at => [370, 510], :width => 80, :align => :center
        text_box languages(:value_title), :at => [450, 510], :width => 100, :align => :center
        text_box languages(:subtotal_title), :at => [300, 50], :width => 150, :align => :center
        text_box languages(:vat_title), :at => [300, 32], :width => 150, :align => :center
        text_box languages(:total_title), :at => [300, 14], :width => 150, :align => :center
        stroke_rounded_rectangle [0, 520], 550, 450, 10
        stroke_rounded_rectangle [300, 60], 250, 65, 10
        stroke_line [50, 520], [50, 70]
        stroke_line [300, 520], [300, 70]
        stroke_line [370, 520], [370, 70]
        stroke_line [450, 520], [450, 70]
        stroke_line [0, 495], [550, 495]
        stroke_line [450, 60], [450, -5]
        stroke_line [300, 37], [550, 37]
        stroke_line [300, 18], [550, 18]
    end

    def calculate_total_values(values)
        text_box @currency, :at => [450, 50], :width => 20, :align => :center
        text_box add_delimiter(values.inject(:+).round(2).to_s), :at => [470, 50], :width => 80, :align => :center
        text_box @currency, :at => [450, 32], :width => 20, :align => :center
        text_box add_delimiter((values.inject(:+)*@vat/100).round(2).to_s), :at => [470, 32], :width => 80, :align => :center
        text_box @currency, :at => [450, 14], :width => 20, :align => :center
        text_box add_delimiter((values.inject(:+)*(100 + @vat)/100).round(2).to_s), :at => [470, 14], :width => 80, :align => :center
    end

    def add_items_to_table
        if @items.count <= 10 && @items.count > 0
            i = 0
            spacing = 40
            @items.each do |item|
                text_box (i + 1).to_s, :at => [0, 480 - i*spacing], :width => 50, :align => :center
                text_box item[:description], :at => [50, 480 - i*spacing], :width => 250, :align => :center
                text_box add_delimiter(item[:quantity].to_s), :at => [300, 480 - i*spacing], :width => 70, :align => :center
                text_box @currency, :at => [370, 480 - i*spacing], :width => 20, :align => :center
                text_box add_delimiter(item[:price].to_s), :at => [390, 480 - i*spacing], :width => 60, :align => :center
                text_box @currency, :at => [450, 480 - i*spacing], :width => 20, :align => :center
                text_box add_delimiter((item[:price]*item[:quantity]).round(2).to_s), :at => [470, 480 - i*spacing], :width => 80, :align => :center
                i+=1
            end
            values = @items.map {|x| x[:price]*x[:quantity]}
            calculate_total_values values
        else
            p "Max. 10 items, Min. 0 items"
        end
    end

    def render_lines
        if @language == :es
            line [70, 593], [295, 593]
            line [350, 593], [550, 593]
            line [71, 569], [550, 569]
            line [37, 545], [150, 545]
            line [230, 545], [330, 545]
            line [375, 545], [550, 545]
        elsif @language == :en
            line [40, 593], [295, 593]
            line [338, 593], [550, 593]
            line [62, 569], [550, 569]
            line [25, 545], [150, 545]
            line [208, 545], [330, 545]
            line [398, 545], [550, 545]
        end
        stroke
    end

    def insert_logo
        image "img/logo.png"
    end

    def draw_proforma_box
        title_font
        stroke_rectangle [360, 730], 190, 90
        text_box languages(:title), :width => 190, :align => :center, :at => [360, 705]
        text_box languages(:number) + ":  #{@invoice_number.to_s}", :width => 190, :align => :center, :at => [360, 680]
        
    end

    #########################
    ####  COMPANY INFO   ####
    #########################

    def render_company_info
        mini_font
        text_box @company_name, :at => [140, 706], :width => 200, :align => :left
        text_box @company_address, :at => [140, 693], :width => 200, :align => :left
        text_box @company_phone, :at => [140, 680], :width => 200, :align => :left
        text_box @company_dni, :at => [140, 667], :width => 200, :align => :left
    end

    def add_company_info(name, address, phone, dni = nil)
        @company_name = name
        @company_address = address
        @company_phone = phone
        @company_dni = dni
    end

    #########################
    ###   RECEPTION BOX   ###
    #########################

    def render_reception_box
        mini_font
        text_box languages(:receptor_name), :at => [10, 56], :width => 200, :align => :left
        text_box languages(:receptor_date), :at => [10, 36], :width => 200, :align => :left
        text_box languages(:receptor_signature), :at => [10, 16], :width => 200, :align => :left
        draw_reception_lines
    end

    def draw_reception_lines
        if @language == :es
            stroke_line [52, 47], [280, 47]
            stroke_line [42, 27], [280, 27]
            stroke_line [41, 7], [280, 7]
        elsif @language == :en
            stroke_line [42, 47], [280, 47]
            stroke_line [35, 27], [280, 27]
            stroke_line [61, 7], [280, 7] 
        end
    end

    #########################
    #####  DETAIL PAGE  #####
    #########################

    def render_detail_page
        start_new_page
        insert_logo
        title_font
        move_down 30
        text languages(:detail_page_title)
        normal_font
        @detail_page_items.map {|x| text x}
        move_down 10
        text "------------"
        move_down 10
        text "Total: #{@detail_page_items.count.to_s}"
    end

    def add_details(items)
        @detail_page_items = items
    end


    #########################
    ####  CONFIGURATION  ####
    #########################

    def set_language(language)
        @language = language.to_sym
    end

    def set_client_info(name = nil, address = nil, dni = nil, phone = nil, activity = nil)
        @name = name
        @address = address
        @dni = dni
        @phone = phone
        @activity = activity
    end

    def set_tax(vat)
        @vat = vat
    end

    def add_item(description, quantity, price)
        @items << {
            :description => description[0..84],
            :quantity => quantity,
            :price => price.round(3)
        }
    end

    def set_currency(currency)
        @currency = currency
    end

    #########################
    #####   DELIMITER   #####
    #########################

    def add_delimiter(number)
        number.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    end

    #########################
    #####   LANGUAGES   #####
    #########################

    def languages(content)
        hash = Hash.new
        hash[:es] = {
            :greet => "Estimados señores #{@name}",
            :title => "Factura Proforma",
            :number => "Número",
            :receptor => "SEÑOR(ES): #{@name}",
            :table_date => "FECHA: #{Time.now.strftime('%d/%m/%Y')}",
            :table_address => "DIRECCIÓN: #{@address}",
            :table_dni => "R.U.T.: #{@dni}",
            :table_phone => "TELÉFONO: #{@phone}",
            :table_activity => "GIRO: #{@activity}",
            :item_title => "ITEM",
            :description_title => "DESCRIPCIÓN",
            :quantity_title => "CANTIDAD",
            :price_title => "PRECIO",
            :value_title => "VALOR",
            :subtotal_title => "SUBTOTAL",
            :vat_title => "IMPUESTO #{@vat}%",
            :total_title => "TOTAL",
            :detail_page_title => "Detalles",
            :receptor_name => "Nombre:",
            :receptor_date => "Fecha:",
            :receptor_signature => "Firma:"
        }

        hash[:en] = {
            :greet => "Dear Mr. #{@name}",
            :title => "Proforma Invoice",
            :number => "number",
            :receptor => "NAME: #{@name}",
            :table_date => "DATE: #{Time.now.strftime('%d/%m/%Y')}",
            :table_address => "ADDRESS: #{@address}",
            :table_dni => "DNI: #{@dni}",
            :table_phone => "PHONE: #{@phone}",
            :table_activity => "ACTIVITY: #{@activity}",
            :item_title => "ITEM",
            :description_title => "DESCRIPTION",
            :quantity_title => "QUANTITY",
            :price_title => "PRICE",
            :value_title => "VALUE",
            :subtotal_title => "SUBTOTAL",
            :vat_title => "TAX #{@vat}%",
            :total_title => "TOTAL",
            :detail_page_title => "Details",
            :receptor_name => "Name:",
            :receptor_date => "Date:",
            :receptor_signature => "Signature:"
        }


        hash[@language][content]
    end

    #########################
    ######   FONTS   ########
    #########################

    def title_font
        font FONT_NAME, style: :bold
        font_size 18
    end
    
    def mini_font
        font FONT_NAME, style: :bold
        font_size 10
    end

    def normal_font
        font FONT_NAME, style: :normal
        font_size 12
    end

    #########################
    ######    SAVE   ########
    #########################

    def save
        invoices_folder = "invoices/"
        Dir.mkdir(invoices_folder) unless File.directory?(invoices_folder)
        filename = invoices_folder + @name.downcase.gsub(" ", '-') + "-#{@invoice_number}" + ".pdf"
        render_file filename
        return filename
    end

end
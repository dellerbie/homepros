module Features
  module ChosenHelpers
    def search_chosen(selector, search)
      page.execute_script "jQuery('#{selector}').click();"
      find('div.chzn-search input').set search
    end

    def select_from_chosen(item_text, options)
      field = find_field(options[:from], visible: false)
      option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
      page.execute_script("$('##{field[:id]}').val('#{option_value}')")
      page.execute_script("$('##{field[:id]}').trigger('liszt:updated').trigger('change')")
    end

    def visible_in_chosen(element, *args)
      within "#{element} .chzn-drop" do
        args.each do |text|
          page.should have_css('li', :text => text)
        end
      end
    end

    def not_visible_in_chosen(*args)
      within '.chzn-drop' do
        args.each do |text|
          page.should have_no_css('li', :text => text)
        end
      end
    end

    def wait_for_ajax
      if Capybara.current_driver == :selenium
        delay = Capybara.default_wait_time/100.0
        100.times do
          break if evaluate_script('jQuery.active').to_i == 0
          sleep delay
        end
        unless evaluate_script('jQuery.active').to_i == 0
          raise "Giving up waiting for AJAX to complete after #{Capybara.default_wait_time} seconds"
        end
      end
    end
  end
end
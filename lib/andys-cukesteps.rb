
When /^(?:|I )click "([^"]*)"(?: within "([^"]*)")?$/ do |link, selector|
  with_scope(selector) do
    if(l = find(link))
      l.click
    else
      raise "Cannot find link '#{link}' to click on"
    end
  end
end

When /^I automatically confirm any js popups$/ do
  page.execute_script("window.alert = function(msg) { return true; }")
  page.execute_script("window.confirm = function(msg) { return true; }")
end

Then /^I should confirm a js (alert|confirm) when (.*)$/ do |popuptype, step|
  ['alert', 'confirm'].each do |t|
    page.execute_script("
      window.capybara_auto_js_#{t}s = 0;
      window.#{t}       = function(msg) { window.capybara_auto_js_#{t}s++; return true; }
    ")
  end
  steps("Then #{step}")
  assert_equal 1, page.evaluate_script("window.capybara_auto_js_#{popuptype}s")
end

When /^I show visibility of "(.*)"$/ do |selector|
  page.execute_script("$('#{selector}').show()")
end

When /^I invoke the onclick handler of "([^\"]*)"(?: within "([^"]*)")?$/ do |selector, scope|
  with_scope(scope) do
    page.execute_script("$('#{selector}').trigger('click')")
  end
end

When /^"(.*)" receives focus(?: within "([^"]*)")?$/ do |selector, scope|
  with_scope(scope) do
    page.execute_script("$('#{selector}').trigger('focus')")
  end
end

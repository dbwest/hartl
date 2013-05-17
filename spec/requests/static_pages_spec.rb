require 'spec_helper'

describe "StaticPages" do

	describe "Home Page" do
		it "should have the content 'Sample App'" do
			visit home_path
			page.should have_content('Sample App')
		end
	end

	describe "Help Page" do
		it "should have the content 'Help'" do
			visit help_path
			page.should have_content('Help')
		end
	end

	describe "About Page" do
		it "should have the content 'About'" do
			visit about_path
			page.should have_content('About')
		end
	end 

end

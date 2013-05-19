require 'spec_helper'

describe User do

	before do
		@user = User.new(name: "Joe Bloggs", email: "jb@bloggs.net", password: 'foobar', password_confirmation: 'foobar')
	end

	subject {@user}

	it {should respond_to(:name)}
	it {should respond_to(:email)}
	it {should respond_to(:password_digest)}
	it {should respond_to(:password)}
	it {should respond_to(:password_confirmation)}
	it {should respond_to(:authenticate)}

	it {should be_valid}
 
	describe "when name is not present" do
		before { @user.name = " "}
		it { should_not be_valid}
	end

	describe "when an email is not present" do
		before { @user.email = " "}
		it {should_not be_valid}
	end

	describe "when a password is not present" do
		before { @user.password = @user.password_confirmation = " "}
		it {should_not be_valid}
	end

	describe "when password doesn't match confirmation" do
		before {@user.password_confirmation="wrong"}
		it {should_not be_valid}
	end

	describe "when password confirmation is nil" do
		before {@user.password_confirmation=nil}
		it {should_not be_valid}		
	end

	describe "when a name is too long" do
		before { @user.name = "a" * 51}
		it { should_not be_valid}
	end

	describe "when an email is valid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end

		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.1st@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
		end

	end

	describe "when an email address is taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "with a password that's too short" do
		before {@user.password = @user.password_confirmation = "a" *5}
		it { should be_invalid}
	end

	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email)}

		describe "with valid password" do
			it {should == found_user.authenticate(@user.password)}
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid")}

			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false}
		end
	end

	describe "mixed case email" do
		let(:mixed_case_email) { "SpwnfSDAD@ASdmf.Com"}

		it "should be save to lowercase" do
			@user.email = mixed_case_email
			@user.save
			@user.reload.email.should == mixed_case_email.downcase
		end
	end

end
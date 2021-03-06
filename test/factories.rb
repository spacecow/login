Factory.define :user do |f|
	f.sequence(:username){|n| "username#{n}" }
	f.password "secret"
	f.sequence(:email){|n| "mail#{n}@another.fake.domain.com" }
	f.question "Where did you spend your childhood summers?"
	f.answer "I am not going to tell you that!"
end

Factory.define :reset do |f|
	f.user {|u| u.association( :user, :username => "username1" ) }
	f.username "username1"
end
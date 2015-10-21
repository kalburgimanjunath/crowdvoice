FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "foo_#{n}" }
    sequence(:email) { |n| "foo#{n}@example.com" }
    password "example"

    trait :admin do
      is_admin true
    end

    trait :non_admin do
      is_admin false
    end

    factory :admin_user, traits: [:admin]
    factory :regular_user, traits: [:non_admin]
  end

  factory :subscription do
    sequence(:email) { |n| "foo#{n}@example.com" }
    association :voice_id, factory: :voice, strategy: :create
  end

  factory :voice do
   title "Test Voice"
   description "Test description"
   theme "blue"
   background_version "square"
   association :user, factory: :user, strategy: :build

   factory :voice_wide do
    background_version "wide"
   end

   factory :voice_none do
    background_version "none"
   end

    trait :featured do
     featured true
    end

    trait :non_featured do
      featured false
    end

    trait :archived do
      archived true
    end

    trait :unarchived do
      archived false
    end

    trait :approved do
     approved true
    end

    trait :unapproved do
      approved false
    end

    factory :featured_voice, traits: [:featured, :unarchived, :approved]
    factory :archived_voice, traits: [:non_featured, :archived, :approved]
    factory :unapproved_voice, traits: [:non_featured, :unarchived, :unapproved]
    factory :non_featured_voice, traits: [:non_featured, :unarchived, :approved]
  end

  factory :post do
    association :voice_id, factory: :voice, strategy: :create
    association :user_id, factory: :user, strategy: :create
    sequence(:source_url) { |n| "http://edition.cnn.com/2012/05/08/world/meast/syria-unrest/index.html?hpt=hp_t1&x=#{n}" }

    factory :flickr_post do
      source_url "http://www.flickr.com/photos/38181284@N06/6855353886/?f=hp"
    end
    factory :twitpic_post do
      source_url "http://twitpic.com/9iemzr"
    end
    factory :yfrog_post do
      source_url "http://yfrog.com/g09v2zkj"
    end
    factory :raw_post do
      source_url "http://www.flickr.com/photos/38181284@N06/6855353886/?f=hp"
    end
    factory :youtube_post do
      source_url "http://www.youtube.com/watch?v=sAuZOoEKA84"
    end
    factory :vimeo_post do
      source_url "http://vimeo.com/40787597"
    end
    factory :link_post do
      source_url "http://www.flickr.com/photos/38181284@N06/6855353886/?f=hp"
    end

    trait :approved do
      approved true
    end

    trait :unapproved do
      approved false
    end

    factory :approved_post, :traits => [:approved]
    factory :unapproved_post, :traits => [:unapproved]
  end

  factory :vote do
    association :user_id, factory: :user, strategy: :create
    association :post_id, factory: :post, strategy: :create
    ip_address "187.163.28.116"
    rating 1

    factory :negative_vote do
      rating -1
    end
  end

  factory :announcement do
    association :voice_id, factory: :voice, strategy: :create
    title "This is an Announcement"
    content "This is an Announcement"
    url "http://www.link.com"
  end

  factory :setting do
    name "Setting Name"
    value "10"
  end
end

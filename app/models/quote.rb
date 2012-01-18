class Quote < ActiveRecord::Base
  belongs_to :movie

  has_many :shares
  has_many :users, :through => :shares

  def self.most_pop_by_movie(movie_id, max = 3)
    where(:movie_id => movie_id).order("shares_count DESC").limit(max)
  end


  def sample
    quotes = {559 => %q{Walter: "Donny you're out of your element!"},
              816 => %q{The Dude: "I'm the Dude. So that's what you call me. You know, that or, uh, His Dudeness, or uh, Duder, or El Duderino if you're not into the whole brevity thing."},
              848 => %q{The Dude: "This aggression will not stand, man."},
              1638 => %q{Walter: "Shut the fuck up, Donny."},
              1701 => %q{Donny: "I am the walrus. "},
              1775 => %q{ Jesus: "Nobody fucks with the Jesus. "},
              2363 => %q{Walter: "I'm Shomer Shabbos."},
              2471 => %q{Donny: "Phone's ringin', dude."},
              2966 => %q{The Dude: "Hey, careful, man, there's a beverage here! "},
              3635 => %q{The Stranger: "Sometimes you eat the bear and sometimes, well, he eats you."},
              4830 => %q{The Dude: "That rug really tied the room together. "},
              6672 => %q{The Dude: "The Dude abides. "}
    }

    quotes.each do |quote|
      Quote.create(:movie_id => 44, :quoted_at => quote.first, :text => quote.last)
    end

  end
end

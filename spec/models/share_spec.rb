require 'spec_helper'

describe Share do

  it "counts clips shared" do
     movie = Factory.create(:movie)


    clip_1 = Factory.create(:clip, :movie_id => movie.id)
    clip_2 = Factory.create(:clip, :movie_id => movie.id)
    clip_3 = Factory.create(:clip, :movie_id => movie.id)
    clip_4 = Factory.create(:clip, :movie_id => movie.id)


    5.times do
      user = Factory.create(:user)
      user.clips << clip_1
    end

    3.times do
      user = Factory.create(:user)
      user.clips << clip_2
    end

    1.times do
      user = Factory.create(:user)
      user.clips << clip_3
    end

    clips = Clip.most_pop_by_movie(movie.id)
    clips.count.should == 4

    clips.first.id.should == clip_1.id
    clips.map(&:id).should == [clip_1.id, clip_2.id, clip_3.id]
  end
end

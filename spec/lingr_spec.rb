# coding: utf-8
require_relative 'spec_helper'
require_relative '../lingr'

describe Sinatra::Application do
  def app
    described_class
  end

  before :suite do
    set :environment, :test
  end

  subject { last_response }

  describe 'GET /' do
    before :all do
      get '/'
    end

    it { should be_ok }
    its(:body) { should be_include('htkymtks') }
  end

  describe 'POST /' do
    context 'with message `!ruby`' do
      before :all do
        post '/', json: {
          :events => [
            {:message => {:text => '!ruby "hoge"'}}
          ]
        }.to_json
      end

      it { should be_ok }
      its(:body) { should == 'hoge' }
    end

    context 'with message `!ruby=`' do
      before :all do
        post '/', json: {
          :events => [
            {:message => {:text => '!ruby= print "fuga"'}}
          ]
        }.to_json
      end

      it { should be_ok }
      its(:body) { should == 'fuga' }
    end

    context 'with message `!fav`' do
      before :all do
        # TODO もう少しなんとかならんの
        stub_request(:get, %r(/rss$)).to_return(
          :body => RSS::Maker.make('2.0') {|m|
            m.channel.title = 'hoge'
            m.channel.description = 'fuga'
            m.channel.link = 'piyo'

            m.items.new_item do |i|
              i.title = '[title]'
              i.link  = '[link]'
            end
          }.to_s
        )

        post '/', json: {
          :events => [
            {:message => {:text => '!fav'}}
          ]
        }.to_json
      end

      it { should be_ok }
      its(:body) { should == "[title]\n[link]" }
    end

    context "with message !chainsaw" do
      before :all do
        post '/', json: {
          :events => [
            {:message => {:text => '!chainsaw'}}
          ]
        }.to_json
      end

      it { should be_ok }
      its(:body) { should == "http://farm6.static.flickr.com/5161/5240705190_edc4d29853_m.jpg" }
    end

    context "with message 'そんな装備で大丈夫か'" do
      before :all do
        post '/', json: {
          :events => [
            {:message => {:text => 'そんな装備で大丈夫か'}}
          ]
        }.to_json
      end

      it { should be_ok }
      its(:body) { should == "http://image.space.rakuten.co.jp/lg01/10/0001062610/96/imgc4ca50c0zik6zj.gif\n大丈夫だ。問題ない。" }
    end

    context "with god's message" do
      context 'm_seki' do
        before :all do
          stub.instance_of(app).m_seki? { true }

          post '/', json: {
            events: [
              {message: {speaker_id: 'htkymtks'}}
            ]
          }.to_json
        end

        it { should be_ok }
        its(:body) { should_not be_empty }
      end

      context 'not m_seki' do
        before :all do
          stub.instance_of(app).m_seki? { false }

          post '/', json: {
            events: [
              {message: {speaker_id: 'htkymtks'}}
            ]
          }.to_json
        end

        it { should be_ok }
        its(:body) { should be_empty }
      end
    end

    context 'with miscellaneous message' do
      before :all do
        post '/', json: {
          :events => [
            {:message => {:text => 'hi', :speaker_id => 'ursm'}}
          ]
        }.to_json
      end

      it { should be_ok }
      its(:body) { should be_empty }
    end
  end
end

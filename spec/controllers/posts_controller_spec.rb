require "rails_helper"
require "byebug"

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    let!(:posts) { create_list(:post, 10, published: true) } 
    
    it "should return OK" do
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(response).to have_http_status(200)
    end

    describe 'Search' do
      let!(:hola_mundo) { create(:published_post, title: "Hola mundo") } 
      let!(:hola_rails) { create(:published_post, title: "Hola rails") } 
      let!(:curso_rails) { create(:published_post, title: "Curso rails") } 
      
      it 'should filter posts by title' do
        get "/posts?search=Hola"
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload.size).to eq(2)
        expect(payload.map { |p| p["id"] }.sort).to eq([hola_mundo.id.to_s, hola_rails.id.to_s].sort)
        expect(response).to have_http_status(200)
      end
    end

    context "with valid auth" do
      let!(:user) { create(:user) }
      let!(:other_user) { create(:user) }
      let!(:user_post) { create(:post, user_id: user.id) } 
      let!(:other_user_post) { create(:post, user_id: other_user.id, published: true) } 
      let!(:other_user_post_draft) { create(:post, user_id: other_user.id, published: false) } 
      let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}"} } 
      let!(:other_auth_headers) { { 'Authorization' => "Bearer #{other_user.auth_token}"} } 

      context "when requisting other's author post" do
        context "when post is public" do
          before { get "/posts/#{other_user_post.id}", headers: auth_headers}

          context "payload" do
            subject { payloader } 
            it { is_expected.to include(:id) } 
          end
          context "response" do
            subject { response } 
            it { is_expected.to have_http_status(:ok) } 
          end
        end
        context "when post is draft" do
          before { get "/posts/#{other_user_post_draft.id}", headers: auth_headers}
          
          context "payload" do
            subject { payloader } 
            it { is_expected.to include(:error) } 
          end
          context "response" do
            subject { response } 
            it { is_expected.to have_http_status(:not_found) } 
          end
        end
      end
    end
    
  end
  
  describe "with data in the DB" do
    let!(:posts) { create_list(:post, 10, published: true) } 
    
    it 'should return all the published posts' do
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)
    end
    
  end

  describe "GET /posts/{id}" do
    let!(:post) { create(:post, published: true) } 

    it 'should return a post' do
      get "/posts/#{post.id}"

      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty

      expect(payload["id"]).to eq(post.id.to_s)
      expect(response).to have_http_status(200)
    end
    
  end
  
  describe "POST /posts" do
    let!(:user) { create(:user) } 
    let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}"} } 
    let!(:create_params) { {"post" => {"title" => "title", "content" => "content", "published" => true} } } 

    context 'should create a post' do
      context "with valid auth" do
        before { post "/posts",params: create_params, headers: auth_headers}

        context "payload" do
          subject { payloader } 
          it { is_expected.to include(:id, :title, :content, :published, :author) } 
        end
        context "response" do
          subject { response } 
          it { is_expected.to have_http_status(:created) } 
        end
      end

      context "without auth" do
        before { post "/posts",params: create_params}

        context "payload" do
          subject { payloader } 
          it { is_expected.to include(:error) } 
        end
        context "response" do
          subject { response } 
          it { is_expected.to have_http_status(:unauthorized) } 
        end
      end
    end
    
  end
  
  describe "PUT /posts/{id}" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:user_post) { create(:post, user_id: user.id) } 
    let!(:other_user_post) { create(:post, user_id: other_user.id, published: true) } 
    let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}"} } 
    let!(:other_auth_headers) { { 'Authorization' => "Bearer #{other_user.auth_token}"} } 
    let!(:update_params) { {"post" => {"title" => "title", "content" => "content", "published" => true} } } 
    
    context 'should update a post' do
      context "with valid auth" do
        context "when updating user's post" do
          before { put "/posts/#{user_post.id}",params: update_params, headers: auth_headers}
          
          context "payload" do
            subject { payloader } 
            it { is_expected.to include(:id, :title, :content, :published, :author) } 
            it { expect(payloader[:id]).to eq(user_post.id.to_s) } 
          end
          context "response" do
            subject { response } 
            it { is_expected.to have_http_status(:ok) } 
          end
        end
        
        # context "when updating other user's post" do
        #   before { put "/posts/#{other_user_post.id}",params: update_params, headers: auth_headers}
          
        #   context "payload" do
        #     subject { payloader } 
        #     it { is_expected.to include(:error) } 
        #   end
        #   context "response" do
        #     subject { response } 
        #     it { is_expected.to have_http_status(:not_found) } 
        #   end
        # end
      end

      context "without auth" do
        before { put "/posts/#{user_post.id}",params: update_params}

        context "payload" do
          subject { payloader } 
          it { is_expected.to include(:error) } 
        end
        context "response" do
          subject { response } 
          it { is_expected.to have_http_status(:unauthorized) } 
        end
      end
    end

  end

  private

  def payloader
    JSON.parse(response.body).with_indifferent_access
  end
  
end
require 'rails_helper'

describe 'CommentAPI', type: :request do
  let(:user1) { create(:user) }
  let!(:comment) { create(:comment) }

  it '新しいコメントを作成する' do
    valid_params = { content: 'comment2' }

    expect { post "/recipes/#{comment.recipe.id}/comments", params: valid_params.to_json, headers: auth_headers(comment.user) }.to change(Comment, :count).by(+1)

    expect(response.status).to eq(200)
  end

  it 'コメントを削除する' do
    expect { delete "/recipes/#{comment.recipe.id}/comments", params: { id: comment.id }.to_json, headers: auth_headers(comment.user) }.to change(Comment, :count).by(-1)
    expect(response.status).to eq(200)
  end
end
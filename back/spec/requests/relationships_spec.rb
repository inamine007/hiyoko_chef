require 'rails_helper'

describe 'RelationshipAPI', type: :request do
  let(:user1) { create(:user, name: 'testa') }
  let!(:relationship) { create(:relationship, follow: user1) }

  it 'current_userのフォロワーとフォローユーザーを取得する' do
    relationship2 = create(:relationship, follow: relationship.user, user: user1) 

    get '/relationships', headers: auth_headers(relationship.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data_followings'][0]['name']).to eq('testa')
    expect(json['data_followers'][0]['name']).to eq('testa')
  end

  it 'フォローユーザーの作成したレシピを全て取得する' do
    recipe = create(:recipe, name: 'recipea', user: user1)

    get '/relationships/recipes', headers: auth_headers(relationship.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'][0]['attributes']['name']).to eq('recipea')
  end

  it 'ユーザーをフォローする' do
    user2 = create(:user, name: 'testb')

    expect { post "/users/#{user2.id}/relationships", headers: auth_headers(relationship.user) }.to change(Relationship, :count).by(+1)

    expect(response.status).to eq(200)
  end

  it 'ユーザーのフォローを解除する' do
    expect { delete "/users/#{user1.id}/relationships", headers: auth_headers(relationship.user) }.to change(Relationship, :count).by(-1)

    expect(response.status).to eq(200)
  end
end
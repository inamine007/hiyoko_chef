require 'rails_helper'

describe 'GroupAPI', type: :request do
  let(:user1) { create(:user, name: 'testa') }
  let(:user2) { create(:user, name: 'testb', email: 'testb@example.com') }
  let(:recipe1) { create(:recipe, user: user1) }
  let(:recipe2) { create(:recipe, name: 'recipe2', user: user2) }
  let!(:group) { create(:group, users: [user1, user2], recipes: [recipe1, recipe2], owner_id: user1.id) }


  it 'ユーザーが作成した全てのグループを取得する' do
    group = create(:group, name: 'group2', users: [user1, user2], owner_id: user1.id)
    get "/groups/#{user1.id}/owner", headers: auth_headers(user1)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(2)
    expect(json['data'][0]['name']).to eq('group')
    expect(json['data'][1]['name']).to eq('group2')
  end

  it 'current_userが属している全てのグループを取得する' do
    user3 = create(:user, name: 'testc')
    group = create(:group, name: 'group2', users: [user1, user2], owner_id: user2.id)
    group = create(:group, name: 'group3', users: [user1, user3], owner_id: user3.id)

    get "/groups/", headers: auth_headers(user1)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(3)
    expect(json['data'][0]['name']).to eq('group')
    expect(json['data'][1]['name']).to eq('group2')
    expect(json['data'][2]['name']).to eq('group3')
  end

  it 'グループに属している全てのユーザーを取得する' do
    get "/groups/#{group.id}/members", headers: auth_headers(user1)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(2)
    expect(json['data'][0]['attributes']['name']).to eq('testb')
    expect(json['data'][1]['attributes']['name']).to eq('testa')
  end

  it 'グループに属している全てのレシピを取得する' do
    get "/groups/#{group.id}/mygroup", headers: auth_headers(user1)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(2)
    expect(json['data'][0]['attributes']['name']).to eq('recipe')
    expect(json['data'][1]['attributes']['name']).to eq('recipe2')
  end

  it '特定のグループを取得する' do
    get "/groups/#{group.id}", headers: auth_headers(user1)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data']['name']).to eq('group')
    expect(json['data_count']).to eq(2)
    expect(json['data_members'][0]['name']).to eq('testb')
    expect(json['data_members'][1]['name']).to eq('testa')
  end

  it 'current_userが特定のグループに参加する' do
    user = create(:user)

    expect { post "/groups/new/add_user", params: { id: group.id, password: 1111 }.to_json, headers: auth_headers(user) }.to change(group.users, :count).by(+1)

    expect(response.status).to eq(200)
  end

  it 'current_userが特定のグループから退会する' do
    expect { post "/groups/#{group.id}/remove_user", headers: auth_headers(user2) }.to change(group.users, :count).by(-1)

    expect(response.status).to eq(200)
  end

  it '新しいグループを作成する' do
    valid_params = { name: 'group2', introduction: 'text', password: 2222 }

    expect { post '/groups', params: valid_params.to_json, headers: auth_headers(user1) }.to change(Group, :count).by(+1)

    expect(response.status).to eq(200)
  end

  it 'グループの編集を行う' do
    put "/groups/#{group.id}", params: { name: "new" }.to_json, headers: auth_headers(user1)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data']['name']).to eq('new')
 end

  it 'グループを削除する' do
    expect { delete "/groups/#{group.id}", headers: auth_headers(user1) }.to change(Group, :count).by(-1)

    expect(response.status).to eq(200)
  end
end
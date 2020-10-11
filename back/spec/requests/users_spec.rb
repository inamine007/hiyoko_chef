require 'rails_helper'

describe 'UserAPI', type: :request do
  let!(:user) {create(:user)}

  it '全てのユーザーを取得する' do
    FactoryBot.create_list(:user, 9)

    get '/users'
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(10)
  end

  it '特定のユーザーを取得する' do
    get "/users/#{user.id}"
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data']['name']).to eq(user.name)
  end

  it 'ログインユーザーを取得する' do
    get "/users/whoami", headers: auth_headers(user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data']['name']).to eq(user.name)
  end

  it '新しいユーザーを作成する' do
    valid_params = { name: 'test', email: 'test@example.com', password: 'password', password_confirmation: 'password' }

    expect { post '/auth', params: { user: valid_params } }.to change(User, :count).by(+1)

    expect(response.status).to eq(200)
  end

  it 'ユーザーの編集を行う' do
    put "/auth", params: { name: "new" }.to_json, headers: auth_headers(user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data']['name']).to eq('new')
 end

  it 'ユーザーを削除する' do
    expect { delete "/auth", headers: auth_headers(user) }.to change(User, :count).by(-1)

    expect(response.status).to eq(200)
  end
end
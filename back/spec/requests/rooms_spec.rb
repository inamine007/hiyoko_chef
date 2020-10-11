require 'rails_helper'

describe 'RoomAPI', type: :request do
  let(:user1) { create(:user, name: 'testa') }
  let(:user2) { create(:user, name: 'testb', email: 'testb@example.com') }
  let!(:room) { create(:room, users: [user1, user2]) }

  it 'current_userが属している全てのルームを取得する' do
    FactoryBot.create_list(:room, 10, users: [user1, FactoryBot.create(:user)])
    
    get '/rooms', headers: auth_headers(user1)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(11)
  end

  it 'current_userが属している特定のルームを取得する' do
    get "/rooms/#{room.id}", headers: auth_headers(user1)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data']['name']).to eq('room')
    expect(json['data_user'][0]['name']).to eq('testb')
    expect(json['data_user'][1]['name']).to eq('testa')
  end

  it '新しいルームを作成する' do
    valid_params = { name: 'room2', user_id: user2.id }

    expect { post '/rooms', params: valid_params.to_json, headers: auth_headers(user1) }.to change(Room, :count).by(+1)

    expect(response.status).to eq(200)
  end

  it 'ルームを削除する' do
    expect { delete "/rooms/#{room.id}", headers: auth_headers(user1) }.to change(Room, :count).by(-1)

    expect(response.status).to eq(200)
  end
end
require 'rails_helper'

describe 'NotificationAPI', type: :request do
  let(:user1) { create(:user, name: 'testa') }
  let(:user2) { create(:user, name: 'testb', email: 'testb@example.com') }
  let(:room) { create(:room) }
  let!(:notification) { create(:notification, visited: user1, visitor: user2, room_id: room.id) }

  it 'current_userの全ての通知を取得する' do
    FactoryBot.create_list(:notification, 10, visited: user1, visitor: user2, room_id: room.id)

    get "/notifications", headers: auth_headers(user1)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(11)
  end

  it 'current_userの全ての未確認通知を取得し、確認済にする' do
    FactoryBot.create_list(:notification, 10, visited: user1, visitor: user2, room_id: room.id)

    get "/notifications/checked", headers: auth_headers(user1)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    json['data'].each do |data|
      expect(data['attributes']['checked']).to eq(true)
    end
  end

  it '通知を全て削除する' do
    get "/notifications/destroy_all", headers: auth_headers(user1)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(0)
  end
end
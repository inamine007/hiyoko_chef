require 'rails_helper'

describe 'MessageAPI', type: :request do
  let(:user1) { create(:user) }
  let!(:message) { create(:message) }

  it 'ルームに属している全てのメッセージを取得する' do
    FactoryBot.create_list(:message, 10, user: message.user, room: message.room)

    get "/rooms/#{message.room.id}/messages", headers: auth_headers(message.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(11)
  end

  it '新しいメッセージを作成する' do
    user2 = create(:user, name: 'testb', email: 'testb@example.com')
    room = create(:room, users: [user1, user2], user_id: user1.id)

    valid_params = { content: 'message2' }

    expect { post "/rooms/#{room.id}/messages", params: valid_params.to_json, headers: auth_headers(user1) }.to change(Message, :count).by(+1)

    expect(response.status).to eq(200)
  end

  it 'メッセージを削除する' do
    expect { delete "/rooms/#{message.room.id}/messages/#{message.id}", params: { id: message.id }.to_json, headers: auth_headers(message.user) }.to change(Message, :count).by(-1)

    expect(response.status).to eq(200)
  end
end

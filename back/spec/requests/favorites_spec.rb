require 'rails_helper'

describe 'FavoriteAPI', type: :request do
  let!(:favorite) { create(:favorite) }

  it 'レシピにいいねした全てのユーザーのidを取得する' do
    user2 = create(:user, name: 'testa')
    favorite2 = create(:favorite, user: user2, recipe: favorite.recipe)

    get "/recipes/#{favorite.recipe.id}/favorites", headers: auth_headers(favorite.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(2)
    expect(json['data']).to eq([favorite.user.id, user2.id])
  end

  it 'レシピにいいねした全てのユーザーを取得する' do
    user2 = create(:user, name: 'testa')
    favorite2 = create(:favorite, user: user2, recipe: favorite.recipe)

    get "/recipes/#{favorite.recipe.id}/favorites/users", headers: auth_headers(favorite.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(2)
    expect(json['data'][0]['attributes']['name']).to eq(favorite.user.name)
    expect(json['data'][1]['attributes']['name']).to eq('testa')
  end

  it 'レシピにいいねする' do
    recipe = create(:recipe)
    expect { post "/recipes/#{recipe.id}/favorites", headers: auth_headers(favorite.user) }.to change(Favorite, :count).by(+1)

    expect(response.status).to eq(200)
  end

  it 'いいねを削除する' do
    expect { delete "/recipes/#{favorite.recipe.id}", headers: auth_headers(favorite.user) }.to change(Favorite, :count).by(-1)

    expect(response.status).to eq(200)
  end
end
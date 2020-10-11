require 'rails_helper'

describe 'CategoryAPI', type: :request do
  let!(:category) {create(:category)}

  it '全てのユーザーを取得する' do
    FactoryBot.create_list(:category, 10)

    get '/categories'
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(11)
  end

  it 'current_userが作成したレシピのそれぞれのカテゴリーの合計数を取得する' do
    recipe = create(:recipe, category_ids: category.id)
    get '/categories/my_count', headers: auth_headers(recipe.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data']['category']).to eq(1)
  end

  it 'ユーザーが作成したレシピのそれぞれのカテゴリーの合計数を取得する' do
    user = create(:user)
    recipe = create(:recipe, category_ids: category.id, user: user)
    get "/categories/#{user.id}/user_count"
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data']['category']).to eq(1)
  end

  it '検索したカテゴリーに属している全てのレシピを取得する' do
    recipe = create(:recipe, name: 'pasta', category_ids: category.id)
    get "/categories/search", params: { name: "category" }
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'][0]['attributes']['name']).to eq('pasta')
  end
end
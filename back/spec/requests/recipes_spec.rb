require 'rails_helper'

describe 'RecipeAPI', type: :request do
  let!(:recipe) {create(:recipe)}

  it 'current_userの公開している全てのレシピを取得する' do
    FactoryBot.create_list(:recipe, 10, user: recipe.user)
    FactoryBot.create_list(:recipe, 10, user: recipe.user, status: 'draft')

    get '/recipes', headers: auth_headers(recipe.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(11)
  end

  it '特定のユーザーの公開している全てのレシピを取得する' do
    user = create(:user)
    FactoryBot.create_list(:recipe, 10, user: user)

    get "/recipes/#{user.id}/user", headers: auth_headers(recipe.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(10)
  end

  it '検索した公開しているレシピを取得する' do
    user = create(:user)
    recipe = create(:recipe, name: 'pasta', user: user)

    get "/recipes/search", params: { name: "pasta" }, headers: auth_headers(recipe.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'][0]['attributes']['name']).to eq('pasta')
  end

  it 'current_userの全てのレシピを取得する' do
    FactoryBot.create_list(:recipe, 10, user: recipe.user)

    get "/recipes/confirm", headers: auth_headers(recipe.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(11)
  end

  it '特定のレシピを取得する' do
    get "/recipes/#{recipe.id}", headers: auth_headers(recipe.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data']['name']).to eq(recipe.name)
  end

  it '新しいレシピを作成する' do
    category = create(:category)
    valid_params = { name: 'recipe2', description: 'text', cost: 100, time: 10, serve: 1, status: 'published', category_id: category.id, user: recipe.user }

    expect { post '/recipes', params: valid_params.to_json, headers: auth_headers(recipe.user) }.to change(Recipe, :count).by(+1)

    expect(response.status).to eq(200)
  end

  it 'レシピの編集を行う' do
    put "/recipes/#{recipe.id}", params: { name: "new" }.to_json, headers: auth_headers(recipe.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data']['name']).to eq('new')
 end

  it 'レシピを削除する' do
    expect { delete "/recipes/#{recipe.id}", headers: auth_headers(recipe.user) }.to change(Recipe, :count).by(-1)

    expect(response.status).to eq(200)
  end
end
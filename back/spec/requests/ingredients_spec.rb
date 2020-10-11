require 'rails_helper'

describe 'IngredientAPI', type: :request do
  let!(:ingredient) {create(:ingredient)}

  it 'current_userの全ての食材を取得する' do
    FactoryBot.create_list(:ingredient, 10, user: ingredient.user)

    get '/ingredients', headers: auth_headers(ingredient.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data'].length).to eq(11)
  end

  it '特定の食材を取得する' do
    get "/ingredients/#{ingredient.id}", headers: auth_headers(ingredient.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data']['name']).to eq(ingredient.name)
  end

  it '新しい食材を作成する' do
    valid_params = { name: 'ingredient2', trader: 'trader2', unit: '100g', unit_used: 'g', cost: 100, budomari: 1, converted_number: 0.1, cost_used: 10, user: ingredient.user }

    expect { post '/ingredients', params: valid_params.to_json, headers: auth_headers(ingredient.user) }.to change(Ingredient, :count).by(+1)

    expect(response.status).to eq(200)
  end

  it '食材の編集を行う' do
    put "/ingredients/#{ingredient.id}", params: { name: "new" }.to_json, headers: auth_headers(ingredient.user)
    json = JSON.parse(response.body)

    expect(response.status).to eq(200)

    expect(json['data']['name']).to eq('new')
 end

  it '食材を削除する' do
    expect { delete "/ingredients/#{ingredient.id}", headers: auth_headers(ingredient.user) }.to change(Ingredient, :count).by(-1)

    expect(response.status).to eq(200)
  end
end
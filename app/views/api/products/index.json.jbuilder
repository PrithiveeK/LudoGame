json.code 200
json.products do
    json.array!(@products) do |product|
        json.extract! product, :id, :name, :price, :currency
    end
end
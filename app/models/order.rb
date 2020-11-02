class Order < ApplicationRecord
    belongs_to :products
    belongs_to :users
end

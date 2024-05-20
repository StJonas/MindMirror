class User < ApplicationRecord
    has_secure_password :password, validations: false

    has_many :habits
  end
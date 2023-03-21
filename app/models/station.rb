class Station < ApplicationRecord
  geocoded_by :address

  def address
    ""
  end
end

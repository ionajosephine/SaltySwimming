# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
if Rails.env.development? 
  user = User.create(email: "example@example.com", password: "password")

  stations = Station.create([
    {
      name: "St. Ives",
      latitude: 0.50216666e2,
      longitude: -0.5483333e1,
      admiralty_id: "0547"
    }, 
    {
      name: "Perranporth",
      latitude:  0.5035e2,
      longitude: -0.515e1,
      admiralty_id: "0546A"
    }
    ])

  spots = Spot.create!([
    {
      name: "Lula's",
      latitude: 0.5019081450156216e2,
      longitude: -0.5431511912371633e1,
      user: user,
      station: stations.first,
      condition: "high_water",
      notes: "The length of time the pool is here depends on the height of the tide - the higher the tide the longer you can swim!"
    },
    {
      name: "Portreath Rock Pool",
      latitude: 0.5026392683452042e2,
      longitude: -0.529258625598294e1,
      user: user,
      station: stations.second,
      condition: "high_water",
      notes: "Caution! Rocks are very slippery!"
    },
    {
      name: "Perranporth Rock Pool",
      latitude: 0.5034856302432303e2,
      longitude: -0.5156910613189098e1,
      user: user,
      station: stations.second,
      condition: "low_water",
      notes: "This rock pool is actually in the middle of the beach! Also known as Chapel Rock Pool"
    }
  ])
end
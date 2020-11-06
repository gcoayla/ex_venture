{:ok, _user} =
  ExVenture.Users.create(%{
    username: "user",
    email: "user@example.com",
    password: "password",
    password_confirmation: "password"
  })

{:ok, admin} =
  ExVenture.Users.create(%{
    username: "admin",
    email: "admin@example.com",
    password: "password",
    password_confirmation: "password"
  })

{:ok, _admin} =
  admin
  |> Ecto.Changeset.change(%{role: "admin"})
  |> ExVenture.Repo.update()

#
# The World
#

{:ok, sammatti} =
  ExVenture.Zones.create(%{
    name: "Sammatti",
    description: "The starter town."
  })

{:ok, _town_square} =
  ExVenture.Rooms.create(sammatti, %{
    name: "Town Square",
    description: "A small town square.",
    listen: "The town crier is telling the latest news.",
    map_icon: "wooden-sign",
    x: 0,
    y: 0,
    z: 0
  })

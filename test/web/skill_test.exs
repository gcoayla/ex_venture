defmodule Web.SkillTest do
  use Data.ModelCase

  alias Web.Skill

  setup do
    %{class: create_class()}
  end

  test "creating a skill", %{class: class} do
    params = %{
      "name" => "Slash",
      "command" => "slash",
      "description" => "Slash at the target",
      "user_text" => "You slash at your {target}",
      "usee_text" => "You are slashed at by {who}",
      "points" => 3,
      "effects" => "[]",
    }

    {:ok, skill} = Skill.create(class, params)

    assert skill.name == "Slash"
    assert skill.class_id == class.id
  end
end
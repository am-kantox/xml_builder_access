defmodule XmlBuilder.Access.Test do
  use ExUnit.Case, async: true
  doctest XmlBuilder.Access

  setup_all do
    [
      person:
        {:person, %{id: 12_345},
         [
           {:first, %{}, "Josh"},
           {:last, %{}, "Nussbaum"},
           {:first, %{}, "Jane"},
           {:last, %{}, "Doe"},
           {:subperson, %{class: "nested"},
            [
              {:first, %{}, "John"},
              {:last, %{}, "Doe"}
            ]}
         ]}
    ]
  end

  test "get_in/2", %{person: person} do
    assert get_in(person, [
             XmlBuilder.Access.key(:subperson),
             XmlBuilder.Access.key(:first)
           ]) == {:first, %{}, "John"}

    assert get_in(person, [XmlBuilder.Access.key({:last, 1})]) == {:last, %{}, "Doe"}
    assert get_in(person, [XmlBuilder.Access.key({:last, -1})]) == {:last, %{}, "Doe"}
    assert get_in(person, [XmlBuilder.Access.key({:last, -2})]) == {:last, %{}, "Nussbaum"}
    assert get_in(person, [XmlBuilder.Access.key({:last, -3})]) == nil
  end

  test "put_in/2", %{person: person} do
    assert put_in(
             person,
             [
               XmlBuilder.Access.key(:subperson),
               XmlBuilder.Access.key(:first)
             ],
             "Mary"
           ) ==
             {:person, %{id: 12_345},
              [
                {:first, %{}, "Josh"},
                {:last, %{}, "Nussbaum"},
                {:first, %{}, "Jane"},
                {:last, %{}, "Doe"},
                {:subperson, %{class: "nested"}, [{:first, %{}, "Mary"}, {:last, %{}, "Doe"}]}
              ]}

    assert put_in(person, [XmlBuilder.Access.key({:first, 1})], "Mary") ==
             {:person, %{id: 12_345},
              [
                {:first, %{}, "Josh"},
                {:last, %{}, "Nussbaum"},
                {:first, %{}, "Mary"},
                {:last, %{}, "Doe"},
                {:subperson, %{class: "nested"}, [{:first, %{}, "John"}, {:last, %{}, "Doe"}]}
              ]}

    assert put_in(person, [XmlBuilder.Access.key({:first, -1})], "Mary") ==
             {:person, %{id: 12_345},
              [
                {:first, %{}, "Josh"},
                {:last, %{}, "Nussbaum"},
                {:first, %{}, "Mary"},
                {:last, %{}, "Doe"},
                {:subperson, %{class: "nested"}, [{:first, %{}, "John"}, {:last, %{}, "Doe"}]}
              ]}

    assert put_in(person, [XmlBuilder.Access.key({:first, 2})], "Mary") ==
             {:person, %{id: 12_345},
              [
                {:first, %{}, "Josh"},
                {:last, %{}, "Nussbaum"},
                {:first, %{}, "Jane"},
                {:last, %{}, "Doe"},
                {:subperson, %{class: "nested"}, [{:first, %{}, "John"}, {:last, %{}, "Doe"}]},
                {:first, %{id: 12_345}, "Mary"}
              ]}
  end

  test "pop_in/2", %{person: person} do
    assert pop_in(person, [
             XmlBuilder.Access.key(:subperson),
             XmlBuilder.Access.key(:first)
           ]) ==
             {{:first, %{}, "John"},
              {:person, %{id: 12_345},
               [
                 {:first, %{}, "Josh"},
                 {:last, %{}, "Nussbaum"},
                 {:first, %{}, "Jane"},
                 {:last, %{}, "Doe"},
                 {:subperson, %{class: "nested"}, [{:last, %{}, "Doe"}]}
               ]}}
  end
end

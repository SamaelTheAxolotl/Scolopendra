defmodule Pluszaki do
  @moduledoc """
  Kalkulator ceny pluszaków - wersja interaktywna.
  """

  @cennik %{
    rozmiar: [
      {"mały", 20},
      {"średni", 35},
      {"duży", 50}
    ],
    kolor: [
      {"czerwony", 0},
      {"niebieski", 0},
      {"zielony", 0},
      {"różowy", 5},
      {"złoty", 10}
    ],
    dodatki: [
      {"kokarda", 5},
      {"okulary", 8},
      {"czapka", 7},
      {"serduszko", 3}
    ],
    materiał: [
      {"standardowy", 0},
      {"premium", 15},
      {"eko", 10}
    ]
  }

  def run do
    IO.puts("Kalkulator ceny pluszaków")

    rozmiar = wybierz_opcje("rozmiar")
    kolor = wybierz_opcje("kolor")
    dodatki = wybierz_dodatki()
    materiał = wybierz_opcje("materiał")

    cena = oblicz_cene(rozmiar, kolor, dodatki, materiał)

    IO.puts("\nPodsumowanie:")
    IO.puts("Rozmiar: #{rozmiar}")
    IO.puts("Kolor: #{kolor}")
    IO.puts("Dodatki: #{Enum.join(dodatki, ", ")}") 
    IO.puts("Materiał: #{materiał}")
    IO.puts("-------------------")
    IO.puts("Cena końcowa: #{cena} zł")
  end

  defp wybierz_opcje(kategoria) do
    opcje = @cennik[String.to_atom(kategoria)]
    
    IO.puts("\nWybierz #{kategoria}:")
    Enum.each(Enum.with_index(opcje, 1), fn {{nazwa, _}, i} -> 
      IO.puts("#{i}. #{nazwa}") 
    end)

    wybór = IO.gets("Twój wybór (1-#{length(opcje)}): ") |> String.trim() |> String.to_integer()
    {nazwa, cena} = Enum.at(opcje, wybór - 1)
    nazwa
  end

  defp wybierz_dodatki do
    opcje = @cennik[:dodatki]
    
    IO.puts("\nWybierz dodatki (możesz wybrać kilka, np. '1 3'):")
    Enum.each(Enum.with_index(opcje, 1), fn {{nazwa, _}, i} -> 
      IO.puts("#{i}. #{nazwa}") 
    end)

    wybory = IO.gets("Twój wybór (np. '1 3' lub 0 aby pominąć): ") 
      |> String.trim()
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    if wybory == [0] do
      []
    else
      wybory
      |> Enum.map(fn i -> elem(Enum.at(opcje, i - 1), 0) end)
    end
  end

  defp oblicz_cene(rozmiar, kolor, dodatki, materiał) do
    {_, cena_rozmiaru} = Enum.find(@cennik[:rozmiar], fn {n, _} -> n == rozmiar end)
    {_, cena_koloru} = Enum.find(@cennik[:kolor], fn {n, _} -> n == kolor end)
    {_, cena_materialu} = Enum.find(@cennik[:materiał], fn {n, _} -> n == materiał end)
    
    cena_dodatkow = Enum.reduce(dodatki, 0, fn dodatek, acc ->
      {_, cena} = Enum.find(@cennik[:dodatki], fn {n, _} -> n == dodatek end)
      acc + cena
    end)

    cena_rozmiaru + cena_koloru + cena_materialu + cena_dodatkow
  end
end

Pluszaki.run()

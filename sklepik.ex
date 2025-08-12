defmodule Pluszaki do
  @moduledoc """
  Moduł do obliczania ceny pluszaków na podstawie wybranych opcji.
  """

  @cennik %{
    rozmiar: %{
      "mały" => 20,
      "średni" => 35,
      "duży" => 50
    },
    kolor: %{
      "czerwony" => 0,
      "niebieski" => 0,
      "zielony" => 0,
      "różowy" => 5,
      "złoty" => 10
    },
    dodatki: %{
      "kokarda" => 5,
      "okulary" => 8,
      "czapka" => 7,
      "serduszko" => 3
    },
    materiał: %{
      "standardowy" => 0,
      "premium" => 15,
      "eko" => 10
    }
  }


  def oblicz_cene(opcje) do
    cena_rozmiaru = @cennik[:rozmiar][opcje[:rozmiar]] || 0
    cena_koloru = @cennik[:kolor][opcje[:kolor]] || 0
    
    cena_dodatkow = if opcje[:dodatki] do
      Enum.reduce(opcje[:dodatki], 0, fn dodatek, acc -> acc + (@cennik[:dodatki][dodatek] || 0) end)
    else
      0
    end
    
    cena_materialu = @cennik[:materiał][opcje[:materiał]] || 0

    cena_rozmiaru + cena_koloru + cena_dodatkow + cena_materialu
  end

  def dodaj_opcje(kategoria, opcja, cena) when is_atom(kategoria) do
    if Map.has_key?(@cennik, kategoria) do
      updated_cennik = put_in(@cennik, [kategoria, opcja], cena)
      Module.put_attribute(__MODULE__, :cennik, updated_cennik)
      :ok
    else
      {:error, "Nieznana kategoria"}
    end
  end
end

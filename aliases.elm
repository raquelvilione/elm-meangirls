module Aliases exposing (..)
-- ----------------------------------------------------------------------------------------------------------------------
-- TYPE
-- ----------------------------------------------------------------------------------------------------------------------
type alias DadosUsuario =
  { nome : String
  , sobrenome : String
  , email : String
  , senha : String
  , confirmarSenha : String
  , loginToken : String
  }
  
type alias Stock =
  { id_ : Int
  , nome : String
  , mediaNota : Float
  , poster : Maybe String
  , dataInicio : String
  , popularidade : Float
  , sinopse : String
  }

type alias Populares =
  { id_ : Int
  , nome : String
  , mediaNota : Float
  , poster : Maybe String
  , dataInicio : String
  , popularidade : Float
  , sinopse : String
  }
  
type alias AiringToday =
  { id_ : Int
  , nome : String
  , mediaNota : Float
  , poster : Maybe String
  , dataInicio : String
  , popularidade : Float
  , sinopse : String
  }
  
type alias SerieAtual =
  { id_ : Int
  , nome : String
  , mediaNota : Float
  , poster : Maybe String
  , dataInicio : String
  , popularidade : Float
  , sinopse : String
  }

type alias Temporadas =
  { id : Int
  , episode_count : Int
  , air_date : String
  , poster_path : String
  , season_number : Int
  }

type alias Episodios =
  { id : Int
  , episode_number : Int
  , name : String
  }

type alias Generos =
  { id : Int
  , nome : String
  }

type alias SeriesGenero =
  { nome : String
  , id : Int
  }
-- ----------------------------------------------------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------------------------------------------------

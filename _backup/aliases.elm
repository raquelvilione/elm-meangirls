module Aliases exposing (..)

type alias Stock =
  { id_ : Int
  , nome : String
  , mediaNota : Float
  , poster : Maybe String
  , dataInicio : String
  , popularidade : Float
  }

type alias DadosUsuario =
  { nome : String
  , sobrenome : String
  , email : String
  , senha : String
  , confirmarSenha : String
  }
  
type alias DadosLogin =
  { email : String
  , senha : String
  , mensagem : String
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
  
-- type alias Temporadas =
--   { numEpisodios : Int
--   , id : Int
--   , poster : Maybe String
--   , numTemporada : Int
--   }
  
type alias Generos =
  { id : Int
  , nome : String
  }

type alias SeriesGenero =
  { nome : String
  , id : Int
  }

type alias Temporadas =
  {  
   id : Int
  ,episode_count : Int
  }
  
type alias Serie =
 {
   serie : Populares
   , temporadas : List Temporadas
 }
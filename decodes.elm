module Decodes exposing (..)
-- ----------------------------------------------------------------------------------------------------------------------
-- IMPORT
-- ----------------------------------------------------------------------------------------------------------------------
import Json.Decode exposing (string,int, field, float, list, Decoder,map2,map3,map4,map5,map6,map7,keyValuePairs, nullable)
import Aliases exposing (..)
-- ----------------------------------------------------------------------------------------------------------------------
-- DECODE
-- ----------------------------------------------------------------------------------------------------------------------
decodeStock : Decoder (List Stock)
decodeStock = 
        field "resp" <| list <| map7 Stock (field "idApi" int)
                                      (field "name" string)
                                      (field "vote_average" float)
                                      (field "poster_path" <| nullable string)
                                      (field "first_air_date" string)
                                      (field "popularity" float)
                                      (field "overview" string)
                                      
decodeRespLogin : Decoder String
decodeRespLogin = field "resp" <| string

decodePopulares : Decoder (List Populares)
decodePopulares = 
        field "results" <| list <| map7 Populares (field "id" int)
                                      (field "name" string)
                                      (field "vote_average" float)
                                      (field "poster_path" <| nullable string)
                                      (field "first_air_date" string)
                                      (field "popularity" float)
                                      (field "overview" string)
                                      
decodeAiringToday : Decoder (List AiringToday)
decodeAiringToday = 
        field "results" <| list <| map7 AiringToday (field "id" int)
                                      (field "name" string)
                                      (field "vote_average" float)
                                      (field "poster_path" <| nullable string)
                                      (field "first_air_date" string)
                                      (field "popularity" float)
                                      (field "overview" string)
                                      
decodeTemporadas : Decoder (List Temporadas)
decodeTemporadas = 
        field "seasons" <| list <| map5 Temporadas  (field "id" int) 
                                                    (field "episode_count" int)
                                                    (field "air_date" string)
                                                    (field "poster_path" string)
                                                    (field "season_number" int)
                                                    
decodeEpisodios : Decoder (List Episodios)
decodeEpisodios = 
        field "episodes" <| list <| map3 Episodios  (field "id" int) 
                                                    (field "episode_number" int)
                                                    (field "name" string)
                                                    
decodeGeneros : Decoder (List Generos)
decodeGeneros = 
        field "genres" <| list <| map2 Generos (field "id" int)
                                            (field "name" string)
      
decodeSeriesGenero : Decoder (List SeriesGenero)
decodeSeriesGenero = 
        field "results" <| list <| map2 SeriesGenero (field "original_name" string)
                                                     (field "id" int)
-- ----------------------------------------------------------------------------------------------------------------------
-- 
-- ----------------------------------------------------------------------------------------------------------------------
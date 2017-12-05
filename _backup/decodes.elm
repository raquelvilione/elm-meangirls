module Decodes exposing (..)

import Aliases exposing (..)
import Json.Decode exposing (string,int, field, float, list, Decoder,map2,map4,map6,map7,keyValuePairs, nullable)

decodeStock : Decoder (List Stock)
decodeStock = 
        field "results" <| list <| map6 Stock (field "id" int)
                                      (field "name" string)
                                      (field "vote_average" float)
                                      (field "poster_path" <| nullable string)
                                      (field "first_air_date" string)
                                      (field "popularity" float)
 
decodeRespLogin : Decoder (Int)
decodeRespLogin = field "id" <| int 

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
                                                    (field "air_date" int)
                                                    (field "poster_path" <| nullable string)
                                                    (field "season_number" int)

                                      
decodeGeneros : Decoder (List Generos)
decodeGeneros = 
        field "genres" <| list <| map2 Generos (field "id" int)
                                            (field "name" string)
      
decodeSeriesGenero : Decoder (List SeriesGenero)
decodeSeriesGenero = 
        field "results" <| list <| map2 SeriesGenero (field "original_name" string)
                                                     (field "id" int)
                                      
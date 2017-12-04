module Encodes exposing (..)
-- ----------------------------------------------------------------------------------------------------------------------
-- FIMPORT
-- ----------------------------------------------------------------------------------------------------------------------
import Json.Encode exposing (..)
import Aliases exposing (..)
-- ----------------------------------------------------------------------------------------------------------------------
-- ENCODE
-- ----------------------------------------------------------------------------------------------------------------------
encodeSerie : Stock -> Value
encodeSerie {id_, 
            nome, 
            mediaNota, 
            poster, 
            dataInicio, 
            popularidade} = object [("idApi", int id_),
                            ("name", string nome),
                            ("vote_average", float mediaNota),
                            ("poster_path", string <| Maybe.withDefault "" poster),
                            ("first_air_date", string dataInicio),
                            ("popularity", float popularidade)]
                            
encodeUsuario : DadosUsuario -> Value
encodeUsuario { 
            nome, 
            sobrenome, 
            email, 
            senha} = object [
                            ("nome", string nome),
                            ("sobrenome", string sobrenome),
                            ("email", string email),
                            ("senha", string senha)]
                            
encodeDadosUsuario : String -> String -> Value
encodeDadosUsuario email senha = list [ string email, string senha ]

encodePopulares : Populares -> Value
encodePopulares {id_, 
            nome, 
            mediaNota, 
            poster, 
            dataInicio, 
            popularidade} = object [("idApi", int id_),
                            ("name", string nome),
                            ("vote_average", float mediaNota),
                            ("poster_path", string <| Maybe.withDefault "" poster),
                            ("first_air_date", string dataInicio),
                            ("popularity", float popularidade)]
-- ----------------------------------------------------------------------------------------------------------------------
-- 
-- ----------------------------------------------------------------------------------------------------------------------
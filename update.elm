module Update exposing (..)
-- ----------------------------------------------------------------------------------------------------------------------
-- IMPORT
-- ----------------------------------------------------------------------------------------------------------------------
import Html exposing (table, thead,h1,b, tbody, a, li,ul, tr, td, text, input, label, fieldset, div, form, button, Html, program,img,p,h5,span,i,hr,option,select)
import Html.Events exposing (onSubmit, onInput, onClick, on)
import Html.Attributes exposing (type_, placeholder,href, value, required, style, min,height,src,class,id,target)
import Http exposing (post, send, get,jsonBody,Request,Body,expectJson,request,header)
import Json.Decode exposing (string,int, field, float, list, Decoder,map6,keyValuePairs, nullable)
import Regex exposing (..)
import Aliases exposing (..)
import Encodes exposing (..)
import Decodes exposing (..)
import Get exposing (..)
import Model exposing (..)
import Portas exposing (..)
import Post exposing (..)
import Type exposing (..)
-- ----------------------------------------------------------------------------------------------------------------------
-- UPDATE
-- ----------------------------------------------------------------------------------------------------------------------
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MudarPagina x ->
            ({ model | view = x}, Cmd.none)
    -- CADASTRO USUÁRIO
        Nome x ->
            ({ model | usuario = (\y -> {y | nome = x}) model.usuario}, Cmd.none)
          
        Sobrenome x ->
             ({ model | usuario = (\y -> {y | sobrenome = x}) model.usuario}, Cmd.none)
          
        Email x ->
            ({ model | usuario = (\y -> {y | email = x}) model.usuario}, Cmd.none)
      
        Senha x ->
            ({ model | usuario = (\y -> {y | senha = x}) model.usuario}, Cmd.none)
      
        ConfirmarSenha x ->
            ({ model | usuario = (\y -> {y | confirmarSenha = x}) model.usuario}, Cmd.none)
            
        RespostaCadastro respCad ->
            case respCad of
                Err x -> (model, Cmd.none)
                Ok x -> ({model | view = if x.status.code == 201 then PagLogin else PagCadastro}, Cmd.none)
          
        CadastrarUsuario dadosUser ->
            (model, Http.send RespostaCadastro <| postWhole "https://meangirls-raquelvilione.c9users.io/usuario/inserir" (jsonBody (encodeUsuario dadosUser)) int)
-- ---------------------------------------------------------
-- LOGIN
-- ---------------------------------------------------------
        RespostaLogin resp ->
            case resp of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                -- Ok lista -> ({model | dados = lista}, Cmd.none)
                Ok x -> ({ model | mensagem = "LOGADO" }, Cmd.none)
                
        Login dadoslogin ->
            (model, Http.send RespostaLogin <| post "https://meangirls-raquelvilione.c9users.io/login/" (jsonBody (encodeDadosUsuario model.usuario.email model.usuario.senha)) decodeRespLogin)
-- ---------------------------------------------------------
-- PESQUISA
-- ---------------------------------------------------------  
        SymbolSearch digitado ->
            ({ model | symbol = digitado }, Cmd.none)

        SubmitSearch ->
            (model, getStocks model.symbol)

        RespostaSearch resp ->
            case resp of
                Err x -> ({ model | symbol = toString x}, Cmd.none)
                Ok lista -> ({model | stocks = lista}, Cmd.none)
        
        CadastrarSerie stock ->
            (model, Http.send ResCadastrarSerie <| post "https://meangirls-raquelvilione.c9users.io/serie/inserir" (jsonBody (encodeSerie stock)) int)
            
        ResCadastrarSerie resposta ->
            case resposta of
                Err x -> ({ model | symbol = toString x}, Cmd.none)
                Ok lista -> ({model | symbol = toString lista}, Cmd.none)
-- ---------------------------------------------------------
-- POPULARES
-- ---------------------------------------------------------
        RespostaSeriesPopulares resp ->
            case resp of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok lista -> ({model | seriespopulares = lista, mensagem = "ok"}, carousel "")
        
        CadSeriePopulares popular ->
            (model, Http.send ResCadSeriesPopulares <| post "https://meangirls-raquelvilione.c9users.io/serie/inserir" (jsonBody (encodePopulares popular)) int)
            
        ResCadSeriesPopulares resposta ->
            case resposta of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok lista -> (model, Cmd.none)
-- ----------------------------------------------------------------------------------------------------------------------
-- 
-- ----------------------------------------------------------------------------------------------------------------------
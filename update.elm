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
        MudarPagina PagLogin ->
            (Model
                (DadosUsuario "" "" "" "" "" "")
                (Stock 0 "" 0 Nothing "" 0 "")
                [] [] "" "" [] []
                (SerieAtual 0 "" 0 Nothing "" 0 "")
                (AiringToday 0 "" 0 Nothing "" 0 "")
                [Temporadas 0 0 "" "" 0]
                [Episodios 0 0 ""]
                [Generos 0 ""]
                ""
                (SeriesGenero "" 0)
                [SeriesGenero "" 0]
                PagLogin, Cmd.batch [getPopulares, getAiringToday, getGeneros])
        MudarPagina PagMinhaLista ->
            ({ model | view = PagMinhaLista}, getMinhaLista model.usuario.loginToken)
        MudarPagina x ->
            ({ model | view = x }, Cmd.none)
-- ----------------------------------------------------------------------------------------------------------------------
-- CADASTRO USUÁRIO
-- ----------------------------------------------------------------------------------------------------------------------
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
                Ok x -> ({ model | usuario = (\y -> {y | loginToken = x}) model.usuario, view = PagStock }, Cmd.none)
                
        Login dadoslogin ->
            (model, Http.send RespostaLogin <| post "https://meangirls-raquelvilione.c9users.io/login/" (jsonBody (encodeDadosUsuario model.usuario.email model.usuario.senha)) decodeRespLogin)
-- ---------------------------------------------------------
-- PESQUISA
-- ---------------------------------------------------------  
        SymbolSearch digitado ->
            ({ model | symbol = digitado }, Cmd.none)

        SubmitSearch ->
            ({model | view = PagSearch}, getStocks model.symbol)

        RespostaSearch resp ->
            case resp of
                Err x -> ({ model | symbol = toString x}, Cmd.none)
                Ok lista -> ({model | stocks = lista}, Cmd.none)
        
        CadastrarSerie stock ->
            (model, Http.send ResCadastrarSerie <| post ("https://meangirls-raquelvilione.c9users.io/serie/inserir/" ++ model.usuario.loginToken) (jsonBody (encodeSerie stock)) int)
            
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
-- ---------------------------------------------------------
-- AIRING TODAY
-- ---------------------------------------------------------
        RespostaAiringToday resp ->
            case resp of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok lista -> ({model | seriesairingtoday = lista, mensagem = "ok"}, carousel "")
            
        CadSerieAiringToday airingtodayy ->
            (model, Http.send ResCadSerieAiringToday <| post "https://meangirls-raquelvilione.c9users.io/serie/inserir" (jsonBody (encodeAiringToday airingtodayy)) int)
            
        ResCadSerieAiringToday resposta ->
            case resposta of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok lista -> (model, Cmd.none)
-- ---------------------------------------------------------
-- SÉRIE
-- ---------------------------------------------------------                
        VerSerie dadosSerie ->
            ({ model | serieAtual = dadosSerie, view = PagSerie}, Cmd.none)
        
        SubmitTemporada id ->
            (model, getTemporadas <| toString id)
        
        RespostaTemp x ->
            case x of
                Err y -> ({model | mensagem = "hioyioshjdf"}, Cmd.none)
                Ok y  -> ({model | temporadas = y}, Cmd.none)
        
        SubmitEpisodios idS numT ->
            (model, getEpisodios (toString idS, toString numT))
        
        RespostaEps z  ->
            case z of
                Err y -> ({model | mensagem = "hioyioshjdf"}, Cmd.none)
                Ok y  -> ({model | episodios = y}, Cmd.none)
-- ---------------------------------------------------------
-- GÊNEROS
-- ---------------------------------------------------------
        RespostaG resp ->
            case resp of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok lista -> ({model | generos = lista, mensagem = "ok"}, Cmd.none)
        
        GeneroEscolhido g ->
            ({ model | generoEscolhido = g }, getSeriesGenero model.generoEscolhido)
        
        Buscar ->
            (model, getSeriesGenero model.generoEscolhido)
        
        RespostaSG r ->
            case r of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok l -> ({model | seriesGenero = l, mensagem = "blz", view = PagSerieGenero}, Cmd.none)
-- ----------------------------------------------------------------------------------------------------------------------
-- 
-- ----------------------------------------------------------------------------------------------------------------------
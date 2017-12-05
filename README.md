# PROJETO DE HASKELL

> Trabalho desenvolvido para a disciplina de Tópicos Especiais em Informática ministrada pelo Professor Me. Alexandre Garcia de Oliveira

## TVBOX

> TvBox é um site desenvolvido para organizar suas séries

> O projeto foi desenvolvido em três camadas:
    
* Banco de Dados - [Heroku](https://www.heroku.com/)
* BackEnd - [Framework Yesod](https://www.yesodweb.com/)
* FrontEnd - [Elm](http://elm-lang.org/)

| Rotas                            | Descrição                                                    | Métodos HTTP  |
| -------------------------------- |:------------------------------------------------------------:| :------------:|
| /usuario/inserir                 | Efetua o cadastro de um novo usuário                         | POST          |
| /login                           | Verifica se o usuario e senha existem no banco de dados      | POST          |
| /serie/inserir/#Text             | Efetua o cadastro de uma série escolhida pelo usuário        | POST          |
| /serie/#Text/#UsuarioId/#SerieId | Deleta uma série da lista do usuário                         | DELETE        |
| /serie/listar-todas/#Text        | Lista as séries do usuário                                   | GET           |
     

#### USUÁRIO

##### Cadastrar Usuário

    curl -X POST https://meangirls-raquelvilione.c9users.io/usuario/inserir -d '{"nome": "Estela", "sobrenome": Marques", "email": "estela@gmail.com", "senha": "123", "token": <token>}' -H "accept: application/json"
    curl -X POST https://meangirls-raquelvilione.c9users.io/usuario/inserir -d '{"nome": "Raquel", "sobrenome": Vilione", "email": "raquel@gmail.com", "senha": "123", "token": <token>}' -H "accept: application/json"
    curl -X POST https://meangirls-raquelvilione.c9users.io/usuario/inserir -d '{"nome": "Rita", "sobrenome": Lino", "email": "rita@gmail.com", "senha": "123", "token": <token>}' -H "accept: application/json"

##### Login Usuário

    curl -X POST https://meangirls-raquelvilione.c9users.io/login -d '["estela@gmail.com, "123"]' -H "accept: application/json"
    curl -X POST https://meangirls-raquelvilione.c9users.io/login -d '["raquel@gmail.com, "123"]' -H "accept: application/json"
    curl -X POST https://meangirls-raquelvilione.c9users.io/login -d '["rita@gmail.com, "123"]' -H "accept: application/json"
    
#### SÉRIE

##### Cadastrar Série

    curl -X POST https://meangirls-raquelvilione.c9users.io/serie/inserir/#Text -d '{"idApi": 1413, "name": "American Horror Story", "vote_average": 6.92, "poster_path": "/gwSzP1cJL2HsBmGStN2vOg3d4Qd.jpg", "first_air_date": "2011-10-05", "popularity": 36.378911, "overview": "American Horror Story is an anthology horror drama series."}' -H "accept: application/json"
    curl -X POST https://meangirls-raquelvilione.c9users.io/serie/inserir/#Text -d '{"idApi": 61889, "name": "Marvel's Daredevil", "vote_average": 7.63, "poster_path": "/cidOqJL8tayqvv3TpfTQCsgeITu.jpg", "first_air_date": "2015-04-10", "popularity": 32.435077, "overview": "Lawyer-by-day Matt Murdock uses his heightened senses from being blinded as a young boy to fight crime at night on the streets of Hell’s Kitchen as Daredevil."}' -H "accept: application/json"
    curl -X POST https://meangirls-raquelvilione.c9users.io/serie/inserir/#Text -d '{"idApi": 1402, "name": "The Walking Dead", "vote_average": 7.41, "poster_path": "/vxuoMW6YBt6UsxvMfRNwRl9LtWS.jpg", "first_air_date": "2010-10-31", "popularity": 194.114756, "overview": "Sheriff's deputy Rick Grimes awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way."}' -H "accept: application/json"

##### Deletar Série

    curl -X POST https://meangirls-raquelvilione.c9users.io/serie/#Text/#UsuarioId/#SerieId -d '{} -H "accept: application/json"
    
##### Listar Série

    curl -X POST https://meangirls-raquelvilione.c9users.io/serie/listar-todas/#Text-d '{} -H "accept: application/json"

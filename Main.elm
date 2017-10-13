module Main exposing (..)

import Html exposing (..)
import GraphQL.Request.Builder as B
import GraphQL.Client.Http as GraphQLClient
import Schema.User as User
import Schema.Role as Role
import Task


main : Program Never Model Msg
main =
    program
        { view = view
        , update = update
        , init = init
        , subscriptions = subscriptions
        }


view : Model -> Html Msg
view model =
    div [] [ text "hello" ]


type alias Model =
    { user : Maybe UserSummary
    }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing, GraphQLClient.sendQuery "http://localhost:4000/api/" userRequest |> Task.attempt Response )


type Msg
    = Response (Result GraphQLClient.Error UserSummary)
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Response (Ok data) ->
            ( { model | user = Just data }, Cmd.none )

        Response (Err err) ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type alias Role =
    { name : String }


type alias UserSummary =
    { id : String
    , role : Role
    }



{-
   -- I would like to use a syntax like this, but I run into infinite types when I try and implement it.
   -- Someone more experienced should try and make this work.
   userSummary : B.ValueSpec B.NonNull B.ObjectType UserSummary vars
   userSummary =
       B.object UserSummary
           |> B.with User.id
           |> B.with
               (User.role Role
                   [ Role.name
                   ]
               )
-}


userSummary : B.ValueSpec B.NonNull B.ObjectType UserSummary vars
userSummary =
    B.object UserSummary
        |> B.with User.id
        |> B.with
            (User.role
                (B.object Role
                    |> B.with Role.name
                )
            )


userRequest : B.Request B.Query UserSummary
userRequest =
    User.query userSummary
        |> B.request { id = "32" }

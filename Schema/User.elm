module Schema.User exposing (..)

import GraphQL.Request.Builder as B
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Request.Builder.Arg as Arg


id : B.SelectionSpec B.Field String vars
id =
    B.field "id" [] B.id


email : B.SelectionSpec B.Field String vars
email =
    B.field "email" [] B.string


name : B.SelectionSpec B.Field String vars
name =
    B.field "name" [] B.string


role : B.ValueSpec nullability coreType result vars -> B.SelectionSpec B.Field result vars
role subObject =
    B.field "role" [] subObject


args : List ( String, Arg.Value { a | id : String } )
args =
    [ ( "id", Arg.variable (Var.required "id" .id Var.id) )
    ]


query : B.ValueSpec nullability coreType result { a | id : String } -> B.Document B.Query result { a | id : String }
query spec =
    let
        rootQuery =
            B.extract
                (B.field "user"
                    args
                    spec
                )
    in
        B.queryDocument rootQuery

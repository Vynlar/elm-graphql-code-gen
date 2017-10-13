module Schema.Role exposing (..)

import GraphQL.Request.Builder as B


name : B.SelectionSpec B.Field String vars
name =
    B.field "name" [] B.string

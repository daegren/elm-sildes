module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- MODEL --


type alias Model =
    { currentPage : Page
    , nextPage : Maybe Page
    , prevPage : Maybe Page
    }


type Page
    = First
    | Second
    | Third
    | Fourth


allPages : List Page
allPages =
    [ First, Second, Third, Fourth ]


initialModel : Model
initialModel =
    Model First (Just Second) Nothing


type Direction
    = Forward
    | Backward


rotate : Direction -> Page -> Maybe Page
rotate dir page =
    case ( dir, page ) of
        ( Forward, First ) ->
            Just Second

        ( Forward, Second ) ->
            Just Third

        ( Forward, Third ) ->
            Just Fourth

        ( Backward, Second ) ->
            Just First

        ( Backward, Third ) ->
            Just Second

        ( Backward, Fourth ) ->
            Just Third

        _ ->
            Nothing



-- UPDATE --


type Msg
    = NextPage
    | PrevPage


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    let
        newModel =
            case msg of
                NextPage ->
                    case model.nextPage of
                        Just next ->
                            { model
                                | currentPage = next
                                , nextPage = rotate Forward next
                                , prevPage = Just model.currentPage
                            }

                        Nothing ->
                            model

                PrevPage ->
                    case model.prevPage of
                        Just prev ->
                            { model
                                | currentPage = prev
                                , nextPage = Just model.currentPage
                                , prevPage = rotate Backward prev
                            }

                        Nothing ->
                            model
    in
    ( newModel, Cmd.none )



-- VIEW --


view : Model -> Html Msg
view model =
    div []
        [ div [ class "nav" ]
            [ button [ class "prev", onClick PrevPage ] [ text "Previous" ]
            , button [ class "next", onClick NextPage ] [ text "Next" ]
            ]
        , div [ id "pages" ] (List.map (pageView model) allPages)
        ]


pageView : Model -> Page -> Html msg
pageView model page =
    let
        classes =
            if page == model.currentPage then
                class "page current"
            else if Just page == model.nextPage then
                class "page next"
            else if Just page == model.prevPage then
                class "page prev"
            else
                class "page hidden"

        image =
            case page of
                First ->
                    img [ src "http://fillmurray.com/800/800" ] []

                Second ->
                    img [ src "http://fillmurray.com/600/800" ] []

                Third ->
                    img [ src "http://fillmurray.com/800/600" ] []

                Fourth ->
                    img [ src "http://fillmurray.com/750/300" ] []
    in
    div [ classes ]
        [ image ]



-- MAIN --


main : Program Never Model Msg
main =
    program
        { init = ( initialModel, Cmd.none )
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }

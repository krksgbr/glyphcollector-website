module UI exposing (..)

import Color
import Element as E exposing (fill, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as E
import Html.Attributes as HA


type DeviceClass
    = Phone
    | Tablet
    | Desktop


type Orientation
    = Portrait
    | Landscape


type alias Device =
    { orientation : Orientation
    , class : DeviceClass
    , isMobile : Bool
    , width : Int
    , height : Int
    }


id : String -> E.Attribute msg
id =
    E.htmlAttribute << HA.id


sectionTitle : DeviceClass -> String -> E.Element msg
sectionTitle deviceClass t =
    let
        { fontSize, paddingBottom } =
            case deviceClass of
                Phone ->
                    { fontSize = 30, paddingBottom = 20 }

                Tablet ->
                    { fontSize = 40, paddingBottom = 30 }

                _ ->
                    { fontSize = 50, paddingBottom = 30 }
    in
    E.el
        [ Font.size fontSize
        , E.paddingEach { top = 0, left = 0, right = 0, bottom = paddingBottom }
        ]
    <|
        text t


pageMargin : Device -> Int
pageMargin device =
    case ( device.class, device.orientation ) of
        ( Phone, Portrait ) ->
            10

        ( Phone, Landscape ) ->
            30

        ( Tablet, Portrait ) ->
            50

        ( Tablet, Landscape ) ->
            100

        _ ->
            200


section : Device -> List (E.Attribute msg) -> E.Element msg -> E.Element msg
section device =
    let
        paddingY =
            case device.class of
                Phone ->
                    20

                _ ->
                    30
    in
    E.el
        << (++)
            [ E.paddingXY (pageMargin device) paddingY
            , width fill
            ]


linkAttrs =
    [ E.mouseOver
        [ Font.color Color.accent
        ]
    ]


link : List (E.Attribute msg) -> { url : String, label : E.Element msg } -> E.Element msg
link =
    E.link << (++) linkAttrs


newTabLink : List (E.Attribute msg) -> { url : String, label : E.Element msg } -> E.Element msg
newTabLink =
    E.newTabLink << (++) linkAttrs


underLine : List (E.Attr () msg)
underLine =
    [ Border.color Color.accent
    , Border.widthEach { top = 0, left = 0, right = 0, bottom = 1 }
    ]


button : List (E.Attr () msg) -> { onPress : Maybe msg, label : E.Element msg } -> E.Element msg
button =
    E.button
        << (++)
            [ E.padding 20
            , Border.rounded 10
            , Background.color Color.black
            , Font.color Color.white
            , E.mouseOver
                [ Background.color Color.accent
                ]
            ]


classifyDevice : Bool -> { a | width : Int, height : Int } -> Device
classifyDevice isMobile window =
    -- Tested in this ellie:
    -- https://ellie-app.com/68QM7wLW8b9a1
    { class =
        let
            longSide =
                max window.width window.height

            shortSide =
                min window.width window.height
        in
        if shortSide < 600 && longSide <= 900 then
            Phone

        else if longSide <= 1200 then
            Tablet

        else
            Desktop
    , orientation =
        if window.width < window.height then
            Portrait

        else
            Landscape
    , isMobile = isMobile
    , width = window.width
    , height = window.height
    }

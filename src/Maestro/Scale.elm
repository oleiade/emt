module Maestro.Scale exposing (Scale, Mode(..), scale)

{-| This library fills a bunch of important niches in Elm. A `Maybe` can help
you with optional arguments, error handling, and records with optional fields.

# Types
@docs Scale, Mode

# Common Helpers
@docs scale

-}

import Maestro.Pitch exposing (Pitch)
import Maestro.Note exposing (Note, newNote)
import Maestro.Interval exposing (Interval(..), addInterval, majorIntervals, minorIntervals)


{-|
-}
type alias Scale =
    List Pitch


{-|
-}
type Mode
    = Major
    | Minor


{-|
-}
modeToIntervals : Mode -> List Interval
modeToIntervals mode =
    case mode of
        Major ->
            majorIntervals

        Minor ->
            minorIntervals


{-|
-}
scale : Pitch -> Mode -> List Pitch
scale tone mode =
    let
        placeholderNote =
            newNote tone.key tone.adjustment 3
    in
        List.map (\i -> (addInterval placeholderNote i).tone) (modeToIntervals mode)

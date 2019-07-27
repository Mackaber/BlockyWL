If[
  Not[ValueQ[$Session] && ValueQ[$Id]],
  $Session = <||>;
  $Id = 1;
]

(* ---------FUNCTIONS------- *)

FaceEars[image_, ear_] :=
    Block[{corners =
        PolygonCoordinates[
          CanonicalizePolygon[
            FindFaces[image][[1]]]] // {#[[2]], #[[4]]} &},
      ImageCompose[image, ear, corners[[1]] + {-10, 0}] //
          ImageCompose[#, ImageReflect[ear, Left],
            corners[[2]] + {+10, 0}] &];

DrawInside[el_, list_] :=
    With[{pos = PixelValuePositions[Rasterize@el, 0]},
      Graphics@MapThread[Text, {list[[;; (pos // Length)]], pos}]];

CheckAnswer[resp_, problem_] :=
    With[{answers = <|
        ButterflyString :>
            SameQ[resp,
              "Pneumonoultramicroscopicsilicovolcanoconiosissisoinoconaclovo\
ciliscipocsorcimartluonomuenP"],
        MostCommonLetters :>
            SameQ[Sort[resp], {"d", "e", "g", "s", "y"}]|>},
      If[answers[problem], Style["Correct!", Green, 20],
        Style["Wrong!", Red, 20]]];

(* ------------------------- *)

StoreResult[id_, expr_] :=
    $Session[id] = expr;

GetResult[id_] :=
    $Session[id]

ExportResult[id_, result_, exporter_] :=
    <|
        "id" -> id,
        "result" -> exporter[result]
        |>

(* ToDataUri[result_] := ExportString[result, {"Base64", "PNG"}]*)

(* *)
ToDataUri[result_] := ExportString[result, {"Base64", "SVG"}]

ToInputForm[result_] := ToString[result, InputForm]

(*ExportResult[id_, result_] :=
    <|
        "id" -> id,
        "type" -> ToString@Head[result],
        "symbol" -> result,
        "result" -> ToString@result
    |>*)

Execute[input_String, exporter_ : ToDataUri] := With[
  (* Time constrained, so the system doesn't hang...*)
  {id = $Id++, result = TimeConstrained[ToExpression[input], 30]},

  StoreResult[id, result];
  ExportResult[id, result, exporter]
]


EvaluationAPI[args__] :=
    HTTPResponse[
      APIFunction[
        {"code" -> "String"},
        Execute[#code, args] &,
        "JSON"
      ],
      <|"Headers" -> {"Access-Control-Allow-Origin" -> "*", "Content-Type" -> "application/json"} |>
    ]

ResultsAPI[args___] :=
    HTTPResponse[
      APIFunction[
        {"id" -> "Integer"},
        ExportResult[#id, GetResult[#id], args] &,
        "JSON"
      ],
      <|"Headers" -> {"Access-Control-Allow-Origin" -> "*", "Content-Type" -> "application/json"} |>
    ]



URLDispatcher[{
  "/evaluate" ~~ EndOfString :> EvaluationAPI[ToDataUri],
  "/evaluate/input" ~~ EndOfString :> EvaluationAPI[ToInputForm],
  "/result" ~~ EndOfString :> ResultsAPI[ToDataUri],
  "/result/input" ~~ EndOfString :> ResultsAPI[ToInputForm]
}]



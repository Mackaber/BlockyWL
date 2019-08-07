Import["functions.wl"]
Import["challenges.wl"]

If[
  Not[ValueQ[$Session] && ValueQ[$Id]],
  $Session = <||>;
  $Id = 1;
]

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



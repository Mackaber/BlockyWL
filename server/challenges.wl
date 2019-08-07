CheckAnswer[resp_, problem_] := With[
  {answers = <|
      ButterflyString :> SameQ[resp,
              "Pneumonoultramicroscopicsilicovolcanoconiosissisoinoconaclovo\
ciliscipocsorcimartluonomuenP"],

      MostCommonLetters :> SameQ[Sort[resp], {"d", "e", "g", "s", "y"}]

      (* ... *)
      |>
  },
  If[answers[problem], Style["Correct!", Green, 20],Style["Wrong!", Red, 20]]];

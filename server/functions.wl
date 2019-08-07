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

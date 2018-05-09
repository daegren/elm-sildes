import Elm from "./Main.elm";
import "./styles.css";

const elmRoot = document.getElementById("elm-root");

Elm.Main.embed(elmRoot);

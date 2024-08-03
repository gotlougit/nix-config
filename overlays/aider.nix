# ref: https://github.com/NixOS/nixpkgs/pull/323927/files
# TODO: get rid of it when merged into nixpkgs
{ lib, python311, fetchFromGitHub, portaudio }:

let
  grep-ast = python311.pkgs.buildPythonPackage rec {
    pname = "grep-ast";
    version = "a5dd50c8063360febe6ecf0acefca6c7f69198e1";
    src = fetchFromGitHub {
      owner = "paul-gauthier";
      repo = "grep-ast";
      rev = version;
      hash = "sha256-vrkplkOZdBYibbEK0pYPvVU/AQ6+d8BX6KcUWA8aX1o=";
    };
    propagatedBuildInputs = with python311.pkgs; [
      tree-sitter-languages
      pathspec
    ];
    doCheck = false;
  };
in
python311.pkgs.buildPythonApplication rec {
  pname = "aider";
  version = "0.47.0";
  src = fetchFromGitHub {
    owner = "paul-gauthier";
    repo = "aider";
    rev = "v${version}";
    hash = "sha256-kDGmP6X59H0nGPChSTiOBTbnJS3NRQqywjpo9qoB/rg=";
  };
  propagatedBuildInputs = with python311.pkgs; [
    backoff
    beautifulsoup4
    configargparse
    diff-match-patch
    diskcache
    flake8
    gitpython
    google-generativeai
    grep-ast
    importlib-resources
    importlib-metadata
    jsonschema
    litellm
    networkx
    numpy
    openai
    packaging
    pathspec
    pillow
    playwright
    prompt-toolkit
    pypandoc
    pyyaml
    rich
    scipy
    sounddevice
    soundfile
    streamlit
    tiktoken
    watchdog
  ] ++ [ portaudio ];
  doCheck = false;
  meta = {
    description = "AI pair programming in your terminal";
    homepage = "https://github.com/paul-gauthier/aider";
    license = lib.licenses.asl20;
    mainProgram = "aider";
    maintainers = with lib.maintainers; [ taha-yassine ];
  };
}

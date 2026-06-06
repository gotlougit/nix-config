{
  autoPatchelfHook,
  fetchurl,
  lib,
  python3Packages,
  stdenv,
  vulkan-loader,
}:

let
  version = "0.13.1";

  litert-lm-api = python3Packages.buildPythonPackage {
    pname = "litert-lm-api";
    inherit version;
    format = "wheel";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/36/27/bb0c2e084d59938bc12f960db50e7e8e056337ed286f31468aaa39bc9d9a/litert_lm_api-0.13.1-py3-none-manylinux_2_27_x86_64.whl";
      hash = "sha256-uYHVXgV76WZPMGcNXB+qbnOK1RaiYX29rBDca1tAnMo=";
    };

    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [
      stdenv.cc.cc.lib
      vulkan-loader
    ];
    pythonImportsCheck = [ "litert_lm" ];
  };

  litert-lm-builder = python3Packages.buildPythonPackage {
    pname = "litert-lm-builder";
    version = "0.13.0";
    format = "wheel";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/24/5c/6396a8994ebdf42a8cceb069f6e0014c578b67cd4d2b70ebba33e533d8f5/litert_lm_builder-0.13.0-py3-none-any.whl";
      hash = "sha256-s6RpaKK/Sc0pBZowp2wHOK4LkMOcfBSA21BgczMh11c=";
    };

    propagatedBuildInputs = with python3Packages; [
      absl-py
      flatbuffers
      protobuf
      tomli
    ];
  };
in
python3Packages.buildPythonApplication {
  pname = "litert-lm";
  inherit version;
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/21/44/cdf075a78547d6dc2b5a34776ab5bd65a6643283b97f7f8f62ca110eea2a/litert_lm-0.13.1-py3-none-any.whl";
    hash = "sha256-I5CglpPz1yjs+tVhGbMmqfnjAtKQE5L/dbAlBAyjZbk=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    huggingface-hub
    litert-lm-api
    litert-lm-builder
    prompt-toolkit
    typing-extensions
  ];

  pythonImportsCheck = [ "litert_lm" ];

  meta = {
    description = "Command-line tool for LiteRT-LM";
    homepage = "https://github.com/google-ai-edge/LiteRT-LM";
    license = lib.licenses.asl20;
    mainProgram = "litert-lm";
    platforms = [ "x86_64-linux" ];
  };
}

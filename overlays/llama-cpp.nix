final: prev: {
  llama-cpp = prev.llama-cpp.override {
    vulkanSupport = true;
  };
}

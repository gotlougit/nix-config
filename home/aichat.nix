{ pkgs, ... }: {
  xdg.configFile."aichat/config.yaml".text = ''
    model: llama-cpp-service
    clients:
    - type: openai-compatible
      name: llama-cpp-service
      api_base: http://localhost:8080/v1
      api_key: null
      models:
      - name: llama
        temperature: 0.8
  '';
  home.packages = with pkgs; [ aichat ];
}

{
  description = "Collection of flake templates";

  outputs = { self }: {
    templates = {
      rust-fenix = {
        path = ./templates/rust/fenix;
        description = "Rust project with fenix for toolchain management";
      };

      rust-mcp-server = {
        path = ./templates/rust/mcp-server;
        description = "Rust starter for MCP server development";
      };

      rust-devshell = {
        path = ./templates/rust/devshell;
        description = "Minimal Rust development environment (LSP-focused)";
      };
      
      default = self.templates.rust-fenix;
    };
  };
}

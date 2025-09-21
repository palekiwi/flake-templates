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
      
      default = self.templates.rust-fenix;
    };
  };
}

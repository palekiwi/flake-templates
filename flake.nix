{
  description = "Collection of flake templates";

  outputs = { self }: {
    templates = {
      rust-fenix = {
        path = ./templates/rust/fenix;
        description = "Rust project with fenix for toolchain management";
      };

      rust-mcp = {
        path = ./templates/rust/mcp;
        description = "Rust starter for MCP server development";
      };
      
      default = self.templates.rust-fenix;
    };
  };
}

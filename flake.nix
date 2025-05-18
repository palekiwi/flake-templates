{
  description = "Collection of flake templates";

  outputs = { self }: {
    templates = {
      rust-fenix = {
        path = ./templates/rust/fenix;
        description = "Rust project with fenix for toolchain management";
      };
      
      default = self.templates.rust-fenix;
    };
  };
}

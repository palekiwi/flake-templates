# MCP SSE Server Template Implementation Plan

## Project Overview
Create a Nix flake template in `templates/rust/mcp-server/` that provides a complete development environment for building MCP (Model Context Protocol) servers with SSE (Server-Sent Events) transport in Rust.

## Key Features to Include
1. **SSE Server**: HTTP server with real-time communication via Server-Sent Events
2. **Basic Tool Example**: Simple filesystem operations tool to demonstrate MCP tool development
3. **Complete Development Environment**: Rust toolchain, dependencies, and development tools
4. **Ready-to-run Boilerplate**: Minimal but functional server that can be extended

## Implementation Details

### 1. flake.nix (High Priority)
- Based on fenix template pattern but with MCP-specific dependencies
- Include Rust 1.85 toolchain via fenix (from rust-toolchain.toml)
- Add development tools: `rust-analyzer`, `cargo-watch`, `cargo-edit`, `cargo-expand`
- Add runtime dependencies for SSE server: likely need `openssl` for HTTPS support
- Shell hook with helpful startup message and version info

### 1.5. rust-toolchain.toml (High Priority)
- Specify Rust channel: "1.85"
- Components: rustc, rust-std, cargo, clippy, rustfmt, rust-docs

### 2. Cargo.toml (High Priority)  
- Edition: `"2024"`
- Core dependencies:
  - `rmcp = { version = "0.6.4", features = ["server", "macros", "transport-sse-server", "schemars"] }`
  - `tokio = { version = "1", features = ["macros", "rt", "rt-multi-thread", "io-std", "signal"] }`
  - `serde = { version = "1.0", features = ["derive"] }`
  - `serde_json = "1.0"`
  - `anyhow = "1.0"`
  - `tracing = "0.1"`
  - `tracing-subscriber = { version = "0.3", features = ["env-filter", "std", "fmt"] }`
  - `axum = { version = "0.8", features = ["macros"] }` (for HTTP server)
  - `tokio-util = "0.7"`
  - `schemars = "1.0"` (for JSON schema generation)

### 3. src/main.rs (High Priority)
- SSE server setup based on `counter-sse-example.md`
- Bind to `127.0.0.1:8000` by default
- SSE endpoint at `/sse`, message endpoint at `/message`
- Graceful shutdown with Ctrl+C handling
- Integration with custom tool service instead of just Counter
- Proper error handling and logging setup

### 4. src/tools.rs (Medium Priority)
- Create a simple "FileSystem" tool service with basic operations:
  - `list_files` - List files in a directory 
  - `read_file` - Read file contents
  - `write_file` - Write content to a file
  - `get_file_info` - Get file metadata
- Use the `#[tool_router]` and `#[tool]` macros pattern
- Include proper error handling and validation
- Demonstrate JSON schema usage for parameters

### 5. README.md (Medium Priority)
- Quick start guide
- How to run the server: `nix develop && cargo run`
- How to test with MCP Inspector
- Example client connections
- How to add new tools
- Architecture explanation
- Links to MCP specification and rust-sdk docs

### 6. Additional Files (Lower Priority)
- **`.gitignore`**: Standard Rust gitignore
- **`examples/client.rs`**: Simple client connection example for testing
- **`src/lib.rs`**: Library structure for reusable components

## Key Design Decisions

1. **SSE over stdio**: SSE provides better web integration and easier testing with browsers
2. **Filesystem tools**: More practical than counter example, shows real-world usage
3. **Modular structure**: Separate tools into their own module for extensibility  
4. **Development-focused**: Include comprehensive tooling for productive development
5. **Documentation-heavy**: Emphasize learning and getting started quickly

## Expected File Structure
```
templates/rust/mcp-server/
├── .envrc                    # (existing)
├── .gitignore               # Standard Rust gitignore
├── flake.nix                # Nix development environment
├── Cargo.toml               # Rust project configuration
├── README.md                # Usage guide and documentation
├── src/
│   ├── main.rs              # SSE server entry point  
│   ├── lib.rs               # Library structure
│   └── tools.rs             # Filesystem tools implementation
├── examples/
│   └── client.rs            # Test client example
└── ai_docs/                 # (existing documentation)
```

## Implementation Tasks

### High Priority
1. Create flake.nix with Rust toolchain and MCP dependencies
2. Create Cargo.toml with rmcp and SSE server dependencies
3. Implement basic SSE server main.rs with FileSystem service

### Medium Priority
4. Create example tool module with basic filesystem operations
5. Add README.md with usage instructions and examples

### Low Priority
6. Create .gitignore for Rust project
7. Add example client connection script for testing

## Benefits
This template will provide developers with everything needed to start building MCP servers with SSE transport, including practical examples and a complete development environment.
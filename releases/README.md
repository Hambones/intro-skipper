Release artifacts for hosting via GitHub Pages

How this repo expects releases to be published for the fork:

- `docs/manifest.json` — a plugin catalog manifest used by Jellyfin when adding a custom repository.
- `releases/` — directory (or GitHub Pages path) where ZIP bundles are uploaded. The `PackageUrl` in the manifest should point to the public URL of the ZIP (for example: `https://hambones.github.io/intro-skipper/releases/intro-skipper-1.2.3.zip`).

Workflow (quick):

1. Build the plugin (dotnet publish / dotnet build) and collect the plugin DLL and web UI files.
2. Run the packaging script in `scripts/` to produce a ZIP in the `releases/` folder.
3. Update `docs/manifest.json` with the new `Version` and `PackageUrl`.
4. Push changes and publish the repository with GitHub Pages (site must serve `docs/` or `releases/` paths).

Note: This folder contains only guidance and placeholder files. The actual ZIPs will be created by the packaging scripts.

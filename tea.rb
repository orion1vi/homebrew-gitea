class Tea < Formula
  desc "A command line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  version "0.8.0"

  os = OS.mac? ? "darwin" : "linux"
  arch = case Hardware::CPU.arch
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "tea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "tea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.io/tea/#{version}/#{@@filename}.xz"
  @@sha256 = case "#{os}-#{arch}"
             when "linux-amd64" then "29976cc605f0da406efdc010d4a63ff225f990ebb49efe9f54ecf5c5796e771e"
             when "linux-arm64" then "55d5fc581c98abadfef9c9bea1f8e7f9d82552632272147a0e8ca9dfe27b0f82"
             when "darwin-amd64" then "8d9aaef2c9e851759a575892d5af8dd2130f0b9c5705189572a282f812126a48"
             when "darwin-arm64" then "50c14a8bee6df16483eb370dc5491e85db3a0f1a21c8d3790e0b4be0531cf6bd"
             else
               raise "tea: Unsupported system #{os}-#{arch}"
             end

  url @@url
  sha256 @@sha256

  conflicts_with "tea-head", because: "both install tea binaries"
  bottle :unneeded
  def install
    filename = Tea.class_variable_get("@@filename")
    bin.install filename => "tea"
  end

  test do
    system "#{bin}/tea", "--version"
  end
end

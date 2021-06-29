class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.14.3"

  os = OS.mac? ? "darwin-10.12" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "gitea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "gitea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.io/gitea/#{version}/#{@@filename}.xz"
  @@sha256 = case "#{os}-#{arch}"
             when "linux-386" then "c34f9c6cc5150334b2d85b0db319e035c93abf380c545e7561f5472089d320ed"
             when "linux-amd64" then "38d358d135e37aac6c783fe1f6ebe97fd29782b5c1f69d15418d746d41aa6ab9"
             when "linux-arm64" then "0a4751b54f3a89db1f5cb488da0d6eb80b92c559400fe8369a4a8f1ea3460e3f"
             when "darwin-10.12-amd64" then "40a3188ef4b498141786af2243403c92b9bed1d476c370faa42aa5b5fb95433d"
             when "darwin-10.12-arm64" then "71fed124fde0da8443569398e57f96353302dbe08c1bfd68657a02c98235f624"
             else
               raise "gitea: Unsupported system #{os}-#{arch}"
             end

  url @@url
  sha256 @@sha256

  conflicts_with "gitea-head", because: "both install gitea binaries"
  bottle :unneeded
  def install
    filename = Gitea.class_variable_get("@@filename")
    bin.install filename => "gitea"
  end

  test do
    system "#{bin}/gitea", "--version"
  end
end

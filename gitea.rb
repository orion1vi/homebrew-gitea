class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.15.0"

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
             when "linux-386" then "74ed632f53209e615c43b84fe1d4fc3d1447bd0a8ad2d597dc462154a3885971"
             when "linux-amd64" then "b225a1ce2f88528731b95929c8a727db690e8dcc6d145e5aae21f1c8b07190df"
             when "linux-arm64" then "8acc4fe0b1a02d42c07b60706c65a818278019063a94205243dd2208e8645e63"
             when "darwin-10.12-amd64" then "aa11dcac9c1b050d2f9bd9dff9bd460f2814deffd9b5abfdfaeee0ec000e5bbb"
             when "darwin-10.12-arm64" then "8370e03b346e4892c3a2c360dc874094abfa64257a5a3e1b947daf3d27538575"
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

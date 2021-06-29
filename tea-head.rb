class TeaHead < Formula
  desc "A command line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  version "0.7.0"

  os = OS.mac? ? "darwin" : "linux"
  arch = case Hardware::CPU.arch
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "tea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "tea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.io/tea/#{version}/#{@@filename}.xz"
  @@sha256 = %x[ curl -sL #{@@url}.sha256 ].split.first

  url @@url
  sha256 @@sha256

  conflicts_with "tea", because: "both install tea binaries"
  bottle :unneeded
  def install
    filename = TeaHead.class_variable_get("@@filename")
    bin.install filename => "tea"
  end

  test do
    system "#{bin}/tea", "--version"
  end
end
